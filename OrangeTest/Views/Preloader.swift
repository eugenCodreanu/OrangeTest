//
//  Preloader.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/5/20.
//

import Foundation
import UIKit


class Preloader: UIView {    
    
    private lazy var loadingIndicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x:(self.width - 50.px)/2, y:(self.height - 50.px)/2,width:50.px,height:50.px))
        indicator.style = .large
        indicator.color = C.WHITE
        return indicator
    }()
    
    public var setActive: Bool = false{
            willSet (newValue){
                self.isHidden = !newValue
                newValue ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
            }
    }
        
    override init (frame : CGRect) {
        super.init(frame : frame)
        self.backgroundColor = C.colorFromHex(0x000000, alpha: 0.5)
        self.addSubview(loadingIndicator)
        self.isHidden = true
    }
    
    convenience init () {
        self.init(frame:CGRect(x: 0, y: 0, width: C.gWidth, height: C.gHeight))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}

