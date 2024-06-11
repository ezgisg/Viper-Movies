//
//  SplashViewController.swift
//  Viper-Movies
//
//  Created by Ezgi Sümer Günaydın on 11.06.2024.
//

import UIKit

protocol SplashViewControllerProtocol: AnyObject {
    func makeAlert(title: String, message: String)
}

//MARK: SplashViewController
final class SplashViewController: BaseViewController {
    
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var contentView: UIView!
    
    var presenter: SplashPresenterProtocol?
    var controllers = [UIViewController]()
    var firstPage = FirstPageViewController()
    var secondPage = SecondPageViewController()
    var pageVC = UIPageViewController()


    override func viewDidLoad() {
        super.viewDidLoad()
        controllers.append(firstPage)
        controllers.append(secondPage)

    }
    
    override func viewDidAppear(_ animated: Bool) {
//        presenter?.viewDidAppear()
        setupPageViewController()
    }

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
        pageController.tintColor = .black
        pageController.currentPageIndicatorTintColor = .gray
        pageController.numberOfPages = controllers.count
        pageController.currentPage = 0
    }
    

}

//MARK: SplashViewControllerProtocol
extension SplashViewController: SplashViewControllerProtocol {
    func makeAlert(title: String, message: String) {
        showAlert(title: title, message: message)
    }
}

//MARK: UIPageViewControllerDelegate
extension SplashViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = controllers.firstIndex(of: visibleViewController) {
            pageController.currentPage = index
        }
    }
    
}

//MARK: UIPageViewControllerDataSource
extension SplashViewController: UIPageViewControllerDataSource {
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
