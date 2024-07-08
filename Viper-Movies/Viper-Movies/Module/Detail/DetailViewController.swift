//
//  DetailViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 24.06.2024.
//

import UIKit

// MARK: - DetailViewControllerProtocol
protocol DetailViewControllerProtocol: BaseViewControllerProtocol {
    func setImage(imagePath: String)
    func reloadData()
    func showLoadingView()
    func hideLoadingView()
}

// MARK: - DetailViewController
class DetailViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addToFavoriteButton: UIButton!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var imdbImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Module Components
    var presenter: DetailPresenterProtocol?
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.delegate = self
        presenter?.loadDatas()
        setupViews()
        showLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        descriptionTextView.flashScrollIndicators()
        setupFavoriteButton()
    }
}

// MARK: - DetailViewControllerProtocol
extension DetailViewController: DetailViewControllerProtocol {
    func setImage(imagePath: String) {
        bannerImage.loadImage(with: imagePath, cornerRadius: 0)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
}

// MARK: - DetailPresenterDelegate
extension DetailViewController: DetailPresenterDelegate {
    func fetchedDetails() {
        let details = presenter?.getDetails()
        descriptionTextView.text = details?.overview ?? "No Info"
        movieName.text = details?.title ?? "Unknown"
        detailLabel.text = String(format: "🌟 Rating: %.1f", details?.vote_average ?? 0)
    }
}

// MARK: - CollectionViewDataSource
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

// MARK: - Compositional Layout
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
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            return createSimilarsSection()
        }
    }
}

// MARK: - CollectionViewDelegate
extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let similars = presenter?.getSimilars(),
              let movieId = similars[indexPath.row].id else { return }
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2,
                           animations: {
                cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: { _ in
                UIView.animate(withDuration: 0.2) { [weak self] in
                    guard let self else { return }
                    cell.transform = CGAffineTransform.identity
                    presenter?.didSelect(movieId: movieId)
                }
            })
        }
    }
}

// MARK: - Configuration of View
extension DetailViewController {
    private func setupImdbButton() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imdbImageTapped(_:)))
        imdbImage.isUserInteractionEnabled = true
        imdbImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    ///To go to imdb web page of movie
    @objc private func imdbImageTapped(_ sender: UITapGestureRecognizer) {
        guard let imdbID = presenter?.getDetails()?.imdb_id else { return }
        let imdbUrlString = "https://www.imdb.com/title/\(imdbID)/"
        guard let imdbUrl = URL(string: imdbUrlString) else { return }
        UIApplication.shared.open(imdbUrl)
    }
    
    private func setupFavoriteButton() {
        addToFavoriteButton.titleLabel?.textAlignment = .center
        guard let movieId = presenter?.movieId,
              let decoded = presenter?.getFromUserDefaults() else { return }
        if decoded.contains(where: { $0.id == movieId }) {
            addToFavoriteButton.setTitle("Remove From Favorites", for: .normal)
        } else {
            addToFavoriteButton.setTitle("Add to Favorites", for: .normal)
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: SimilarMovieCell.self)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    ///To save or remove from userdefaults "favorites"
    @IBAction func addToFavoriteTapped(_ sender: Any) {
        presenter?.saveToUserDefaults()
        setupFavoriteButton()
    }
    
    private func setupViews() {
        imdbImage.image = UIImage(named: "imdb")
        setupCollectionView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.descriptionTextView.flashScrollIndicators()
        }
        setupImdbButton()
        setupFavoriteButton()
    }
}
