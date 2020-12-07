//
//  FavoritesModule.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/6/20.
//

import Foundation
import UIKit


class FavoritesModule: UIViewController {
    var mView: UIView { self.view }
    var topBar:UIView!
    var topBarTx:CustomLable!
    var presenter:FavoritesPresenterProtocol?
    var launchesContent: UIScrollView!
    var yPos:CGFloat = 0.0
    var launchesAmount:Int = 0
    var canAddNextPage:Bool = true
    
    override func viewDidLoad() {
       super.viewDidLoad()
        mView.backgroundColor = C.WHITE
        setupLaunchesContent()
        setupTopBar()        
        presenter?.getFavortieListFromDB()
    }
    
    private func setupLaunchesContent(){
        launchesContent = UIScrollView(frame: CGRect(x: 0, y: C.topBarHeight, width: C.gWidth, height: C.gHeight - C.topBarHeight))
        launchesContent.showsVerticalScrollIndicator = false
        launchesContent.backgroundColor = C.grayColor(number: 230)
        launchesContent.delegate = self
        mView.addSubview(launchesContent)
    }
    
    func setupTopBar(){
        topBar = UIView(frame: CGRect(x: 0, y: 0, width: C.gWidth, height: C.topBarHeight))
        topBar.backgroundColor = C.WHITE
        mView.addSubview(topBar)
                
        topBarTx = CustomLable(frame: CGRect(x: (C.gWidth - 188.px)/2, y: topBar.height - 44.px, width: 188.px, height: 44.px), text: "FAVORITES".localize, color: C.GRAY_143, fontName: C.CIRCE_BOLD, size: 17)
        topBar.addSubview(topBarTx)
       
        let  backButtton = BackButton(frame: CGRect(x: 10.px, y: topBar.frame.size.height - 44.px, width: 40.px, height: 44.px), title: "LAUNCH_BAR_TITLE".localize, color: C.RED, autoWidth: true)
        backButtton.reactArea.addTarget(self, action: #selector(onBackButtonPress), for: .touchUpInside)
        topBar.addSubview(backButtton)
    }
        
    
    //MARK:- UIBUTTON ACTTIONS    
    @objc func onBackButtonPress(){
        presenter?.gotoLaunchesModule()
    }
}

extension FavoritesModule: UIScrollViewDelegate {    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if canAddNextPage {
            if launchesContent.contentOffset.y > launchesContent.contentSize.height - launchesContent.height - 250.px{
                canAddNextPage = false
                presenter?.loadLaunchesPerPagination()
            }
        }
    }
}

extension FavoritesModule : FavoritesModuleProtocol {
    func addLaunchesToContents(list: [LaunchModel]){
        for i in 0..<list.count {
            launchesAmount += 1
            let lauchView = LaunchCellView(frame: CGRect(x: 5, y: yPos, width: launchesContent.width - 10.px, height: 250.px), launchModel: list[i])
            lauchView.delegate = presenter
            lauchView.tag = launchesAmount
            lauchView.isFavorite = true
            launchesContent.addSubview(lauchView)
            yPos += lauchView.height + 10.px
        }
        launchesContent.contentSize.height = yPos
        canAddNextPage = true
    }
    
    func updateFavoriteContent(){
        yPos = 0
        launchesAmount = 0
        for obj in launchesContent.subviews {
            launchesAmount += 1
            obj.y = yPos
            obj.tag = launchesAmount
            yPos += obj.height + 10.px
        }
        launchesContent.contentSize.height = yPos
    }
    
    func clearLaunchContent(){
        yPos = 0
        launchesAmount = 0
        for obj in launchesContent.subviews {
            obj.removeFromSuperview()
        }
    }
}
