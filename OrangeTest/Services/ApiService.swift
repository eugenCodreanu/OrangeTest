//
//  ApiService.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/5/20.
//

import Foundation
import Alamofire

typealias LaunchesResult = (ApiResult<[LaunchModel],String>) -> Void
typealias RoketResult = (ApiResult<RocketModel,String>) -> Void

enum ApiUrls: String {
    case lastLaunches = "launches/past"
    case roketID = "rockets/{id}"
   
}


protocol ApiServiceProtocol: AnyObject{
    func getLauchesList(completion: @escaping LaunchesResult)
    func getRoketName(id:String, completion: @escaping RoketResult)
}


class ApiService: ApiServiceProtocol {
    
    static var baseURL = "https://api.spacexdata.com/v4/";
        
    func getLauchesList(completion: @escaping LaunchesResult){
        
        var req = URLRequest(url: URL(string: urlPath(.lastLaunches))!)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("public, max-age=\(500000)", forHTTPHeaderField: "Cache-Control")
        req.cachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
        req.timeoutInterval = 30        
        let request = AF.request(req).validate()
        request.responseData { (response) in
            if let error = response.error{
                completion(.failure(error.errorDescription ?? "SERVER_ERROR".localize))
                return
            }
            if let data = response.data {
                if let launcehsList = data.decodeData(type: [LaunchModel].self){
                    completion(.success(launcehsList))
                }else {
                    completion(.failure("DECODE_ERRRO".localize))
                }
            }
       }
    }
    
    func getRoketName(id:String, completion: @escaping RoketResult){       
        let request = AF.request(urlPath(.roketID, id: id) , method: .get, encoding: URLEncoding(destination: .queryString)).validate()
        request.responseData { (response) in            
            if let error = response.error{
                completion(.failure(error.errorDescription ?? "SERVER_ERROR".localize))
                return
            }
            if let data = response.data {
                if let rocketModel = data.decodeData(type: RocketModel.self){
                    completion(.success(rocketModel))
                }else {
                    completion(.failure("DECODE_ERRRO".localize))
                }
            }
       }
    }
        
     
    private func urlPath(_ path: ApiUrls) -> String {
            return ApiService.baseURL.appending(path.rawValue)
        }
   
      private  func urlPath(_ path: ApiUrls, id: String) -> String {
            var path:String = path.rawValue
            path = path.replacingOccurrences(of: "{id}", with: id)
            return ApiService.baseURL.appending(path)
    }
}
