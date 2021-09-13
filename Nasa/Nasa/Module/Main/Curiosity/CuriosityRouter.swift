//
//  CuriosityRouter.swift
//  Nasa
//
//  Created by bahadir on 13.09.2021.
//

import UIKit

final class CuriosityRouter {
    
    weak var navigationController: NasaNavigationController?
    
    init(navigationController: NasaNavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    static func createModule() -> CuriosityViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(identifier: "CuriosityViewController") as! CuriosityViewController
        let interactor = CuriosityInteractor()
        let presenter = CuriosityPresenter(view: view, interactor: interactor)
        view.presenter = presenter
        interactor.output = presenter
        return view
    }
}
