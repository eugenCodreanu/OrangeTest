//
//  Extensions.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/5/20.
//

import Foundation
import UIKit

extension String {
    var localize:String{
           get {
            if let path = Bundle.main.path(forResource: C.lang, ofType: "lproj"){
               if let bundle = Bundle(path: path) {
                    return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
               }
            }
            return  self
        }
    }
    
     func extartDateTimeZone() -> String{
            let dataFormat = ISO8601DateFormatter()               
            let date = dataFormat.date(from: self)
            let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: date!)
            let month = C.months[calendarDate.month!-1].localize
            return "\(month) \(calendarDate.day!), \(calendarDate.year!)"
        }
        
    func extartDate() -> String{
            let dataFormat = DateFormatter()
            dataFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dataFormat.date(from: self)
            let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: date!)
            let month = C.months[calendarDate.month!-1].localize
            return "\(month) \(calendarDate.day!), \(calendarDate.year!)"
        }
        
    func extartDateTime() -> String{
           
            let dataFormat = DateFormatter()
            dataFormat.dateFormat = "yyyy-MM-dd HH:mm"
            let date = dataFormat.date(from: self)
            let calendarDate = Calendar.current.dateComponents([.day, .year, .month, .hour, .minute], from: date!)
            let month = C.months[calendarDate.month!-1].localize
            return "\(month) \(calendarDate.day!), \(calendarDate.hour!):\(calendarDate.minute!)"
        }
}

extension Notification.Name {
    static let mLanguageUpdate = Notification.Name("languageUpdate")
   
}

extension CGFloat{
    var px:CGFloat{
          self * C.scale;
    }
}

extension Int{
    var px:CGFloat{
         CGFloat(self) * C.scale;
    }
}


extension UILabel
{
    func autoCorrectHeight(){
        let sizeThatFitsTextView:CGSize = self.sizeThatFits(CGSize(width:self.frame.size.width, height:CGFloat(MAXFLOAT)))
        self.frame.size.height = sizeThatFitsTextView.height
    }
    
    func autoCorrectWidth(){
        let sizeThatFitsTextView:CGSize = self.sizeThatFits(CGSize(width:CGFloat(MAXFLOAT), height:self.frame.size.height))
        self.frame.size.width = sizeThatFitsTextView.width
    }
}

