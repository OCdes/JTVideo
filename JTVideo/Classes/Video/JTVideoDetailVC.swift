//
//  JTVideoDetailVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/11/28.
//

import UIKit
import AVKit

var playerVC: JTVideoDetailVC?
@objc
open class JTVideoDetailVC: UIViewController, JTPlayerViewDelegate {
    func playerWillStopPictureInPicture(completionHandler: ((Bool) -> Void)?) {
        if let navc = nav, navc.viewControllers.contains(self) != true {
            playerVC = nil
            navc.pushViewController(self, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.15, execute: DispatchWorkItem(block: {
                completionHandler?(true)
            }))
        }
        completionHandler?(true)
    }
    
    func playerWillEnterPictureInPicture() {
        playerVC = self
        self.navigationController?.popViewController(animated: true)
    }
    
    func requirePopVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func requireFullScreen(fullScreen: Bool) {
        isFullScreen = fullScreen
        setOrientation()
//        animatePlayerContainer()
    }
    
    lazy var playerContainerView: UIView = {
        let pcv = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 300))
        return pcv
    }()
    
    lazy var playerView: JTPlayerView = {
        let pv = JTPlayerView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 300))
        pv.delegate = self
        return pv
    }()
    
    weak var fullvc: UIViewController?
    weak var nav: UINavigationController?
    var isFullScreen: Bool = false
    
    var url: String = "" {
        didSet {
            self.playerView.urlSource = url
        }
    }
    
    open override func prefersHomeIndicatorAutoHidden() -> Bool {
        return isFullScreen
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pv = playerVC, pv == self {
            pv.playerView.stopPip()
            playerVC = nil
        }
        nav = self.navigationController
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.playerContainerView.snp_remakeConstraints { make in
            if self.isFullScreen {
                make.edges.equalTo(UIEdgeInsets.zero)
            } else {
                make.left.top.right.equalTo(self.view)
                make.height.equalTo(300)
            }
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        view.addSubview(playerContainerView)
        playerContainerView.snp_makeConstraints { make in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(300)
        }
        playerContainerView.addSubview(playerView)
        playerView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    deinit {
        //销毁了
    }
    
    func setOrientation() {
        self.navigationController?.navigationBar.isHidden = isFullScreen
        if #available(iOS 16.0, *) {
            setNeedsUpdateOfSupportedInterfaceOrientations()
            if let Scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: isFullScreen ? .landscapeLeft : .portrait)
                
                Scene.requestGeometryUpdate(geometryPreferences) { error in
                    print("屏幕旋转失败,error:\(error.localizedDescription)")
                }
            }
            
        } else {
            let orientation: UIInterfaceOrientation = isFullScreen ? .landscapeLeft : .portrait
            UIDevice.current.setValue(orientation.rawValue , forKey: "orientation")
        }
    }
    
    func animatePlayerContainer() {
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .layoutSubviews) {
            let bounds = CGRect(x: 0, y: 0, width: self.isFullScreen ? kScreenHeight : kScreenWidth, height: self.isFullScreen ?  kScreenWidth : 300)
            self.playerContainerView.bounds = bounds
            self.playerContainerView.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
            self.playerContainerView.transform = CGAffineTransform(rotationAngle: self.isFullScreen ? -Double.pi/2 : 0)
            
        } completion: { b in
            let bounds = CGRect(x: 0, y: 0, width: self.isFullScreen ? kScreenHeight : kScreenWidth, height: self.isFullScreen ?  kScreenWidth : 300)
            self.playerContainerView.bounds = bounds
            self.playerContainerView.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
            self.playerContainerView.transform = CGAffineTransform(rotationAngle: self.isFullScreen ? -Double.pi/2 : 0)
            self.playerView.bounds = self.playerContainerView.bounds
            if !self.isFullScreen {
                self.playerContainerView.addSubview(self.playerView)
                self.playerView.snp_remakeConstraints { make in
                    make.edges.equalTo(self.playerContainerView)
                }
                self.fullvc?.dismiss(animated: false, completion: {
                    self.playerView.removeFromSuperview()
                    self.playerContainerView.addSubview(self.playerView)
                    self.playerView.snp_remakeConstraints { make in
                        make.edges.equalTo(self.playerContainerView)
                    }

                })
            } else {
                self.playerView.center = self.playerContainerView.center
                let vc = JTPlayerFullVC()
                vc.modalPresentationStyle = .fullScreen
                self.fullvc = vc
                self.present(vc, animated: false) {
                    self.playerView.removeFromSuperview()
                    vc.view.addSubview(self.playerView)
                    self.playerView.snp_makeConstraints { make in
                        make.edges.equalTo(UIEdgeInsets.zero)
                    }
                    vc.view.superview?.insertSubview(self.view, belowSubview: vc.view)
                }
            }
        }
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
