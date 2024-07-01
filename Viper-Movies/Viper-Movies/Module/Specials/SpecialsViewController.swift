//
//  SpecialsViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 1.07.2024.
//

import UIKit


//TODO: Öncelikli! layout ve seçime göre data yüklenmesi
//TODO: 2.öncelik loading view + 1.page'in çekilip scroll ettikçe diğerlerinin çekilmesi
protocol SpecialsViewControllerProtocol: AnyObject {
    func reloadData()
}

class SpecialsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var pickerLabel: UILabel!
    @IBOutlet weak var labelContainer: UIView!
    var presenter: SpecialsPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        presenter?.fetchInitialData(selectedType: pickerLabel.text ?? "")
      
    }


    @IBAction func changeButtonClicked(_ sender: Any) {
        let bottomSheetVC = BottomSheetViewController(
            data: presenter?.getOptions().map({$0.rawValue}) ?? [],
            selectedOption: pickerLabel.text,
            optionSelected: { [weak self] selectedOption in
                guard let self else { return }
                self.pickerLabel.text = selectedOption
            }
        )
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        bottomSheetVC.modalTransitionStyle = .crossDissolve
        present(bottomSheetVC, animated: true, completion: nil)
    }
    
}


extension SpecialsViewController: SpecialsViewControllerProtocol {
    func reloadData() {
        collectionView.reloadData()
    }
    
    
}

private extension SpecialsViewController {
    final func initialSetup() {
        pickerLabel.text = presenter?.getOptions()[1].rawValue
        labelContainer.layer.cornerRadius = 10
        labelContainer.backgroundColor = .systemGray5
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellType: MovieCell.self)
    }
}


extension SpecialsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.fetchedMovies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: MovieCell.self, for: indexPath)
        guard let movieResult = presenter?.fetchedMovies?[indexPath.row] else { return UICollectionViewCell()}
        let presenter = MoviePresenter(view: cell, movieResult: movieResult)
        cell.cellPresenter = presenter
        return cell
    }
}


extension SpecialsViewController: UICollectionViewDelegate {
    
}
