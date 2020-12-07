//
//  LaunchListController.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/5/20.
//

import Foundation
import UIKit
import RealmSwift

class LaunchListModule: UIViewController {
    var mView: UIView { self.view }
    var topBar:UIView!
    var topBarTx:CustomLable!
    var presenter:LaunchListPresenterProtocol?
    var launchesContent: UIScrollView!
    var yPos:CGFloat = 0.0
    var launchesAmount:Int = 0
    var canRefresh:Bool = true
    var canAddNextPage:Bool = true
    var refreshImg:ImageView!
    
    override func viewDidLoad() {
       super.viewDidLoad()
        mView.backgroundColor = C.WHITE
        setupLaunchesContent()
        setupTopBar()
        
        presenter?.getLastLaunches()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLauchFavoriteIcons()
    }
    
    private func setupLaunchesContent(){
        launchesContent = UIScrollView(frame: CGRect(x: 0, y: C.topBarHeight, width: C.gWidth, height: C.gHeight - C.topBarHeight))
        launchesContent.showsVerticalScrollIndicator = false
        launchesContent.backgroundColor = C.grayColor(number: 230)
        launchesContent.delegate = self
        launchesContent.contentSize.height = C.gHeight + 100.px
        mView.addSubview(launchesContent)
                
        refreshImg = ImageView(frame: CGRect(x: (C.gWidth - 30.px)/2, y: 0, width: 30.px, height: 30.px), named: "refresh")
        mView.addSubview(refreshImg)
    }
    
    func setupTopBar(){
        topBar = UIView(frame: CGRect(x: 0, y: 0, width: C.gWidth, height: C.topBarHeight))
        topBar.backgroundColor = C.WHITE
        mView.addSubview(topBar)
                
        topBarTx = CustomLable(frame: CGRect(x: (C.gWidth - 188.px)/2, y: topBar.height - 44.px, width: 188.px, height: 44.px), text: "LAUNCH_BAR_TITLE".localize, color: C.GRAY_143, fontName: C.CIRCE_BOLD, size: 17)        
        topBar.addSubview(topBarTx)
        
       
        let favoriteBtn = UIButton(frame: CGRect(x: topBar.width - 55.px, y: topBar.height - 44.px, width: 44.px, height: 44.px))
        favoriteBtn.setBackgroundImage(UIImage(named: "favoriteOn"), for: .normal)
        favoriteBtn.addTarget(self, action: #selector(onFavoriteButtonPress), for: .touchUpInside)
        topBar.addSubview(favoriteBtn)
    }
    
    private func updateLauchFavoriteIcons(){
        for obj in launchesContent.subviews {
            if let launchCellView = obj as? LaunchCellView{
                launchCellView.isFavorite = presenter?.checkLaunchViewIsFavorite(id: launchCellView.idString) ?? false
            }
        }
    }
    
    
    //MARK:- UIBUTTON ACTTIONS
    @objc func onFavoriteButtonPress(){
        presenter?.navigateToFavoriteModule()
    }
}

extension LaunchListModule: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 && scrollView.contentOffset.y > -180.px {
            let perc = scrollView.contentOffset.y / -180.px
            let angle = Double(360.0 * perc)
            let pos = 130.px * perc
            let rotate = CGAffineTransform(rotationAngle: CGFloat(angle * Double.pi / 180))
            refreshImg.transform = rotate
            refreshImg.transform.ty = pos
        }
        
        
        if canRefresh {
            if scrollView.contentOffset.y < -180.px {
                    canRefresh = false
                    launchesContent.isScrollEnabled = false
                    launchesContent.contentOffset.y = -180.px
                    launchesContent.isScrollEnabled = true
                    launchesContent.animateContentsOffsetToTop(duration: 0.3, delay: 0)
                    refreshImg.animateMoveToY(duration: 0.5, value: 0, delay: 0.2)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){ [weak self] in
                        guard let self = self else {return}
                        self.presenter?.refreshLauchList()
                    }
            }
        }
        
        if canAddNextPage {
            if launchesContent.contentOffset.y > launchesContent.contentSize.height - launchesContent.height - 250.px{
                canAddNextPage = false                
                presenter?.loadLaunchesPerPagination()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        canRefresh = true
    }
           
}

extension LaunchListModule : LaunchListModuleProtocol {
    func addLaunchesToContents(list: [LaunchModel]){
        list.forEach { model in
            launchesAmount += 1           
            let lauchView = LaunchCellView(frame: CGRect(x: 5, y: yPos, width: launchesContent.width - 10.px, height: 250.px), launchModel: model)
            lauchView.delegate = presenter
            lauchView.isFavorite = presenter?.checkLaunchViewIsFavorite(id: model.id) ?? false
            lauchView.tag = launchesAmount
            launchesContent.addSubview(lauchView)
            yPos += lauchView.height + 10.px
        }
        launchesContent.contentSize.height = yPos
        canRefresh = true
        canAddNextPage = true
    }   
    
    
    
    func clearLaunchContent(){
        yPos = 0
        launchesAmount = 0
        for obj in launchesContent.subviews {
            obj.removeFromSuperview()
        }
    }
}
