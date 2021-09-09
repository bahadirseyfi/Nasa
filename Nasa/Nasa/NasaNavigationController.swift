//
//  NasaNavigationController.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

import UIKit

class NasaNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // allow swipe back gesture even if navigation bar is hidden
        interactivePopGestureRecognizer?.delegate = nil

        navigationBar.prefersLargeTitles = true
        navigationBar.barTintColor = .white
        navigationBar.tintColor = .nasaOrange
        if #available(iOS 13.0, *) {
            navigationBar.standardAppearance = .nasaDefault
            navigationBar.scrollEdgeAppearance = .nasaDefault
        } else {
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navigationBar.isTranslucent = false
        }
    }
}
