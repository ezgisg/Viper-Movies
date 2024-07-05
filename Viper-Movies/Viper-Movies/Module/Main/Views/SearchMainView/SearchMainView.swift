//
//  SearchMainView.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 3.07.2024.
//

import UIKit

//TODO: Viper mimarisine uygun olarak düzenlenecek

protocol SearchMainViewDelegate {
    func didSelect(movieId: Int)
    func tappedSeeMore()
}

class SearchMainView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var noResultView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var containerStackView: UIStackView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    var movies: [MovResult] = []
    var query: String = ""
    var delegate: SearchMainViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        setupTableView()
        setupInitialSettingsTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
        setupTableView()
        setupInitialSettingsTableView()
    }

    @IBAction func seeMoreButtonTapped(_ sender: Any) {
        delegate?.tappedSeeMore()
    }
}

extension SearchMainView {
    
    final func checkVisibilityOfViews(isSearchActive: Bool, resultCount: Int) {
        let isMoreThanShow = resultCount > 3
        let isResultExist = resultCount != 0
        let isNoResultActive = isSearchActive && !isResultExist
        let isSeeMoreActive = isSearchActive && isResultExist && isMoreThanShow
        noResultView.isHidden = !isNoResultActive
        seeMoreButton.isHidden = !isSeeMoreActive
    }
    
    final func loadData(data: [MovResult]) {
        self.movies = data
        reloadContent()
    }
    
    final func reloadContent() {
        tableView.reloadData() {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.updateTableViewHeight()
            }
        }
    }
    
    private func updateTableViewHeight() {
        let height = tableView.contentSize.height
        tableViewHeight.constant = height
        self.tableView.layoutIfNeeded()
    }
    
    func setupTableView() {
        tableView.dataSource = self
                tableView.delegate = self
        tableView.register(nibWithCellClass: SearchCell.self)
    }
    
    func setupInitialSettingsTableView() {
        seeMoreButton.isHidden = true
        noResultView.isHidden = true
        
        containerView.backgroundColor = .systemGray5
        containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        containerView.layer.cornerRadius = 20
        
        noResultView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        noResultView.layer.cornerRadius = 20
        noResultView.backgroundColor = .systemGray5
        noResultView.layer.borderWidth = 0.2
        
        containerStackView.layer.shadowColor = UIColor.black.cgColor
        containerStackView.layer.shadowOpacity = 0.5
        containerStackView.layer.shadowOffset = CGSize(width: 0, height: 10)
        containerStackView.layer.shadowRadius = 5
    }
}
    
    
    extension SearchMainView: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return min(movies.count, 3)
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withClass: SearchCell.self)
            let movie = movies[indexPath.row]
            cell.configure(with: movie)
            return cell
        }
    }
    


extension SearchMainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard min(movies.count, 3) >= indexPath.row else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.updateTableViewHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieId = movies[indexPath.row].id else { return }
        delegate?.didSelect(movieId: movieId)
    }
  
}



