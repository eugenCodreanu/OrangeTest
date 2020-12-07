//
//  Launches.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/5/20.
//

import Foundation

struct LaunchModel: Codable{
        var id:String
        var rocket:String?
        var details:String?
        var date:String?
        var links:Links?
        var name: String?
        
    
        enum CodingKeys: String, CodingKey{
            case id = "id"
            case links = "links"
            case rocket = "rocket"
            case details = "details"
            case name = "name"
            case date = "date_local"
        }
    
    func getPatchFirstImage() -> String? {
        if let links = links {
            if let patch = links.patch {
                /*
                if let urlPathLarge = patch.large{
                    return urlPathLarge
                }*/                
                if let urlPathSmal = patch.small{
                    return urlPathSmal
                }                
            }
        }
        return nil
    }
    
}


struct  Patch: Codable  {
    var small:String?
    var large:String?
    
    enum CodingKeys: String, CodingKey{
        case large = "large"
        case small = "small"
    }
}

struct Links:Codable {
    var youtube:String?
    var wikipedia:String?
    var patch: Patch?
    
    enum CodingKeys: String, CodingKey{
        case youtube = "youtube_id"
        case wikipedia = "wikipedia"
        case patch = "patch"
    }
}



