//
//  SpecialsViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 1.07.2024.
//

import UIKit

protocol SpecialsViewControllerProtocol: AnyObject {
    func reloadData()
    func showLoadingView()
    func hideLoadingView()
}

class SpecialsViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var pickerLabel: UILabel!
    @IBOutlet weak var labelContainer: UIView!
    var presenter: SpecialsPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        presenter?.fetchData(selectedType: pickerLabel.text ?? "")
      
    }

    @IBAction func changeButtonClicked(_ sender: Any) {
        let previousText = pickerLabel.text
        let bottomSheetVC = BottomSheetViewController(
            data: presenter?.getOptions().map({$0.rawValue}) ?? [],
            selectedOption: pickerLabel.text,
            optionSelected: { [weak self] selectedOption in
                guard let self else { return }
                pickerLabel.text = selectedOption
                if previousText != selectedOption {
    
                    collectionView.scrollToItem(at: [0,0], at: .top, animated: false)
                    presenter?.removeAllMovies()
                    ///To change currentPage value when type is changed
                    presenter?.currentPage = 1
                    presenter?.fetchData(selectedType: selectedOption)
            
                }
            }
        )
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.modalTransitionStyle = .crossDissolve
        present(bottomSheetVC, animated: true, completion: nil)
    }
    
}

extension SpecialsViewController: SpecialsViewControllerProtocol {
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        self.hideLoading()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

private extension SpecialsViewController {
    final func initialSetup() {
        pickerLabel.text = presenter?.getOptions()[0].rawValue
        labelContainer.layer.cornerRadius = 10
        labelContainer.backgroundColor = .systemGray5
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellType: MovieCell.self)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
}


extension SpecialsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.fetchedMovies?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: MovieCell.self, for: indexPath)
        guard let movieResult = presenter?.fetchedMovies?[safe: indexPath.row] else { return UICollectionViewCell()}
        let presenter = MoviePresenter(view: cell, movieResult: movieResult)
        cell.cellPresenter = presenter
        return cell
    }
}


extension SpecialsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movieId = presenter?.fetchedMovies?[indexPath.row].id else { return }
        presenter?.didSelect(movieId: movieId)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if presenter?.fetchedMovies?.count == indexPath.row + 1 {
            presenter?.loadMoreData(selectedType: pickerLabel.text ?? "")
        }
    }
}

extension SpecialsViewController {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(160))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
            
            return section
        }
    }
}
