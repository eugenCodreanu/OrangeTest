//
//  RocketModel.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/7/20.
//

import Foundation

struct RocketModel:Codable {    
    var name:String?
    var mass:RocketMass?
    
    enum CodingKeys: String, CodingKey{
        case name = "name"
        case mass = "mass"
    }
}

struct RocketMass:Codable {
    var kg:Int?
    var lb:Int?
   
    enum CodingKeys: String, CodingKey{
        case kg = "kg"
        case lb = "lb"
    }
}


