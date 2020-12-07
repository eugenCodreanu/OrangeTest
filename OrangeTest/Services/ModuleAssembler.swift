//
//  ModuleAssembler.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/5/20.
//

import Foundation
import UIKit
/**
 Define view controlelr assmebler protocols
 */
protocol ModuleAssemblerProtocol {
    func createLaunchListModule(router: RouterBasicProtocol) -> UIViewController
    func createLaunchDetailsModule(router: RouterBasicProtocol, model: LaunchModel) -> UIViewController
    func createFavoriteModule(router: RouterBasicProtocol) -> UIViewController
}

/**
 Custom class what will assemble proper view controller with proper presenter and services
 */
class ModuleAssembler: ModuleAssemblerProtocol {
    
    func createLaunchListModule(router: RouterBasicProtocol) -> UIViewController {
        let view = LaunchListModule()
        let apiService = ApiService()
        let database = RealmDB()
        let presenter = LaunchListPresenter(view: view, router: router, apiService: apiService, realmDatabase: database)
        view.presenter = presenter
        return view
    }
    
    func createLaunchDetailsModule(router: RouterBasicProtocol, model: LaunchModel) -> UIViewController {
        let view = LaunchDetailsModule()
        let apiService = ApiService()
        let presenter = LauchDetailPresenter(view: view, router: router, apiService: apiService, model: model)
        view.presenter = presenter
        return view
    }
    
    func createFavoriteModule(router: RouterBasicProtocol) -> UIViewController{
        let view = FavoritesModule()
        let apiService = ApiService()
        let database = RealmDB()
        let presenter = FavoritesPresenter(view: view, router: router, apiService: apiService, realmDatabase: database)
        view.presenter = presenter
        return view
    }
}
