//
//  DetailViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 24.06.2024.
//

import UIKit
import Kingfisher

protocol DetailViewControllerProtocol: AnyObject {
    func setImage(imageUrlString: String)
}

class DetailViewController: UIViewController {

    
    //TODO: Butonlara işlev eklenecek
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var imdbImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: DetailPresenterProtocol?
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let presenter = presenter as? DetailPresenter {
              presenter.delegate = self
          }
        presenter?.loadDatas()
        setupCollectionView()
        imdbImage.image = UIImage(named: "imdb")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.descriptionTextView.flashScrollIndicators()
        }
        setupImdbButton()
        setupFavoriteButton()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        descriptionTextView.flashScrollIndicators()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: SimilarMovieCell.self)
        collectionView.collectionViewLayout = createCompositionalLayout()
        
    }
    
    @IBAction func addToFavoriteTapped(_ sender: Any) {
        guard let movieId = presenter?.movieId else { return }
        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []
        if let index = favorites.firstIndex(of: movieId) {
            favorites.remove(at: index)
        } else {
            favorites.append(movieId)
        }
        UserDefaults.standard.set(favorites, forKey: "favorites")
        setupFavoriteButton()
    }
    
}
    
extension DetailViewController: DetailViewControllerProtocol {
    func setImage(imageUrlString: String) {
        let url = URL(string: imageUrlString)
        bannerImage.kf.indicatorType = .activity
        bannerImage.contentMode = .scaleToFill
        bannerImage.kf.setImage(with: url) { result in
            switch result {
            case .success(let data):
                self.bannerImage.image = data.image
            case .failure(let error):
                print("Görüntü yüklenirken hata oluştu: \(error.localizedDescription)")
                self.bannerImage.image = UIImage(named: "noImage")
            }
        }
    }
    
    
}

extension DetailViewController: DetailPresenterDelegate {
    func fetchedSimilars() {
        collectionView.reloadData()
    }
    
    func fetchedDetails() {
        let details = presenter?.getDetails()
        descriptionTextView.text = details?.overview ?? "No Info"
        movieName.text = details?.original_title ?? "Unknown"
        detailLabel.text = String(format: "🌟 Rating: %.1f", details?.vote_average ?? 0)
    }
    
    
}


extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getSimilars().count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let similars = presenter?.getSimilars() else { return UICollectionViewCell()}
        let cell = collectionView.dequeueReusableCell(with: SimilarMovieCell.self, for: indexPath)
        let presenter = SimilarMoviePresenter(view: cell, similarMovieResult: similars[indexPath.row] )
        cell.cellPresenter = presenter
        return cell
    }
    
}

//MARK: Compositional Layout
extension DetailViewController {
    private func createSimilarsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(140),  heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
            return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
                self.createSimilarsSection()
            }
        }
}

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let similars = presenter?.getSimilars() else { return }
        guard let movieId = similars[indexPath.row].id else { return }
        ///for disabling go back can be change movieID
//        presenter?.movieId = movieId
        
        if let cell = collectionView.cellForItem(at: indexPath) {
                UIView.animate(withDuration: 0.2,
                               animations: {
                    cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.2) {
                        cell.transform = CGAffineTransform.identity
//                        let transition = self.createFadeTransition()
//                        self.view.layer.add(transition, forKey: nil)
                        ///for disabling go back can be change movieID
//                        self.presenter?.loadDatas()
                        self.presenter?.didSelect(movieId: movieId)

                    }
                })
            }
    }
}

//Helpers
extension DetailViewController {
    private func createFadeTransition() -> CATransition {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        return transition
    }
}

extension DetailViewController {
    private func setupImdbButton() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imdbImageTapped(_:)))
            imdbImage.isUserInteractionEnabled = true
            imdbImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func imdbImageTapped(_ sender: UITapGestureRecognizer) {
        guard let imdbID = presenter?.getDetails()?.imdb_id else { return }
        let imdbUrlString = "https://www.imdb.com/title/\(imdbID)/"
        guard let imdbUrl = URL(string: imdbUrlString) else { return }
        UIApplication.shared.open(imdbUrl)
    }
    
    private func setupFavoriteButton() {
        guard let movieId = presenter?.movieId else { return }
        var favorites = UserDefaults.standard.array(forKey: "favorites") as? [Int] ?? []
        if favorites.contains(movieId) {
            addToFavoriteButton.setTitle("Remove From Favorites", for: .normal)
        } else {
            addToFavoriteButton.setTitle("Add to Favorites", for: .normal)
        }
 
    }
}
