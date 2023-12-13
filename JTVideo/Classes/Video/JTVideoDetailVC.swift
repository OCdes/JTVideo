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
open class JTVideoDetailVC: UIViewController, JTPlayerViewDelegate, UIViewControllerTransitioningDelegate {
    public func playerWillStopPictureInPicture(completionHandler: ((Bool) -> Void)?) {
        if let navc = nav, navc.viewControllers.contains(self) != true {
            playerVC = nil
            navc.pushViewController(self, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.15, execute: DispatchWorkItem(block: {
                completionHandler?(true)
            }))
        }
        completionHandler?(true)
    }
    
    public func playerWillEnterPictureInPicture() {
        playerVC = self
        self.navigationController?.popViewController(animated: true)
    }
    
    public func requirePopVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    public func requireFullScreen(fullScreen: Bool) {
        isFullScreen = fullScreen
        if isFullScreen {
            let enterFullVC = JTPlayerFullVC()
            enterFullVC.playerSurface = self.playerView
            enterFullVC.modalPresentationStyle = .fullScreen
            enterFullVC.transitioningDelegate = self
            fullVC = enterFullVC
            self.present(enterFullVC, animated: true)
        } else {
            self.fullVC?.dismiss(animated: true)
        }
        
    }
    //MARK: 进场出场模态动画
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JTEnterPlayerFullTransition(playerView: self.playerView)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JTExitPlayerFullTransition(playerView: self.playerView, fromVc: self)
    }
    
    lazy var playerContainerView: UIView = {
        let pcv = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 300))
        return pcv
    }()
    
    lazy var playerView: JTPlayerView = {
        let pv = JTPlayerView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 300))
        pv.delegate = self
        pv.controlBar.backBtn.isHidden = false
        return pv
    }()
    
    weak var fullVC: UIViewController?
    weak var nav: UINavigationController?
    var isFullScreen: Bool = false
    
    var url: String = "" {
        didSet {
            self.playerView.urlSource = url
            self.playerView.title = url
        }
    }
    
    public static func videoDetailEntrance(withUrl: String, fromVC: UIViewController) {
        if let pv = playerVC, pv.url == withUrl {
            fromVC.navigationController?.pushViewController(pv, animated: true)
        } else {
            let vc = JTVideoDetailVC()
            vc.url = withUrl
            fromVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pv = playerVC, pv == self {
            pv.playerView.stopPip()
            playerVC = nil
        }
        nav = self.navigationController
        self.navigationController?.navigationBar.isHidden = true
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        view.addSubview(playerContainerView)
        playerContainerView.addSubview(playerView)

        
        
        let contentLa = UILabel(frame: CGRectMake(20, CGRectGetMaxY(playerContainerView.frame), UIScreen.main.bounds.width-40, 200))
        contentLa.text = "12月6日，货车司机李师傅反映，他在山西吕梁离石西收费站接受检查时，执法人员撕毁了他的超限通行证，还说是假证。7日，山西省道路运输管理局治超办工作人员告诉极目新闻记者，已经接到车主的投诉，需要5个工作日才能出结果。收费站工作人员表示，涉事执法人员已经停岗，公司正在调查。"
        contentLa.numberOfLines = 0
        view.addSubview(contentLa)
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
