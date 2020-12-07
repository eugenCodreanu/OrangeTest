//
//  FavoritesPresenter.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/6/20.
//

import Foundation
import UIKit
import RealmSwift

protocol FavoritesModuleProtocol: AnyObject {
    func addLaunchesToContents(list: [LaunchModel])
    func updateFavoriteContent()
    func clearLaunchContent()
}


protocol FavoritesPresenterProtocol: LaunchCellViewDelegate{
    var lauchesList:[LaunchModel] {get set}
    init(view: FavoritesModuleProtocol, router: RouterBasicProtocol, apiService: ApiServiceProtocol, realmDatabase:RealmDBProtocols)
    func getFavortieListFromDB()
    func loadLaunchesPerPagination()  
    func gotoLaunchesModule()
}

class FavoritesPresenter: FavoritesPresenterProtocol {
                
    weak var view: FavoritesModuleProtocol?
    var router: RouterBasicProtocol?
    var apiService: ApiServiceProtocol?
    var realmDatabase:RealmDBProtocols
    var lauchesList = [LaunchModel]()
    var internalPagination:Int = 10;
    var nextIndex: Int = 0
    var curentIndex:Int = 0
    
    required init(view: FavoritesModuleProtocol, router: RouterBasicProtocol, apiService: ApiServiceProtocol, realmDatabase:RealmDBProtocols) {
        self.view = view
        self.router = router
        self.apiService = apiService
        self.realmDatabase = realmDatabase
    }
    
    
    func getFavortieListFromDB(){
        let project:Results<LaunchModelRm> = realmDatabase.getAllProjects()
        project.forEach { model in
            lauchesList.append(model.convertToCodable())
        }
        loadLaunchesPerPagination()
    }
           
       
    func loadLaunchesPerPagination(){
        if (curentIndex >= lauchesList.count) {return}
        if (curentIndex + internalPagination) < lauchesList.count {
                nextIndex += internalPagination
        }else{
                nextIndex = lauchesList.count
        }            
        let newArray = Array(lauchesList[curentIndex..<nextIndex])
        self.view?.addLaunchesToContents(list: newArray)
        curentIndex += internalPagination
   }
    
    
    func gotoLaunchesModule(){       
        router?.navigateToPopModule()
    }
}

extension FavoritesPresenter: LaunchCellViewDelegate {
    func onAddToFavorite(model: LaunchModel, target: LaunchCellView) {
        realmDatabase.removeFromFavoriteAppart(id: model.id) {[weak self] (success) in
            guard let self = self else {return}
            if success {
                self.lauchesList.remove(at: target.tag - 1)
                target.removeFromSuperview()
                self.view?.updateFavoriteContent()
            }
        }
    }    
       
    func onLaunchViewSelect(model: LaunchModel) {
        self.router?.navigateToLaucnhDetailModule(model: model)
    }
}
