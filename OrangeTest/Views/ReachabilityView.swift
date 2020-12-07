//
//  ReachibilityView.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/6/20.
//

import Foundation
import UIKit

class ReachabilityView: UIView {

    var visible: Bool = false{
        didSet{
            self.isHidden = !self.visible
        }
    }
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        self.backgroundColor = C.colorFromHex(0xff0000, alpha: 0.8)
        let alertTx = CustomLable(frame: CGRect(x: 0, y: self.height - 18.px, width: self.width, height: 18.px),
                                           text: "NO_INTERENT_CONECTION".localize,
                                           color: C.WHITE,
                                           fontName: C.CIRCE,
                                           size: 14)
         self.addSubview(alertTx)
         self.isHidden = true
    }
    
    convenience init () {
        self.init(frame:CGRect(x: 0, y: 0, width: C.gWidth, height: C.topPadding + 50.px))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}
