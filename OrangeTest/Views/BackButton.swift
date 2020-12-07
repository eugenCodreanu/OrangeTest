//
//  BackButton.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/6/20.
//

import Foundation
import UIKit

class BackButton: UIView {

    public var reactArea:UIButton!
    public var backTitle:String!{
        willSet (newValue){
            buttonTitle = newValue
            buttonTitleTx.text = buttonTitle
            buttonTitleTx.autoCorrectWidth()
            autoWidthCorrect()
        }
    }
        
    private var buttonTitleTx: CustomLable!
    private let offfset:CGFloat = 5.px
    private var buttonTitle:String!
    private var autoWidth:Bool!
    
    convenience init (frame:CGRect, title:String, color:UIColor, autoWidth:Bool = true){
        self.init(frame:frame)
        self.layer.masksToBounds = true
        self.buttonTitle = title
        self.autoWidth = autoWidth
        
        let backIcon = ImageView(frame: CGRect(x: offfset, y: (frame.size.height-20.px)/2, width: 12.px, height: 20.px), named: "arrow")
        backIcon.setImageColor(color: color)
        self.addSubview(backIcon)
        
        buttonTitleTx = CustomLable(frame: CGRect(x:backIcon.width + (offfset * 2) , y: 0, width:frame.width, height: self.height), text: title, color: color, fontName: C.CIRCE, size: 17)
        buttonTitleTx.numberOfLines = 1
        self.addSubview(buttonTitleTx)
        buttonTitleTx.autoCorrectWidth()
        
        reactArea = UIButton(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.addSubview(reactArea)
        autoWidthCorrect()
    }
    
    private func autoWidthCorrect(){
        if autoWidth {
            self.width = buttonTitleTx.x + buttonTitleTx.width + (offfset*2)
            reactArea.width = self.width
        }
    }
            
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
        
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

}
