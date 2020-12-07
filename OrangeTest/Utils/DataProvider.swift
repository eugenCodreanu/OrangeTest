//
//  DataProvider.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/6/20.
//

import Foundation
import UIKit

typealias ImageResult = (UIImage?) -> Void

class DataProvider {
        
    var imageCache = NSCache<NSString, UIImage>()
    
    static func storeImage(urlString: String, image: UIImage){
       
        let path = NSTemporaryDirectory().appending(UUID().uuidString)
        let url = URL(fileURLWithPath: path)
        let data = image.jpegData(compressionQuality: 0.5)
        try? data?.write(to: url)
        var dict = UserDefaults.standard.object(forKey: "ImageChache") as? [String:String]
        if dict  == nil {
            dict = [String:String]()
        }
        dict![urlString] = path
        UserDefaults.standard.set(dict, forKey: "ImageChache")
    }
    
    func downloadImageWitchCache(urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let dict = UserDefaults.standard.object(forKey: "ImageChache") as? [String:String]{           
            if let path = dict[urlString]{
                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)){
                    let img = UIImage(data: data)
                    print("Load cache Image")
                    completion(img)
                    return
                }
            }
        }
        guard let url =  URL(string: urlString) else {return}
        let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {return}
            guard let d = data else {return}
            DispatchQueue.main.async {
                if let image = UIImage(data: d) {
                    DataProvider.storeImage(urlString: urlString, image: image)
                    print("Dowmload Image")
                    completion(image)
                }
            }
        }
        dataTask.resume()
    }
    
    
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
                     
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            print("Load chache image")
            completion(cachedImage)
        } else {
            //let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            
            let dataTask = URLSession.shared.dataTask(with: url){ [weak self] data, response, error in
                guard error == nil,
                    data != nil,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    let self = self else { return }
                
                guard let image = UIImage(data: data!) else { return }
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    print("Download image")
                    completion(image)
                }
            }
            dataTask.resume()
        }
    }
}
