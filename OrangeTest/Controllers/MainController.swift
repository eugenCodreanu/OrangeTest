//
//  MainController.swift
//  OrangeTest
//
//  Created by Codreanu Eugen on 12/5/20.
//

import Foundation
import UIKit
import Network

protocol MainControllerProtocol: AnyObject {
     func setPreloader(status: Bool)
     func showSimpleAlert(message: String)
     func hideEditableTexts()
}


class MainController: UIViewController {    
    private var mView: UIView {
        self.view
    }
    private let preloader = Preloader()
    private var mainNavigationController:UINavigationController!
    private var moduleAssembler:ModuleAssemblerProtocol!
    private var router:Router!
    lazy var reachabilityView = ReachabilityView()    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mView.backgroundColor = C.BROWNISH_GREY
        setupMainNavigationController()
        setupInternetConectionListener()
        mView.addSubview(preloader)
        mView.addSubview(reachabilityView)
    }
    
    
    private func setupMainNavigationController(){
           mainNavigationController = UINavigationController()
           mainNavigationController.view.frame=CGRect(x: 0, y:0, width: C.gWidth, height: C.gHeight);
           mainNavigationController.isNavigationBarHidden=true;
           self.addChild(mainNavigationController);
           mainNavigationController.didMove(toParent: self);
           mView.addSubview(mainNavigationController.view);
                  
           moduleAssembler = ModuleAssembler()
           router = Router(rootView: self, navigationController: mainNavigationController, moduleAssembler: moduleAssembler)
           router.initiateViewController(controllerType: .launchList)
               
    }
         
    func setupInternetConectionListener(){
        monitor.pathUpdateHandler = { [weak self] pathUpdateHandler in
            guard let self = self else {return}
            DispatchQueue.main.async {
                   if pathUpdateHandler.status == .satisfied {
                        self.reachabilityView.visible = false
                      } else {
                        self.reachabilityView.visible = true
                      }
                  }
            }
        monitor.start(queue: queue)
    }
   
}



extension MainController: MainControllerProtocol{
    func hideEditableTexts() {
        
    }
    func setPreloader(status: Bool){
        preloader.setActive = status
    }
    func showSimpleAlert(message: String) {
        self.showPopupErrorMessage(message)
    }    
}
