//
//  FavoriteModel.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/6/20.
//

import Foundation
import RealmSwift



class LaunchModelRm: Object {
    @objc dynamic var id:String = ""
    @objc dynamic var rocket:String? = nil
    @objc dynamic var details:String? = nil
    @objc dynamic var date:String? = nil
    @objc dynamic var links:LinksRM? = nil
    @objc dynamic var name: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
}


class  PatchRM: Object  {
    @objc dynamic var small:String? = nil
    @objc dynamic var large:String? = nil
   
}
class LinksRM: Object{
    @objc dynamic var youtube:String? = nil
    @objc dynamic var wikipedia:String? = nil
    @objc dynamic var patch: PatchRM? = nil
}

