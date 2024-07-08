//
//  MainScreenViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.

// TODO: - Firebase Integration
// TODO: - UITest

import UIKit

// MARK: - Enums
enum MainScreenSectionType: Int, CaseIterable {
    case banner = 0
    case movieList = 1
}

enum SearchType: String {
    case local = "Search in theaters"
    case service = "Search in all"
}

// MARK: - MainScreenViewControllerProtocol
protocol MainScreenViewControllerProtocol: BaseViewControllerProtocol {
    var movieListHeaderTitle:  String  { get set }
    var isLocalSearchActive: Bool { get set }
    
    func reloadCollectionViewData()
    func reloadTableViewData(data: [MovResult])
    func showLoadingView()
    func hideLoadingView()
}

// MARK: - MainScreenViewController
final class MainScreenViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchChangeButton: UIButton!
    @IBOutlet private weak var searchMainView: SearchMainView!
    
    // MARK: - Private Variables
    private var dataSource: UICollectionViewDiffableDataSource<MainScreenSectionType, MovResult>?
    private var localSearchAction: UIAction!
    private var serviceSearchAction: UIAction!
    private var searchWorkItem: DispatchWorkItem?
    private var isLocalSearch = true {
        didSet {
            setupSearchChangeButton()
        }
    }
    
    // MARK: - Global Variables
    var isLocalSearchActive = false {
        didSet {
            guard oldValue != isLocalSearchActive else { return }
            applySnapshot(shouldAnimate: false)
        }
    }
    var movieListHeaderTitle: String = Constants.Titles.upcoming {
        didSet {
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.reloadData()
        }
    }
    
    // MARK: - Constants
    private let searchTypingDelay = 0.5
    
    // MARK: - Module Components
    var presenter: MainScreenPresenterProtocol?
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
        presenter?.fetchInitialData()
        setupCollectionView()
        setupSearchBar()
        setupKeyboardObservers()
        searchMainView.delegate = self
    }
}

// MARK: - Setups
private extension MainScreenViewController {
    final func setupCollectionView() {
        collectionView.delegate = self
        collectionView.register(cellType: BannerCell.self)
        collectionView.register(cellType: MovieCell.self)
        collectionView.registerReusableView(nibWithViewClass: SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        
        configureDataSource()
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    final func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "\(SearchType.local.rawValue)..."
        setupSearchChangeButton()
    }
    
    final func setupSearchChangeButton() {
        let localSearchActionState: UIMenuElement.State = isLocalSearch ? .on : .off
        let serviceSearchActionState: UIMenuElement.State = isLocalSearch ? .off : .on
        
        localSearchAction = UIAction(title: SearchType.local.rawValue, image: UIImage(systemName: "pencil.circle"), attributes: [], state: localSearchActionState) { [weak self] action in
            guard let self else { return }
            searchBar.placeholder = "\(SearchType.local.rawValue)..."
            isLocalSearch = true
        }
        
        serviceSearchAction = UIAction(title: SearchType.service.rawValue, image: UIImage(systemName: "pencil.circle"), attributes: [], state: serviceSearchActionState) { [weak self] action in
            guard let self else { return }
            searchBar.placeholder = "\(SearchType.service.rawValue)..."
            isLocalSearch = false
        }
        
        lazy var elements: [UIAction] = [localSearchAction, serviceSearchAction]
        lazy var menu = UIMenu(title: "Chose search type...", children: elements)
        
        searchChangeButton.showsMenuAsPrimaryAction = true
        searchChangeButton.menu = menu
        controlSearchViewVisibility()
    }
}

// MARK: - Diffable Data Source
private extension MainScreenViewController {
    final func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, movResult in
            guard let sectionType = MainScreenSectionType(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch sectionType {
            case .banner:
                let cell = collectionView.dequeueReusableCell(with: BannerCell.self, for: indexPath)
                let presenter = BannerPresenter(view: cell, movieResult: movResult)
                cell.cellPresenter = presenter
                return cell
            case .movieList:
                let cell = collectionView.dequeueReusableCell(with: MovieCell.self, for: indexPath)
                let presenter = MoviePresenter(view: cell, movieResult: movResult)
                cell.cellPresenter = presenter
                return cell
            }
        })
        configureSupplementaryViewsDataSource()
    }
    
    final func configureSupplementaryViewsDataSource() {
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self else { return UICollectionReusableView()}
            guard let sectionType = MainScreenSectionType(rawValue: indexPath.section) else { return UICollectionReusableView() }
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: SectionHeader.self, for: indexPath)
            switch sectionType {
            case .banner:
                if let minDate = presenter?.getDates().0,
                   let maxDate = presenter?.getDates().1 {
                    headerView.configure(with: "\(minDate) - \(maxDate) Posters")
                }
            case .movieList:
                headerView.configure(with: movieListHeaderTitle)
            }
            return headerView
        }
    }
    
    final func applySnapshot(shouldAnimate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<MainScreenSectionType, MovResult>()
        for section in MainScreenSectionType.allCases {
            snapshot.appendSections([section]) }
        if let movies = presenter?.getMovies() {
            snapshot.appendItems(movies, toSection: .movieList)
        }
        if let banners = presenter?.getBanners(), !isLocalSearchActive {
            snapshot.appendItems(banners, toSection: .banner)
        }
        dataSource?.apply(snapshot, animatingDifferences: shouldAnimate)
    }
}

