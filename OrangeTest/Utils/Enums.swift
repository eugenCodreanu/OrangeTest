//
//  Enums.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/5/20.
//

import Foundation

enum ControllerType {
    case launchList
    case launchDetails
}


enum ApiResult<Success, Failure>{
    case success(Success)
    case failure(Failure)
}
