//
//  OnboardingViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import UIKit

// MARK: - OnboardingViewControllerProtocol
protocol OnboardingViewControllerProtocol: AnyObject {
    func makeAlert(title: String, message: String)
}

// MARK: - OnboardingViewController
final class OnboardingViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet private weak var pageController: UIPageControl!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var skipButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    // MARK: - Module Components
    var presenter: OnboardingPresenterProtocol?
    
    // MARK: - Private Variables
    private var controllers = [UIViewController]()
    private var firstPage = FirstPageViewController()
    private var secondPage = SecondPageViewController()
    private var pageVC = UIPageViewController()

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPageViewController()
        presenter?.viewDidAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        controllers.append(contentsOf: [firstPage, secondPage])
        secondPage.delegate = self
        skipButton.setTitle(L10n.skip.localized(), for: .normal)
        nextButton.setTitle(L10n.next.localized(), for: .normal)
    }
}

// MARK: - Buttons action
extension OnboardingViewController {
    @IBAction func nextButtonClicked(_ sender: Any) {
        let nextIndex = pageController.currentPage + 1
        pageController.currentPage = nextIndex
        guard let nextVC = controllers[safe: nextIndex] else {
            presenter?.goToTabBar()
            return
        }
        pageVC.setViewControllers([nextVC], direction: .forward, animated: true)
        setupLastonboardingScreen(index: nextIndex)
    }
    
    @IBAction func skipButtonClicked(_ sender: Any) {
        presenter?.goToTabBar()
    }
}

// MARK: - OnboardingViewControllerProtocol
extension OnboardingViewController: OnboardingViewControllerProtocol {
    func makeAlert(title: String, message: String) {
        showAlert(title: title, message: message, completion: nil)
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
        let visibleViewController = pageViewController.viewControllers?.first,
        let index = controllers.firstIndex(of: visibleViewController) {
            pageController.currentPage = index
            setupLastonboardingScreen(index: index)
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index > 0 else {return nil}
        let previous = index - 1
        return controllers[previous]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index < controllers.count - 1 else {return nil}
        let next = index + 1
        return controllers[next]
    }
}

// MARK: - PageVC Setups
private extension OnboardingViewController {
    final func setupPageViewController() {
        guard let first = controllers.first else { return }
        pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.modalPresentationStyle = .fullScreen
        pageVC.delegate = self
        pageVC.dataSource = self
        pageVC.setViewControllers([first], direction: .forward, animated: true)
        contentView.addSubview(pageVC.view)
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                pageVC.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                pageVC.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                pageVC.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                pageVC.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ]
        )
        pageController.numberOfPages = controllers.count
        pageController.currentPage = 0
    }
    
    final func setupLastonboardingScreen(index: Int) {
       guard index == controllers.count - 1 else {
           skipButton.isHidden = false
           nextButton.setTitle(L10n.next.localized(), for: .normal)
           return
       }
       skipButton.isHidden = true
       nextButton.setTitle("\(L10n.start.localized()) >>", for: .normal)
    }
}

// MARK: - SecondPageDelegate
extension OnboardingViewController: SecondPageDelegate {
    func startButtonClicked() {
        presenter?.goToTabBar()
    }
}
