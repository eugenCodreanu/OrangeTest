//
//  LaunchDetailsModule.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/5/20.
//

import UIKit
import YouTubePlayer


class LaunchDetailsModule: UIViewController {

    var mView: UIView { self.view }
    var presenter:LaunchDetailsPresenterProtocol?
    var topBar:UIView!
    var topBarTx:CustomLable!
    var detailsContent: UIScrollView!
    var yPos:CGFloat = 0.0    
    var playerSize:CGSize = CGSize(width: C.gWidth, height: C.gWidth / 1.777777)
    var videoPlayer: YouTubePlayerView!
    
    
    private lazy var dateTx:CustomLable = {
        return CustomLable(frame: CGRect(x: 0, y: yPos, width: detailsContent.width, height: 40.px), text:"", color:C.RED, fontName: C.CIRCE_BOLD, size: 17)
    }()
    private lazy var descriptionTx:CustomLable = {
        return CustomLable(frame: CGRect(x: 15.px, y: yPos, width: detailsContent.width - 30.px, height: 40.px), text: "", color:C.GRAY_50, fontName: C.CIRCE, size: 14, aligment: .justified)
    }()
    private lazy var roketNameTx:CustomLable = {
        return CustomLable(frame: CGRect(x: 0, y: yPos, width: detailsContent.width, height: 30.px), text: "ROKET_NAME".localize.appending(":"), color:C.RED, fontName: C.CIRCE, size: 17)
    }()
    private lazy var playloadTx:CustomLable = {
        return CustomLable(frame: CGRect(x: 0, y:  yPos, width: detailsContent.width, height: 30.px), text: "PAYLOAD_MASS".localize.appending(":"), color:C.RED, fontName: C.CIRCE, size: 17)
    }()
    private lazy var wikipediaBtn:UIButton = {
        let wikiButton = UIButton(frame: CGRect(x: (detailsContent.width - 100.px)/2, y: yPos, width: 100.px, height: 40.px))
        wikiButton.titleLabel?.font = UIFont(name: C.CIRCE_BOLD, size: 20.px)
        wikiButton.setTitleColor(C.CHARCORAL_GREY, for: .normal)
        wikiButton.setTitle("WIKIPEDIA".localize, for: .normal)
        wikiButton.addTarget(self, action: #selector(onWikipediaButtonPress), for: .touchUpInside)
        return wikiButton
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mView.backgroundColor = C.WHITE
        setupLaunchesContent()
        setupTopBar()
        presenter?.setupLaunchModel()
   }
        
    private func setupLaunchesContent(){
        detailsContent = UIScrollView(frame: CGRect(x: 0, y: C.topBarHeight, width: C.gWidth, height: C.gHeight - C.topBarHeight))
        detailsContent.showsVerticalScrollIndicator = false
        detailsContent.backgroundColor = C.grayColor(number: 230)
        mView.addSubview(detailsContent)
    }
    
    
    private func setupTopBar(){
        topBar = UIView(frame: CGRect(x: 0, y: 0, width: C.gWidth, height: C.topBarHeight))
        topBar.backgroundColor = C.WHITE
        mView.addSubview(topBar)
        
        topBarTx = CustomLable(frame: CGRect(x: (C.gWidth - 188.px)/2, y: topBar.height - 44.px, width: 188.px, height: 44.px), text: "", color: C.GRAY_143, fontName: C.CIRCE_BOLD, size: 17)
        topBar.addSubview(topBarTx)
       
        let backButtton = BackButton(frame: CGRect(x: 10.px, y: topBar.frame.size.height - 44.px, width: 40.px, height: 44.px), title: "LAUNCH_BAR_TITLE".localize, color: C.RED, autoWidth: true)
        backButtton.reactArea.addTarget(self, action: #selector(onBackButtonPress), for: .touchUpInside)
        topBar.addSubview(backButtton)
    }
    
    
    private func setupYoutubePayer(id: String){
        videoPlayer = YouTubePlayerView(frame: CGRect(origin: .zero, size: playerSize))
        videoPlayer.delegate = presenter
        videoPlayer.loadVideoID(id)
        detailsContent.addSubview(videoPlayer)
        yPos = playerSize.height
    }
    
      
    //MARK:- UIBUTTONS ACTIONS
    @objc func onBackButtonPress(){
        presenter?.gotoLaunchesModule()
    }
    
    @objc func onWikipediaButtonPress(target: UIButton){
        if let urlHint = target.accessibilityIdentifier {
            if let url = URL(string: urlHint) {
                UIApplication.shared.open(url)
            }
        }
    }
    
   
}

extension LaunchDetailsModule: LaunchDetailsModuleProtocol {
    
    func stopYoutubePlayer(){
        if videoPlayer != nil {
            if videoPlayer.playerState != .Unstarted{               
                videoPlayer.clear()
            }
        }
    }
    
    func setupDetailContents(model: LaunchModel){
        topBarTx.text = model.name ?? "LAUNCH_BAR_TITLE".localize        
        if let youtube = model.links?.youtube {
            setupYoutubePayer(id: youtube)
        }
        
        if let date = model.date{
            dateTx.setText(date.extartDateTimeZone())
            detailsContent.addSubview(dateTx)
            yPos += dateTx.height
        }
        
        if let description = model.details {
            descriptionTx.setText(description)
            descriptionTx.autoCorrectHeight()
            detailsContent.addSubview(descriptionTx)
            yPos += descriptionTx.height + 15.px
        }
        
        let line = UIView(frame: CGRect(x: 20.px, y: yPos, width: detailsContent.width - 40.px, height: 1.px))
        line.backgroundColor = C.grayColor(number: 150)
        detailsContent.addSubview(line)
        yPos += 15.px
        
        
        detailsContent.addSubview(roketNameTx)
        yPos += roketNameTx.height
                
        detailsContent.addSubview(playloadTx)
        yPos += playloadTx.height
        
        
        if let wikipediaData = model.links?.wikipedia {
            wikipediaBtn.accessibilityIdentifier = wikipediaData
            detailsContent.addSubview(wikipediaBtn)
            yPos += wikipediaBtn.height
        }
        
        detailsContent.contentSize.height = yPos + 50.px
    }
    
    func updateRocketDetails(rocketData:RocketModel){
        if let rocketName = rocketData.name {
            let rocketStr = "ROKET_NAME".localize.appending(":")
            let rocketNameStr = rocketName
            let completeString = rocketStr.appending(" ").appending(rocketNameStr)
            let textRange = NSMakeRange(rocketStr.count+1, rocketNameStr.count)
            let attributedText = NSMutableAttributedString(string: completeString)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: C.grayColor(number: 50) , range: textRange)
            attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont(name: C.CIRCE_BOLD, size: 15.px) as Any, range: textRange)
            roketNameTx.attributedText = attributedText
            
        }
                
        if let payload = rocketData.mass?.kg {
            let payloadStr = "PAYLOAD_MASS".localize.appending(":")
            let payloadmassStr = String(payload).appending(" kg")
            let completePayloadString = payloadStr.appending(" ").appending(payloadmassStr)
            let payloadTextRange = NSMakeRange(payloadStr.count+1, payloadmassStr.count)
            let payloadAttributedText = NSMutableAttributedString(string: completePayloadString)
            payloadAttributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: C.grayColor(number: 50) , range: payloadTextRange)
            payloadAttributedText.addAttribute(NSAttributedString.Key.font, value: UIFont(name: C.CIRCE_BOLD, size: 15.px) as Any, range: payloadTextRange)
            playloadTx.attributedText = payloadAttributedText
        }
    }
}
