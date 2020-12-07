//
//  Constants.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/5/20.
//

import Foundation
import UIKit

/**
 Class will define all constants variable and methods
 */
struct C {
    //App language
    static var lang = "en"    
    
    //Screen sizes
    static  var gWidth:CGFloat = UIScreen.main.bounds.size.width;
    static  let gHeight:CGFloat = UIScreen.main.bounds.size.height;
    static  var scale:CGFloat{
        C.device == .pad ? gWidth/512.0 : gWidth/375.0
    }
    static var screenSizeForBottom:CGFloat = 0.0
    static var topPadding:CGFloat = 0
    static var bottomPadding:CGFloat = 0
    static var safeAreaAset:UIEdgeInsets = .zero
    static var device =  UIDevice().userInterfaceIdiom
    static var phone:Bool {
        C.device == .phone
    }
    static var topBarHeight:CGFloat{
        85.px + C.topPadding
    }
      
    
    static let months = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"]
        
    //App fonts
    static let CIRCE = "Circe-Regular"
    static let CIRCE_BOLD = "Circe-Bold"    
        
     //App colors
     static let BLACK = colorFromHex(0x000000)
     static let BLACK_TWO = RGBColor( 12, 12, 12)
     static let BLACK_ALPHA94 = colorFromHex(0x000000, alpha: 0.95)
     static let WHITE = colorFromHex(0xFFFFFF)
     static let DARK_BLUE = colorFromHex(0x21232B)
     static let ALMOST_BlACK = RGBColor( 13, 14, 17)
     static let CHARCORAL_GREY = RGBColor(66, 67, 72)
     static let BROWNISH_GREY = RGBColor(107, 107, 107)
     static let GRAY_143 = RGBColor(143, 143, 143)
     static let GRAY_50 = RGBColor(50, 50, 50)
     static let GRAY_150 = RGBColor(150, 150, 150)
     static let GRAY_175 = RGBColor(175, 175, 175)
     static let ORANGE_RED = RGBColor(255, 24, 24)
     static let LEMON = RGBColor(255, 241, 80)
     static let DARK_BLUE_ALPHA90 = colorFromHex(0x21232B,alpha: 0.94)
     static let RED = colorFromHex(0xFF1818)
     static let RED_ALPHA50 = colorFromHex(0xFF1818, alpha: 0.45)
     static let YELLOW_ALPHA50 = colorFromHex(0xff9c00, alpha: 0.45)
    
        
    //MARK: - Colors converter methods
    static func hexColorFromString(_ rgbStringValue:String, alpha : Double = 1.0)->UIColor
    {
        let hex = rgbStringValue.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
          if #available(iOS 13, *) {
              guard let int = Scanner(string: hex).scanInt32(representation: .hexadecimal) else { return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) }
              let a,r, g, b: Int32
              switch hex.count {
              case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
              case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
              case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
              default:    (a, r, g, b) = (255, 0, 0, 0)
              }
              return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)

          } else {
              var int = UInt32()
              Scanner(string: hex).scanHexInt32(&int)
              let a,r, g, b: UInt32
              switch hex.count {
              case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
              case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
              case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
              default:    (a, r, g, b) = (255, 0, 0, 0)
              }
              return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
          }
    }
    
    static func grayColor(number: Double) -> UIColor{
        return UIColor(red: CGFloat(number / 255.0), green: CGFloat(number / 255.0), blue: CGFloat(number / 255.0), alpha: 1.0);
    }
    
    static func colorFromHex(_ rgbValue:UInt32, alpha : CGFloat = 1)->UIColor
    {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0xFF) / 255.0
        return UIColor(red:red, green:green, blue:blue, alpha: alpha)
    }
    
    static func RGBColor(_  R:Double, _ G:Double, _ B:Double, _ alpha:CGFloat = 1.0) -> UIColor{
        return UIColor(red: CGFloat(R / 255.0), green: CGFloat(G / 255.0), blue: CGFloat(B / 255.0), alpha: alpha);
    }
    
    
}
