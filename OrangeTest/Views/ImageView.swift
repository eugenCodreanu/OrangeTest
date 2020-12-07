//
//  TrackView.swift
//  bikE
//
//  Created by Outsourcing farm on 3/13/18.
//  Copyright © 2018 ofarm. All rights reserved.
//
import Foundation
import UIKit



protocol ImageViewDelegate: AnyObject {
    func onClickImageView(_ target: ImageView);
}


class ImageView: UIImageView {
    
    private var tint = UIView()
    weak var delegate:ImageViewDelegate?
    
    convenience init (frame:CGRect, named:String, border:CGFloat = 0, userInteraction:Bool = false, contentMode: UIView.ContentMode = .scaleAspectFill ){
        self.init(frame:frame)
        self.contentMode = contentMode
        if !named.isEmpty {
            self.image = UIImage(named: named);
        }
        self.layer.masksToBounds = true
        self.layer.cornerRadius = border        
        if(userInteraction){
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            self.addGestureRecognizer(tap)
        }
    }
    
    convenience init (frame:CGRect, image:UIImage?, border:CGFloat = 0, userInteraction:Bool = false, contentMode: UIView.ContentMode = .scaleAspectFill ){
           self.init(frame:frame)
           self.contentMode = contentMode
           if let img = image {
                self.image = img
           }
           self.layer.masksToBounds = true
           self.layer.cornerRadius = border
           if(userInteraction){
               let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
               self.addGestureRecognizer(tap)
           }
       }
    
       
    public func downloadImageFromUrl(url: String){
        self.downloadImage(from: url, showPreloader: true) { (result) in
            
        }
    }
    
    public func setImage(named:String){
        self.image = UIImage(named: named)
    }
    
    
    public func setImage(data:Data){
        self.image = UIImage(data: data)
    }
    
   
    public func setClickable(withTag:Int){
        self.tag = withTag
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tap)
    }
    
    /**
    Method will handler tap gesture recognizer
    It will call *onClickImageView*
    */
    @objc private func handleTap(sender: UITapGestureRecognizer? = nil) {
        delegate?.onClickImageView(self)
    }
    
    /**
     Method will round the image view
     */
    public func roundIt(){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = frame.size.height/2
    }
    
    //MARK: - UIView initialization
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }    
}
