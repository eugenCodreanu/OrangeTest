//
//  LaunchCellView.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/6/20.
//

import UIKit

protocol LaunchCellViewDelegate:AnyObject {
    func onAddToFavorite(model:LaunchModel, target: LaunchCellView)
    func onLaunchViewSelect(model:LaunchModel)
}


class LaunchCellView: UIView {
          
    weak var delegate:LaunchCellViewDelegate?
    private var nameTx:CustomLable!
    private var dateTx:CustomLable!
    private var imageImg:ImageView!
    public var launchModel:LaunchModel!
    public var idString:String!
    public var isFavorite:Bool = false {
        willSet (newValue){
            favoriteBtn.isSelected = newValue
        }
    }
    private var favoriteBtn:UIButton!
    private var dataProvider = DataProvider()
    
    private lazy var loadingIndicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x:(self.width - 50.px)/2, y:(self.height - 50.px)/2,width:50.px,height:50.px))
        indicator.style = .large
        indicator.color = C.GRAY_50
        return indicator
    }()
            
        convenience init (frame:CGRect, launchModel:LaunchModel){
            self.init(frame:frame)
            self.launchModel = launchModel
            self.idString = launchModel.id
            imageImg = ImageView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height - 40.px), named: "")
            self.addSubview(imageImg)
            
            if let imageUrl = launchModel.getPatchFirstImage() {
                self.addSubview(loadingIndicator)
                loadingIndicator.startAnimating()
                dataProvider.downloadImageWitchCache(urlString: imageUrl) { [weak self] (image) in
                    guard let self = self else {return}
                    self.imageImg.image = image
                    self.loadingIndicator.stopAnimating()
                }
            }
                                  
            let nameTx = CustomLable(frame: CGRect(x: 10.px, y: self.height - 40.px, width: 200.px, height: 40.px), text: launchModel.name ?? "NO_NAME".localize, color: C.DARK_BLUE, fontName: C.CIRCE_BOLD, size: 14, aligment: .left)
            self.addSubview(nameTx)
            
            dateTx = CustomLable(frame: CGRect(x: self.width - 210.px, y: self.height - 40.px, width: 200.px, height: 40.px), text: launchModel.date?.extartDateTimeZone() ?? "NO_NAME".localize , color: C.RED, fontName: C.CIRCE_BOLD, size: 14, aligment: .right)
            self.addSubview(dateTx)
            
            favoriteBtn = UIButton(frame: CGRect(x: self.width - 50.px, y: 0, width: 50.px, height: 50.px))
            favoriteBtn.setBackgroundImage(UIImage(named: "favoriteOff"), for: .normal)
            favoriteBtn.setBackgroundImage(UIImage(named: "favoriteOn"), for: .selected)
            favoriteBtn.addTarget(self, action: #selector(onFavoritePress(target:)), for: .touchUpInside)
            self.addSubview(favoriteBtn)
            
            
            let line = UIView(frame: CGRect(x: 0, y: self.height - 1.px, width: frame.size.width, height: 1.px))
            line.backgroundColor = C.grayColor(number: 150)
            self.addSubview(line)
                      
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            self.addGestureRecognizer(tap)
        }
        
       
    //MARK:- UIBUTTONS ACTIONS    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        if let model = launchModel {
            delegate?.onLaunchViewSelect(model: model)
        }
    }
    
    @objc func onFavoritePress(target: UIButton){
        if let model = launchModel {
            delegate?.onAddToFavorite(model: model, target: self)
        }
    }
    
    override init (frame : CGRect) {
           super.init(frame : frame)
    }
        
    required init(coder aDecoder: NSCoder) {
            fatalError("This class does not support NSCoding")
    }
}
