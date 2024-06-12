//
//  OnboardingViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import UIKit

protocol OnboardingViewControllerProtocol: AnyObject {
    func makeAlert(title: String, message: String)
}

//MARK: OnboardingViewController
final class OnboardingViewController: BaseViewController {
//TODO: For one time onboarding screen add userdefaults control
    
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var presenter: onboardingPresenterProtocol?
    var controllers = [UIViewController]()
    var firstPage = FirstPageViewController()
    var secondPage = SecondPageViewController()
    var pageVC = UIPageViewController()


    override func viewDidLoad() {
        super.viewDidLoad()
        controllers.append(firstPage)
        controllers.append(secondPage)
        secondPage.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupPageViewController()
        presenter?.viewDidAppear()
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        let nextIndex = pageController.currentPage + 1
        pageController.currentPage = nextIndex
        guard let nextVC = controllers[safe: nextIndex] else {
            presenter?.goToMainScreen()
            return
        }
        pageVC.setViewControllers([nextVC], direction: .forward, animated: true)
        setupLastonboardingScreen(index: nextIndex)
        
    }
    
    @IBAction func skipButtonClicked(_ sender: Any) {
        presenter?.goToMainScreen()
    }
}

//MARK: OnboardingViewControllerProtocol
extension OnboardingViewController: OnboardingViewControllerProtocol {
    func makeAlert(title: String, message: String) {
        showAlert(title: title, message: message, completion: nil)
    }
}

//MARK: UIPageViewControllerDelegate
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

//MARK: UIPageViewControllerDataSource
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


//MARK: PageVC Setups
extension OnboardingViewController {
    
    func setupPageViewController() {
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
    
   private final func setupLastonboardingScreen(index: Int) {
       guard index == controllers.count - 1 else {
           skipButton.isHidden = false
           nextButton.setTitle("Next", for: .normal)
           return
       }
       skipButton.isHidden = true
       nextButton.setTitle("Start >>", for: .normal)
    }
}

//MARK: SecondPageDelegate
extension OnboardingViewController: SecondPageDelegate {
    func startButtonClicked() {
        presenter?.goToMainScreen()
    }
}
