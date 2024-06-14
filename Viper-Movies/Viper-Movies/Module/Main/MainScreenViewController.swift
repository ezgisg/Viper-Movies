//
//  MainScreenViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 12.06.2024.
//

import UIKit

enum MainScreenSectionType: Int {
    case banner = 0
    case movieList = 1
}

protocol MainScreenViewControllerProtocol: AnyObject {
    func reloadData()
}

class MainScreenViewController: UIViewController, UICollectionViewDelegate {
    


    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var presenter: MainScreenPresenterProtocol?
    private var dataSource: UICollectionViewDiffableDataSource<MainScreenSectionType, MovResult>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
        setupCollectionView()
        configureDataSource()
        applySnapshot()
        configureCollectionViewLayout()
    
    }
    
    private func configureCollectionViewLayout() {
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.register(cellType: BannerCell.self)
        collectionView.register(cellType: MovieCell.self)
    }
    
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
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                   heightDimension: .fractionalHeight(0.3))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            
            return section
        }
        
        private func createMovieListSection() -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(150))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            return section
        }
}

extension MainScreenViewController: MainScreenViewControllerProtocol {
    func reloadData() {
        applySnapshot()
    }
}


//TODO: comp layout
//MARK: Collection view functions

extension MainScreenViewController {
    
    //MARK: configure method
    private func configure<T: UICollectionViewCell>(_ cellType: T.Type, with source: MovResult, for indexPath: IndexPath) -> T {
        let cell = collectionView.dequeueReusableCell(with: cellType, for: indexPath)
        
        if let bannerCell = cell as? BannerCell {
            let presenter = BannerPresenter(view: bannerCell, movieResult: source)
            bannerCell.cellPresenter = presenter
        } else if let movieCell = cell as? MovieCell {
            let presenter = MoviePresenter(view: movieCell, movieResult: source)
            movieCell.cellPresenter = presenter
        }
        return cell
    }
    

    
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, movResult in
            guard let sectionType = MainScreenSectionType(rawValue: indexPath.section) else { return UICollectionViewCell() }
            switch sectionType {
            case .banner:
               return self.configure(BannerCell.self, with: movResult, for: indexPath)
            case .movieList:
                return self.configure(MovieCell.self, with: movResult, for: indexPath)
            }
        })
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<MainScreenSectionType, MovResult>()
        snapshot.appendSections([.banner, .movieList])
        if let movies = presenter?.getMovies() {
            snapshot.appendItems(movies, toSection: .movieList)
        }
        
        if let banners = presenter?.getBanners() {
            snapshot.appendItems(banners, toSection: .banner)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
     }
     
}

