//
//  LaunchDetailsPresenter.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/5/20.
//

import Foundation
import UIKit
import YouTubePlayer

protocol  LaunchDetailsModuleProtocol:AnyObject {
    func setupDetailContents(model: LaunchModel)
    func stopYoutubePlayer()
    func updateRocketDetails(rocketData:RocketModel)
}

protocol LaunchDetailsPresenterProtocol: YouTubePlayerDelegate {
    init(view: LaunchDetailsModuleProtocol, router: RouterBasicProtocol, apiService: ApiServiceProtocol, model:LaunchModel)
    func setupLaunchModel()
    func gotoLaunchesModule()
}

class LauchDetailPresenter: LaunchDetailsPresenterProtocol  {
    weak var view: LaunchDetailsModuleProtocol?
    var router: RouterBasicProtocol?
    var apiService: ApiServiceProtocol?
    var lastPlayerState: YouTubePlayerState!
    var launchModel:LaunchModel?
    var autoPlay:Bool = false
    
    required init(view: LaunchDetailsModuleProtocol, router: RouterBasicProtocol, apiService: ApiServiceProtocol, model:LaunchModel) {
        self.view = view
        self.router = router
        self.apiService = apiService
        self.launchModel = model
    }   
    
    func setupLaunchModel(){
        guard let model = launchModel else {
            self.router?.navigateToPopModule()
            self.router?.showSimpleAlert(message: "DATA_MISSING".localize)
            return
        }
        view?.setupDetailContents(model: model)
        if let rocketId = model.rocket {
            getRocketDetails(rocketId: rocketId)
        }
    }
    
    private func getRocketDetails(rocketId: String){
        apiService?.getRoketName(id: rocketId, completion: { [weak self](response) in
        guard let self = self else {return}
        self.router?.setPreloader(status: false)
        switch response{
            case .success(let rocketData):              
                self.view?.updateRocketDetails(rocketData: rocketData)
            case .failure(let errorMessage):
                self.router?.showSimpleAlert(message: errorMessage)
            }
        })
    }
    
    func gotoLaunchesModule(){        
        view?.stopYoutubePlayer()
        router?.navigateToPopModule()
    }
    
    
}

extension LauchDetailPresenter: YouTubePlayerDelegate{
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        if autoPlay {
            videoPlayer.play()
        }
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        lastPlayerState = playerState
    }
}
