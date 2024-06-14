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

protocol MainScreenViewControllerProtocol: AnyObject {
    func reloadData()
  
}

class MainScreenViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var presenter: MainScreenPresenterProtocol?
    private var dataSource: UICollectionViewDiffableDataSource<MainScreenSectionType, MovResult>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchInitialData()
        setupCollectionView()
        setupSearchBar()
    }
}

//MARK:  Setups
extension MainScreenViewController {
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.register(cellType: BannerCell.self)
        collectionView.register(cellType: MovieCell.self)
        collectionView.registerReusableView(nibWithViewClass: SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        
        configureDataSource()
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
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
        addSupplementaryViews()
    }
    
    private func addSupplementaryViews() {
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionType = MainScreenSectionType(rawValue: indexPath.section) else { return UICollectionReusableView() }
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: SectionHeader.self, for: indexPath)
            switch sectionType {
            case .banner:
                guard let minDate = self.presenter?.getDates().0,
                      let maxDate = self.presenter?.getDates().1 else {
                    headerView.configure(with: "")
                    return headerView
                }
                headerView.configure(with: "\(minDate) / \(maxDate) Posters")
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
        //TODO: Go to detail page with selected movie
        print("Selected Movie ID: \(String(describing: movResult.id))")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        ///To prevent load more date when search is active
        guard searchBar.text?.count == 0 else { return }
        if offsetY > contentHeight - height {
            presenter?.loadMoreData()
        }
    }
}

//MARK: UISearchBarDelegate
extension MainScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.search(text: searchText)
      }
}


//MARK: MainScreenViewControllerProtocol
extension MainScreenViewController: MainScreenViewControllerProtocol {

    func reloadData() {
        applySnapshot()
    }
}


