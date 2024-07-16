//
//  SearchMainView.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 3.07.2024.
//

import UIKit

// MARK: - SearchMainViewProtocol
protocol SearchMainViewProtocol: AnyObject {
    var movies: [MovResult] { get set }
    func reloadData()
}

// MARK: - SearchMainViewDelegate
protocol SearchMainViewDelegate {
    func didSelect(movieId: Int)
    func tappedSeeMore()
}

// MARK: - SearchMainView
final class SearchMainView: UIView, NibOwnerLoadable {

    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var noResultView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var seeMoreButton: UIButton!
    @IBOutlet private weak var containerStackView: UIStackView!
    @IBOutlet private weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var noResultLabel: UILabel!
    
    // MARK: - Module Components
    var cellPresenter: SearchMainPresenter? {
        didSet {
            cellPresenter?.load()
        }
    }
    
    // MARK: - Private Variables
    private var query: String = ""
    private var elementCountToDisplay: Int = 3
    
    // MARK: - Global Variables
    var movies: [MovResult] = []
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

// MARK: - SearchMainViewProtocol
extension SearchMainView : SearchMainViewProtocol {
    func reloadData() {
        tableView.reloadData() {
            DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
                guard let self else { return }
                updateTableViewHeight()
            }
        }
    }
}

// MARK: - Helpers
extension SearchMainView {
    ///To control no result view and see more button show-hide status
    final func checkVisibilityOfViews(isSearchActive: Bool, resultCount: Int) {
        seeMoreButton.setTitle(L10n.seeMore.localized(), for: .normal)
        let isMoreThanShow = resultCount > elementCountToDisplay
        let isResultExist = resultCount != 0
        let isNoResultActive = isSearchActive && !isResultExist
        let isSeeMoreActive = isSearchActive && isResultExist && isMoreThanShow
        noResultView.isHidden = !isNoResultActive
        seeMoreButton.isHidden = !isSeeMoreActive
    }
    
    private final func updateTableViewHeight() {
        let height = tableView.contentSize.height
        tableViewHeight.constant = height
        tableView.layoutIfNeeded()
    }
}

// MARK: - View Setups
private extension SearchMainView {
    final func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(nibWithCellClass: SearchCell.self)
    }
    
    final func setupInitialSettingsTableView() {
        seeMoreButton.isHidden = true
        noResultView.isHidden = true
        
        containerView.backgroundColor = .systemGray5
        containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        containerView.layer.cornerRadius = 20
        
        noResultView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        noResultView.layer.cornerRadius = 20
        noResultView.backgroundColor = .systemGray5
        noResultView.layer.borderWidth = 0.2
        noResultLabel.text = L10n.noResult.localized()
        
        containerStackView.layer.shadowColor = UIColor.black.cgColor
        containerStackView.layer.shadowOpacity = 0.5
        containerStackView.layer.shadowOffset = CGSize(width: 0, height: 10)
        containerStackView.layer.shadowRadius = 5
    }
}

// MARK: - UITableViewDataSource
    extension SearchMainView: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return min(movies.count, elementCountToDisplay)
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withClass: SearchCell.self)
            let movie = movies[indexPath.row]
            cell.configure(with: movie)
            return cell
        }
    }

// MARK: - UITableViewDelegate
extension SearchMainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        ///To resize tableviews height simultaneously when result count is change
        guard min(movies.count, elementCountToDisplay) >= indexPath.row else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)  { [weak self] in
            guard let self else { return }
            updateTableViewHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieId = movies[indexPath.row].id else { return }
        delegate?.didSelect(movieId: movieId)
    }
}