// MARK: - Compositional Layout
private extension MainScreenViewController {
    final func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self,
                  let sectionType = MainScreenSectionType(rawValue: sectionIndex) else { return nil }
            switch sectionType {
            case .banner:
                ///To remove banner section when local search is active
                guard isLocalSearchActive == false else { return nil }
                return createBannerSection()
            case .movieList:
                return createMovieListSection()
            }
        }
    }
    
    final func createBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),  heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    final func createMovieListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
}

// MARK: - UICollectionViewDelegate
extension MainScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// To prevent didSelectItemAt in first (banner) section
        guard dataSource?.sectionIdentifier(for: indexPath.section) == .movieList,
              let movResult = dataSource?.itemIdentifier(for: indexPath),
              let movieId = movResult.id else { return }
        presenter?.didSelect(movieId: movieId)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        ///To prevent load more date when search is active
        guard searchBar.text?.count == 0 else { return }
        if offsetY > contentHeight - height {
            showLoadingView()
            presenter?.loadMoreData()
        }
    }
}

// MARK: - UISearchBarDelegate
extension MainScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        controlSearchChangeButton(text: searchText)
        searchWorkItem?.cancel()
        if isLocalSearch {
            presenter?.searchLocal(text: searchText)
        } else {
            ///Added delay between last text change and request to prevent too many requests to the API
            searchWorkItem = DispatchWorkItem { [weak self] in
                guard let self else { return }
                presenter?.searchService(text: searchText)
            }
        }
        guard let searchWorkItem else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + searchTypingDelay, execute: searchWorkItem)
    }
}

// MARK: - SearchMainViewDelegate
extension MainScreenViewController: SearchMainViewDelegate {
    func tappedSeeMore() {
        presenter?.seeMoreSelected(query: searchBar.text ?? "")
    }
    
    func didSelect(movieId: Int) {
        presenter?.didSelect(movieId: movieId)
    }
}

// MARK: - Helpers
private extension MainScreenViewController {
    /// To manage "search view" show-hide status
    final func controlSearchViewVisibility() {
        searchMainView.isHidden = isLocalSearch
    }
    
    /// To manage "search change button" and "searchbar cancel button" show-hide status
    final func controlSearchChangeButton(text: String) {
        let shouldHideSearchChangeButton = text.count != 0
        searchChangeButton.isHidden = shouldHideSearchChangeButton
    }
}

// MARK: - MainScreenViewControllerProtocol
extension MainScreenViewController: MainScreenViewControllerProtocol {
    func reloadTableViewData(data: [MovResult]) {
        let isSearchActive = searchBar.text?.count != 0
        searchMainView.checkVisibilityOfViews(isSearchActive: isSearchActive, resultCount: data.count)
        let presenter = SearchMainPresenter(view: searchMainView, movies: data)
        searchMainView.cellPresenter = presenter
        searchMainView.isUserInteractionEnabled = true
    }
    
    func reloadCollectionViewData() {
        applySnapshot()
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
}
