//
//  OpportunityRouter.swift
//  Nasa
//
//  Created by bahadir on 13.09.2021.
//

import UIKit

final class OpportunityRouter {
    
    weak var navigationController: NasaNavigationController?
    
    init(navigationController: NasaNavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    static func createModule() -> OpportunityViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(identifier: "OpportunityViewController") as! OpportunityViewController
        let interactor = OpportunityInteractor()
        let presenter = OpportunityPresenter(view: view, interactor: interactor)
        view.presenter = presenter
        interactor.output = presenter
        return view
    }
}
