//
//  NasaTabbarController.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

import UIKit
import CoreAPI

class NasaTabbarController: UITabBarController {

    // MARK: View controllers
    let curiosityViewController = CuriosityViewController()
    let opportunityViewController = OpportunityViewController()
    let spiritViewController = SpiritViewController()
    
    // MARK: View Models
    let curiosityViewModel = CuriosityViewModel(networkManager: NetworkManager())
    
    let nasaNavigationController: NasaNavigationController
    
    init() {
        curiosityViewController.viewModel = curiosityViewModel
        self.nasaNavigationController = NasaNavigationController(rootViewController: curiosityViewController)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        delegate = self

        nasaNavigationController.delegate = self
        nasaNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "paperplane.fill"),
            tag: 0
        )
        
        let opportunityNavigationController = NasaNavigationController(rootViewController: opportunityViewController)
        opportunityNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "ticket.fill"), tag: 1)
        
        let spiritNavigationController = NasaNavigationController(rootViewController: spiritViewController)
        spiritNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "powersleep"), tag: 2)

        let navigationControllers = [
            nasaNavigationController,
            opportunityNavigationController,
            spiritNavigationController
        ]
        navigationControllers.forEach {
            $0.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }

        setViewControllers(navigationControllers, animated: false)

        tabBar.barTintColor = .white
        tabBar.tintColor = .nasaOrange
        tabBar.shadowImage = UIImage()
    }
    
    func tabBarControllerSupportedInterfaceOrientations(
        _ tabBarController: UITabBarController
    ) -> UIInterfaceOrientationMask {
        .portrait
    }

    func tabBarControllerPreferredInterfaceOrientationForPresentation(
        _ tabBarController: UITabBarController
    ) -> UIInterfaceOrientation {
        .portrait
    }
}

extension NasaTabbarController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        if selectedViewController === viewController,
            viewController === nasaNavigationController {
            if nasaNavigationController.viewControllers.count > 1 {
                nasaNavigationController.popViewController(animated: true)
            } else {

            }
        }
        return true
    }
}

extension NasaTabbarController: UINavigationControllerDelegate {

    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        viewController.extendedLayoutIncludesOpaqueBars = true
    }
}
