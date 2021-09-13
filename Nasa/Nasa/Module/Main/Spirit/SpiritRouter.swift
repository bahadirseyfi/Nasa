//
//  SpiritRouter.swift
//  Nasa
//
//  Created by bahadir on 13.09.2021.
//

import UIKit

final class SpiritRouter {
    
    weak var navigationController: NasaNavigationController?
    
    init(navigationController: NasaNavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    static func createModule() -> SpiritViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(identifier: "SpiritViewController") as! SpiritViewController
        let interactor = SpiritInteractor()
        let presenter = SpiritPresenter(view: view, interactor: interactor)
        view.presenter = presenter
        interactor.output = presenter
        return view
    }
}
