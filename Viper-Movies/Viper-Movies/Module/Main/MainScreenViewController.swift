//
//  MainScreenViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import UIKit

enum MainScreenSectionType: Int, CaseIterable {
    case banner = 0
    case movieList = 1
}

enum SearchType: String {
    case local = "Search in theaters"
    case service = "Search in all"
}

protocol MainScreenViewControllerProtocol: AnyObject {
    func reloadCollectionViewData()
    func reloadTableViewData(data: [MovResult])
    func showLoadingView()
    func hideLoadingView()
}

class MainScreenViewController: UIViewController, LoadingShowable {
        
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchChangeButton: UIButton!
    @IBOutlet weak var searchMainView: SearchMainView!
    private var dataSource: UICollectionViewDiffableDataSource<MainScreenSectionType, MovResult>?
    
    private var tapGesture: UITapGestureRecognizer!
    private var localSearchAction: UIAction!
    private var serviceSearchAction: UIAction!
    private var searchWorkItem: DispatchWorkItem?

    private var isLocalSearch = true {
        didSet {
            setupSearchChangeButton()
        }
    }
    
    var presenter: MainScreenPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingView()
        presenter?.fetchInitialData()
        setupCollectionView()
        setupSearchBar()
        setupKeyboardObservers()
    }
}

//MARK:  Setups
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
        
        self.localSearchAction = UIAction(title: SearchType.local.rawValue, image: UIImage(systemName: "pencil.circle"), attributes: [], state: localSearchActionState) { action in
            self.searchBar.placeholder = "\(SearchType.local.rawValue)..."
            self.isLocalSearch = true
        }
        
        self.serviceSearchAction = UIAction(title: SearchType.service.rawValue, image: UIImage(systemName: "pencil.circle"), attributes: [], state: serviceSearchActionState) { action in
            self.searchBar.placeholder = "\(SearchType.service.rawValue)..."
            self.isLocalSearch = false
        }
        
        lazy var elements: [UIAction] = [localSearchAction, serviceSearchAction]
        lazy var menu = UIMenu(title: "Chose search type..", children: elements)
        
        searchChangeButton.showsMenuAsPrimaryAction = true
        searchChangeButton.menu = menu
        controlSearchView()
    }
    
    ///To manage "search change button" and "search bar cancel button" show-hide status
    final func controlSearchChangeButton(text: String) {
        if text.count == 0 {
            searchChangeButton.isHidden = false
            searchMainView.changeSeeMoreButtonVisibility(isHidden: true)
        } else {
            searchChangeButton.isHidden = true
            searchMainView.changeSeeMoreButtonVisibility(isHidden: false)
        }
    }
}

//MARK: Diffable Data Source
extension MainScreenViewController {
    private func configureDataSource() {
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
        supplementaryViewsDataSource()
    }
    
    private func supplementaryViewsDataSource() {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionType = MainScreenSectionType(rawValue: indexPath.section) else { return UICollectionReusableView() }
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: SectionHeader.self, for: indexPath)
            switch sectionType {
            case .banner:
                if let minDate = self.presenter?.getDates().0,
                   let maxDate = self.presenter?.getDates().1 {
                    headerView.configure(with: "\(minDate) - \(maxDate) Posters")
                }
            case .movieList:
                headerView.configure(with: "Upcoming Movies")
            }
            return headerView
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<MainScreenSectionType, MovResult>()
        for section in MainScreenSectionType.allCases {
            snapshot.appendSections([section]) }
        if let movies = presenter?.getMovies() {
            snapshot.appendItems(movies, toSection: .movieList)
        }
        if let banners = presenter?.getBanners() {
            snapshot.appendItems(banners, toSection: .banner)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
        
     }
}

//MARK: Compositional Layout
extension MainScreenViewController {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
            return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                guard let sectionType = MainScreenSectionType(rawValue: sectionIndex) else { return nil }
                switch sectionType {
                case .banner:
                    return self.createBannerSection()
                case .movieList:
                    return self.createMovieListSection()
                }
            }
        }
        
        private func createBannerSection() -> NSCollectionLayoutSection {
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
        
        private func createMovieListSection() -> NSCollectionLayoutSection {
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

//MARK: UICollectionViewDelegate
extension MainScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        guard let movResult = dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let movieId = movResult.id else { return }
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

//MARK: UISearchBarDelegate
extension MainScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        controlSearchChangeButton(text: searchText)
        searchWorkItem?.cancel()
            if self.isLocalSearch {
                self.presenter?.searchLocal(text: searchText)
            } else {
                ///To prevent too much request to api
                searchWorkItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.presenter?.searchService(text: searchText)
            }
        }
        guard let searchWorkItem else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: searchWorkItem)
    }
}


//MARK: MainScreenViewControllerProtocol
extension MainScreenViewController: MainScreenViewControllerProtocol {
    func reloadTableViewData(data: [MovResult]) {
        searchMainView.loadData(data: data)
    }
    
    func reloadCollectionViewData() {
        applySnapshot()
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        self.hideLoading()
    }
}

//MARK: Keyboard operations
private extension MainScreenViewController {

    private func setupKeyboardObservers() {
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
      }

      @objc private func keyboardWillShow() {
          if tapGesture == nil {
              tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
          }
          view.addGestureRecognizer(tapGesture)
      }
      
      @objc private func keyboardWillHide() {
          if tapGesture != nil {
              view.removeGestureRecognizer(tapGesture)
          }
      }
      
      @objc private func dismissKeyboard() {
          view.endEditing(true)
      }
}

//MARK: Control Operations of ServiceSearchView
private extension MainScreenViewController {
    final func controlSearchView() {
        guard isLocalSearch == false else {
            searchMainView.isHidden = true
            return }
        searchMainView.isHidden = false
    }
}



