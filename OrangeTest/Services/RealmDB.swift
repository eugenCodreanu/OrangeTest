//
//  RealmDB.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/6/20.
//

import Foundation
import RealmSwift


protocol RealmDBProtocols:AnyObject {
      
    func addToFavorite(_ model: LaunchModelRm)
    func removeToFavorite(_ model: LaunchModelRm)
    func getAllProjects() -> Results<LaunchModelRm>
    func clearDatabase()
    func objectExist (id: String) -> Bool
    func checkObjectExistence(newModel: LaunchModelRm)
    func removeFromFavoriteAppart(id: String, completion: @escaping (Bool) -> Void)
}

class RealmDB: RealmDBProtocols  {
    
   static let shared = RealmDB()
   var realm:Realm!
   init() {
        realm = try! Realm()
    }
    
    func objectExist (id: String) -> Bool {
            return realm.object(ofType: LaunchModelRm.self, forPrimaryKey: id) != nil
    }
    
    func checkObjectExistence(newModel: LaunchModelRm){
        if let model =  realm.object(ofType: LaunchModelRm.self, forPrimaryKey: newModel.id) {
            try! realm.write {
                realm.delete(model)
            }
        }else{
            try! realm.write {
                realm.add(newModel)
            }
        }
    }
    
    func addToFavorite(_ model: LaunchModelRm){
            try! realm.write {
                realm.add(model)
                NotificationCenter.default.post(name: Notification.Name("addNewItem"), object: model)
            }       
    }
       
    
    func removeToFavorite(_ model: LaunchModelRm){
        try! realm.write {
            realm.delete(model)
            NotificationCenter.default.post(name: Notification.Name("removeNewItem"), object: model)
        }
    }
    
    func removeFromFavoriteAppart(id: String, completion: @escaping (Bool) -> Void){
        if let model =  realm.object(ofType: LaunchModelRm.self, forPrimaryKey: id) {
            do {
                 try realm.write {
                    realm.delete(model)
                    completion(true)
                    }
                } catch {
                    completion(false)
                }
        }
    }
    
    func getAllProjects() -> Results<LaunchModelRm> {
        return  realm.objects(LaunchModelRm.self).sorted(byKeyPath: "id", ascending: false)
    }
   
    func clearDatabase(){
        try! realm.write {
            realm.deleteAll()
        }
    }
       
        
}