extension UIViewController {
    func showPopupErrorMessage(_ chekErrorMessage:String){
        let alert = UIAlertController(title: "", message: chekErrorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIView
{
    
    func putPointoOn(point: CGPoint){
           let point = UIView(frame: CGRect(x: point.x-1.px, y: point.y - 1.px, width: 2.px, height: 2.px))
           point.backgroundColor = C.RED
           point.layer.cornerRadius = 1.px
           self.addSubview(point)
       }
    
    func roundedCorners() {
           self.layer.cornerRadius = self.bounds.size.height/2
           self.clipsToBounds = true
       }
    
    func setBackgroundColor(_ color:UIColor){
        self.backgroundColor = color
    }
        
    func setPositionAnimated(posX:CGFloat? = nil,posY:CGFloat? = nil, speed:Double = 0.5){
        UIView.animate(withDuration:speed, animations: {
            if(posX != nil){
                self.frame.origin.x = posX!
            }
            if(posY != nil){
                self.frame.origin.y = posY!
            }
        })
    }
    
      var width:CGFloat {
            get {
                return self.frame.size.width
            }
          set (newValue){
              self.frame.size.width = newValue
          }
        }
        
        var height:CGFloat {
            get {
                return self.frame.size.height
            }
          set (newValue){
              self.frame.size.height = newValue
          }
        }
        
        var x:CGFloat {
            get {
                return self.frame.origin.x
            }
          set (newValue){
              self.frame.origin.x = newValue
          }
        }
        
        var y:CGFloat {
            get {
                return self.frame.origin.y
            }
          set (newValue){
              self.frame.origin.y = newValue
          }
        }
    
   
    
    
    func animateFadeIn(duration: Double, delay:Double = 0.0 , initiate:Bool = true, completion: ((Bool) -> Void)? = nil){
           //DispatchQueue.main.async {
            if initiate {self.alpha = 1.0}
            UIView.animate(withDuration: duration,delay: delay, animations: {
                   self.alpha = 0.0
               },completion: { finisedd in
                   guard let completion = completion else {return}
                   completion(finisedd)
               })
           //}
       }
       
       func animateFadeOut(duration: Double, delay:Double = 0.0 ,initiate:Bool = true,completion: ((Bool) -> Void)? = nil){
           //DispatchQueue.main.async {
            if initiate {self.alpha = 0.0}
               UIView.animate(withDuration:duration,delay: delay, animations: {
                   self.alpha = 1.0
               },completion: { finisedd in
                   guard let completion = completion else {return}
                   completion(finisedd)
               })
           //}
       }
    
    func animateMoveToX(duration: Double, value:CGFloat, delay:Double = 0.0 ,completion: ((Bool) -> Void)? = nil){
        //DispatchQueue.main.async {
            UIView.animate(withDuration:duration, delay: delay, animations: {
                self.x = value
            },completion: { finisedd in
                guard let completion = completion else {return}
                completion(finisedd)
            })
        //}
    }
    
    func animateMoveToY(duration: Double, value:CGFloat,delay:Double = 0.0 , completion: ((Bool) -> Void)? = nil){
        //DispatchQueue.main.async {
            UIView.animate(withDuration:duration, delay: delay, animations: {
                self.transform.ty = value
            },completion: { finisedd in
                guard let completion = completion else {return}
                completion(finisedd)
            })
        //}
    }
    
    func animateScaleTo(duration: Double, value:CGFloat,delay:Double = 0.0 , completion: ((Bool) -> Void)? = nil){
        //DispatchQueue.main.async {
        UIView.animate(withDuration:duration, delay: delay, options:.allowUserInteraction , animations: {
                self.transform = CGAffineTransform(scaleX: value, y: value)
            },completion: { finisedd in
                guard let completion = completion else {return}
                completion(finisedd)
            })
        //}
    }
    
    func animateMoveFromToHeight(duration: Double, from:CGFloat, to:CGFloat, delay:Double = 0.0, completion: ((Bool) -> Void)? = nil){
        //DispatchQueue.main.async {
            self.height = from
            UIView.animate(withDuration:duration, delay: delay,  animations: {
                self.height = to
            },completion: { finisedd in
                guard let completion = completion else {return}
                completion(finisedd)
            })
        //}
    }
    
    func animateMoveToHeight(duration: Double, to:CGFloat, delay:Double = 0.0, completion: ((Bool) -> Void)? = nil){
        //DispatchQueue.main.async {
            UIView.animate(withDuration:duration, delay: delay,  animations: {
                self.height = to
            },completion: { finisedd in
                guard let completion = completion else {return}
                completion(finisedd)
            })
        //}
    }
    
    func animateMoveToWidth(duration: Double, to:CGFloat, delay:Double = 0.0, completion: ((Bool) -> Void)? = nil){
        //DispatchQueue.main.async {
            UIView.animate(withDuration:duration, delay: delay,  animations: {
                self.width = to
            },completion: { finisedd in
                guard let completion = completion else {return}
                completion(finisedd)
            })
        //}
    }
    
    func animateRotateToAngle(duration: Double, to:Double, delay:Double = 0.0, completion: ((Bool) -> Void)? = nil){
       // DispatchQueue.main.async {
            UIView.animate(withDuration:duration, delay: delay,  animations: {
               self.transform = CGAffineTransform(rotationAngle: CGFloat(to))
            },completion: { finisedd in
                guard let completion = completion else {return}
                completion(finisedd)
            })
        //}
    }
    
    func animateColor(duration: Double, toColor:UIColor, delay:Double = 0.0, completion: ((Bool) -> Void)? = nil){
       // DispatchQueue.main.async {
            UIView.animate(withDuration:duration, delay: delay,  animations: {
                self.backgroundColor = toColor
            },completion: { finisedd in
                guard let completion = completion else {return}
                completion(finisedd)
            })
        //}
    }    
    
}


extension UIImage {
    
    func tint(tintColor: UIColor) -> UIImage {
        return modifiedImage { context, rect in
            context.draw(self.cgImage!, in: rect)
            context.setBlendMode(.lighten)
            tintColor.setFill()
            context.fill(rect)
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }
    
  
    func fillAlpha(fillColor: UIColor) -> UIImage {
        return modifiedImage { context, rect in
            context.setBlendMode(.normal)
            fillColor.setFill()
            context.fill(rect)
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }
    
    func getImageWithColor(color: UIColor) -> UIImage {
        
        let size = CGSize(width: self.size.width, height: self.size.height)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func modifiedImage( draw: (CGContext, CGRect) -> ()) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        draw(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}


extension UIScrollView {
    func updateContentHeight(offset:CGFloat = 15.px){
        if let lastObject = self.subviews.last{
            self.contentSize.height = lastObject.frame.origin.y + lastObject.frame.size.height + offset
        }
    }
    
    func autoAlignElements(){
        var yPos:CGFloat = 0.0
        for i in 0..<self.subviews.count{
            self.subviews[i].frame.origin.y = yPos
            yPos += self.subviews[i].frame.size.height
        }
    }
    
    func clearContents(){
        self.subviews.forEach{ view in
            view.removeFromSuperview()
        }
        self.contentOffset = .zero
    }
    
    func animateContentsOffsetToTop(duration: Double, delay:Double = 0.0 ,completion: ((Bool) -> Void)? = nil){
            UIView.animate(withDuration: duration,delay: delay, animations: {
                self.contentOffset.y = 0
               },completion: { finisedd in
                   guard let completion = completion else {return}
                   completion(finisedd)
               })
           //}
       }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

extension Data {
      func decodeData<T>(type: T.Type) -> T? where T:Decodable{
        do{
         return try JSONDecoder().decode(T.self, from: self)
        }catch{
          return nil
        }
    }
    func printDetail(){
        print(NSString(data: self, encoding: String.Encoding.utf8.rawValue)!)
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    var curency: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.groupingSeparator = ","
        currencyFormatter.groupingSize = 3
        currencyFormatter.decimalSeparator = "*"
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.alwaysShowsDecimalSeparator = true
        return currencyFormatter
    }()
}

extension BinaryInteger{
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

extension UIImageView {
    
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    func downloadImage(from imgURL: String, showPreloader:Bool = true, completion: ((_ result: Bool) -> ())? = nil) {                
        if imgURL == "" { completion?(false); return}
        
        var preloader:UIActivityIndicatorView? = nil
            if showPreloader {
                let maxSize = max(self.width, self.height)
                let pSize = maxSize/3 < 60.px ? maxSize/3 : 60.px
                preloader = UIActivityIndicatorView(frame: CGRect(x:(self.width - pSize)/2,y:(self.height - pSize)/2,width:pSize,height:pSize))
                preloader?.startAnimating()
                preloader?.style = .medium
                self.addSubview(preloader!)
            }
            
            var url = URLRequest(url: URL(string: imgURL)!)
            url.cachePolicy = .returnCacheDataElseLoad
            
            let task = URLSession.shared.dataTask(with: url) {[weak self]
                (data, response, error) in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    if preloader != nil {
                        preloader?.stopAnimating()
                        preloader?.removeFromSuperview()
                        preloader = nil
                    }
                    if error != nil {
                        completion?(false)
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        if(httpResponse.statusCode == 200){
                            if let contextImage = UIImage(data: data!){
                                self.image = contextImage
                                completion?(true)
                                return
                            }
                        }
                    }
                }
            }
            task.resume()
    }
}

extension LaunchModel {
    func convertToRealm() -> LaunchModelRm{
        let patchRm = PatchRM()
        patchRm.large = self.links?.patch?.large
        patchRm.small = self.links?.patch?.small
        
        let linksRm = LinksRM()
        linksRm.wikipedia = self.links?.wikipedia
        linksRm.youtube = self.links?.youtube
        linksRm.patch = patchRm
        
        let launchModelRm = LaunchModelRm()
        launchModelRm.id = self.id
        launchModelRm.date  = self.date
        launchModelRm.name  = self.name
        launchModelRm.details  = self.details
        launchModelRm.rocket = self.rocket
        launchModelRm.links = linksRm
        
        return launchModelRm
    }
}

extension LaunchModelRm {
    func convertToCodable() -> LaunchModel{        
        let patch = Patch(small: self.links?.patch?.small, large: self.links?.patch?.large)
        let links = Links(youtube: self.links?.youtube, wikipedia: self.links?.wikipedia, patch: patch)
        let launchModel = LaunchModel(id: self.id, rocket: self.rocket, details: self.details, date: self.date, links: links, name: self.name)
        return launchModel
    }
}
