//
//  CustomLable.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/6/20.
//

import UIKit
import Foundation

protocol  CustomLableDelegate: AnyObject {
    func onCustomLableSelect(target: CustomLable)
}


class CustomLable: UILabel {
    
    weak var delegate: CustomLableDelegate?
    var bgImage:UIImageView!
   
    convenience init (frame:CGRect, text:String, color:UIColor, fontName:String, size:CGFloat ,aligment: NSTextAlignment = .center, userInteraction:Bool = false ){
            self.init(frame:frame)
            self.isUserInteractionEnabled = userInteraction;
            self.font = UIFont(name: fontName, size: size.px)
            self.textColor = color
            self.numberOfLines = 0
            self.textAlignment = aligment
            self.text = text
        }
        
        public func setClickable(withTag:Int){
            self.tag = withTag
            self.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            self.addGestureRecognizer(tap)
        }
        
        public func setText(_ text:String){
            self.text = text
        }
                
        
        @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
            delegate?.onCustomLableSelect(target: self)
        }
       
        
        
   //MARK: - UIView initialization
    override init (frame : CGRect) {
            super.init(frame : frame)
    }
    required init(coder aDecoder: NSCoder) {
         fatalError("This class does not support NSCoding")
    }
}
