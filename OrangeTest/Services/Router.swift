//
//  Router.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/5/20.
//

import Foundation
import UIKit

/**
 Define navigation protocols
 */
protocol RouterBasicProtocol: MainControllerProtocol{
    var navigationController: UINavigationController? { get set }
    var moduleAssembler: ModuleAssemblerProtocol? { get set }
    var rootView: MainControllerProtocol? { get set }
    init(rootView: MainControllerProtocol, navigationController: UINavigationController, moduleAssembler: ModuleAssemblerProtocol)
    func initiateViewController(controllerType: ControllerType)
    func navigateToLaucnhDetailModule(model: LaunchModel)
    func navigateToFavoritesModule()
    func navigateToPopModule()
    func navigateToRootModule()
    
}
/**
 Custom router class, that will manages all navigation methods
 */
class Router: RouterBasicProtocol {
      
    var navigationController: UINavigationController?
    var moduleAssembler: ModuleAssemblerProtocol?
    weak var rootView: MainControllerProtocol?
    
    required init(rootView: MainControllerProtocol, navigationController: UINavigationController, moduleAssembler: ModuleAssemblerProtocol) {
        self.navigationController = navigationController
        self.rootView = rootView
        self.moduleAssembler = moduleAssembler
    }
    
    func initiateViewController(controllerType: ControllerType) {
        if navigationController != nil {
            if( controllerType == .launchList){
                guard let launchListController = moduleAssembler?.createLaunchListModule(router: self) else {return}
                navigationController?.viewControllers = [launchListController]
            }
        }
    }
    
    func navigateToLaucnhDetailModule(model: LaunchModel){
        if navigationController != nil {
            guard let launchDetails = moduleAssembler?.createLaunchDetailsModule(router: self, model: model) else { return }
            navigationController?.pushViewController(launchDetails, animated: true)
        }
    }
    
    func navigateToFavoritesModule(){
        if navigationController != nil {
            guard let favoriteModule = moduleAssembler?.createFavoriteModule(router: self) else {return}
            navigationController?.pushViewController(favoriteModule, animated: true)
        }
    }
    
    func navigateToPopModule(){
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func navigateToRootModule() {
        if navigationController != nil {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func setPreloader(status: Bool) {
        rootView?.setPreloader(status: status)
    }
    
    func showSimpleAlert(message: String) {
        rootView?.showSimpleAlert(message: message)
    }
    
    func hideEditableTexts() {
        rootView?.hideEditableTexts()
    }
}
