//
//  LaunchListPresenter.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/5/20.
//

import Foundation
import UIKit


protocol LaunchListModuleProtocol: AnyObject {
    func addLaunchesToContents(list: [LaunchModel])
    func clearLaunchContent()
}


protocol LaunchListPresenterProtocol: LaunchCellViewDelegate{
    var lauchesList:[LaunchModel]? {get set}
    init(view: LaunchListModuleProtocol, router: RouterBasicProtocol, apiService: ApiServiceProtocol, realmDatabase:RealmDBProtocols)
    func getLastLaunches()
    func navigateToFavoriteModule()
    func loadLaunchesPerPagination()
    func refreshLauchList()
    func checkLaunchViewIsFavorite(id: String) -> Bool
}


class LaunchListPresenter: LaunchListPresenterProtocol {
           
    weak var view: LaunchListModuleProtocol?
    var router: RouterBasicProtocol?
    var apiService: ApiServiceProtocol?
    var realmDatabase:RealmDBProtocols
    var lauchesList:[LaunchModel]?
    var internalPagination:Int = 10;
    var nextIndex: Int = 0
    var curentIndex:Int = 0
    
    required init(view: LaunchListModuleProtocol, router: RouterBasicProtocol, apiService: ApiServiceProtocol, realmDatabase:RealmDBProtocols) {
        self.view = view
        self.router = router
        self.apiService = apiService
        self.realmDatabase = realmDatabase
    }
    
    func navigateToFavoriteModule(){
        router?.navigateToFavoritesModule()
    }
    
    func getLastLaunches(){        
        router?.setPreloader(status: true)
        apiService?.getLauchesList(completion: { [weak self](response) in
            guard let self = self else {return}
            self.router?.setPreloader(status: false)
            switch response{
                case .success(let lauchesList):
                    self.lauchesList = lauchesList
                    self.loadLaunchesPerPagination()
                case .failure(let errorMessage):
                    self.router?.showSimpleAlert(message: errorMessage)
                }
        })
    }
    
       
    func loadLaunchesPerPagination(){
        if let lauchesList = lauchesList{
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
   }
    
    
    func refreshLauchList(){       
        nextIndex = 0
        curentIndex = 0
        lauchesList?.removeAll()
        view?.clearLaunchContent()
        getLastLaunches()
    }
    
    func checkLaunchViewIsFavorite(id: String) -> Bool{
        return realmDatabase.objectExist(id: id) 
    }
}

extension LaunchListPresenter: LaunchCellViewDelegate {
    func onAddToFavorite(model:LaunchModel, target: LaunchCellView){
        target.isFavorite = !realmDatabase.objectExist(id: model.id)        
        realmDatabase.checkObjectExistence(newModel: model.convertToRealm())        
    }
    
    func onLaunchViewSelect(model: LaunchModel) {        
        self.router?.navigateToLaucnhDetailModule(model: model)
    }
}
