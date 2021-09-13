//
//  OnboardingPageViewController.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

import CHIPageControl
import UIKit
import SnapKit

class OnboardingPageViewController: UIPageViewController {

    private var pages = [OnboardingViewController]()
    private let pageControl = CHIPageControlJaloro()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .nasaOrange

        pages = [
            OnboardingInfoViewController(
                title: "Nasa App",
                subtitle: "For Appcent Case.",
                animation: "space"
            ),
            OnboardingInfoViewController(
                title: "Nasa Photos",
                subtitle: "See More",
                animation: "transactions"
            )
        ]

        pages.forEach({ $0.delegate = self })

        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        pageControl.tintColor = UIColor(white: 1, alpha: 0.3)
        pageControl.currentPageTintColor = .white
        pageControl.padding = 16
        pageControl.elementWidth = 24
        pageControl.elementHeight = 5
        pageControl.radius = 2.5
        pageControl.numberOfPages = pages.count
        pageControl.set(progress: 0, animated: true)
        view.addSubview(pageControl)

        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
        }
    }
}

extension OnboardingPageViewController: OnboardingViewControllerDelegate {

    func onboardingViewControllerDidTapNext(_ viewController: OnboardingViewController) {
        if let viewControllerIndex = pages.firstIndex(of: viewController) {
            if viewControllerIndex < pages.count - 1 {
                setViewControllers(
                    [pages[viewControllerIndex + 1]],
                    direction: .forward,
                    animated: true,
                    completion: nil
                )
                self.pageControl.set(progress: viewControllerIndex + 1, animated: true)
            } else if viewControllerIndex == pages.count - 1 {
                let eateryTabBarController = NasaTabbarController()
                guard let appDelegate = UIApplication.shared.delegate else {
                    return
                }
                appDelegate.window??.rootViewController = eateryTabBarController
            }
        }
    }

}
