//
//  NasaTabbarController.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

import UIKit
import CoreAPI

@available(iOS 13.0, *)
final class NasaTabbarController: UITabBarController {
    
    // MARK: Create VIPER Modules
    let curiosityVC = CuriosityRouter.createModule()
    let opportunityVC = OpportunityRouter.createModule()

    
    private let spiritViewController = UIStoryboard(name: Constants.System.Storyboard.main, bundle: .main)
        .instantiateViewController(identifier: Constants.System.Controller.spiritViewController) as! SpiritViewController
    
    // MARK: View Models
    private let spiritViewModel = SpiritViewModel(networkManager: NetworkManager())
    
    private let curiorsityNavigationController: NasaNavigationController
    private let opportunityNavigationController: NasaNavigationController
    
    init() {

        spiritViewController.viewModel = spiritViewModel

        self.curiorsityNavigationController = NasaNavigationController(rootViewController: curiosityVC)
        self.opportunityNavigationController = NasaNavigationController(rootViewController: opportunityVC)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        delegate = self
        
        curiorsityNavigationController.delegate = self
        curiorsityNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: Constants.Style.Image.Icon.firstTab),
            tag: 0
        )
                
        opportunityNavigationController.delegate = self
        opportunityNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: Constants.Style.Image.Icon.secondTab),
            tag: 1
        )
        
        let spiritNavigationController = NasaNavigationController(rootViewController: spiritViewController)
        
        spiritNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: Constants.Style.Image.Icon.thirdTab),
            tag: 2
        )
        
        let navigationControllers = [
            curiorsityNavigationController,
            opportunityNavigationController,
            spiritNavigationController
        ]
        
        navigationControllers.forEach {
            $0.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        
        setViewControllers(navigationControllers, animated: false)
        
        tabBar.barTintColor = .separator
        tabBar.tintColor = .nasaOrange
        tabBar.backgroundColor = .clear
        
        tabBar.layer.masksToBounds = true
        tabBar.layer.cornerRadius = 20
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
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
           viewController === curiorsityNavigationController {
            if curiorsityNavigationController.viewControllers.count > 1 {
                curiorsityNavigationController.popViewController(animated: true)
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
