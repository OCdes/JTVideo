//
//  JTClassPlayVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/15.
//

import UIKit
var classPlayVC: JTClassPlayVC?
class JTClassPlayVC: JTVideoBaseVC, JTPlayerViewDelegate, UIViewControllerTransitioningDelegate {
    func playerWillEnterPictureInPicture() {
        classPlayVC = self
        self.navigationController?.popViewController(animated: true)
    }
    
    func playerWillStopPictureInPicture(completionHandler: ((Bool) -> Void)?) {
        if let navc = nav, navc.viewControllers.contains(self) != true {
            classPlayVC = nil
            navc.pushViewController(self, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2, execute: DispatchWorkItem(block: {
                completionHandler?(true)
            }))
        }
        completionHandler?(true)
    }
    
    func requirePopVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    public func requireFullScreen(fullScreen: Bool) {
        isFullScreen = fullScreen
        if isFullScreen {
            
            self.playView.headerV.playView.parentView = self.playView.headerV
            self.playView.headerV.playView.parentFrame = self.playView.headerV.playView.frame
            self.playView.headerV.playView.toVCFrame = self.playView.headerV.convert(self.playView.headerV.playView.frame, to: APPWINDOW)
            let enterFullVC = JTPlayerFullVC()
            enterFullVC.playerSurface = self.playView.headerV.playView
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
        return JTEnterPlayerFullTransition(playerView: self.playView.headerV.playView)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JTExitPlayerFullTransition(playerView: self.playView.headerV.playView, fromVc: self)
    }
    weak var fullVC: UIViewController?
    weak var nav: UINavigationController?
    var isFullScreen: Bool = false
    
    var viewModel: JTClassPlayViewModel = JTClassPlayViewModel()
    lazy var playView: JTClassPlayView = {
        let pv = JTClassPlayView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), style: .grouped, viewModel: self.viewModel)
        pv.headerV.playView.delegate = self
        return pv
    }()
    
    lazy var scribeBtn: UIButton = {
        let sb = UIButton()
        sb.layer.cornerRadius = 20
        sb.layer.masksToBounds = true
        sb.backgroundColor = HEX_ThemeColor
        sb.setTitleColor(HEX_FFF, for: .normal)
        sb.setTitle("立即订阅", for: .normal)
        return sb
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pv = classPlayVC, pv == self {
            pv.playView.headerV.playView.stopPip()
            classPlayVC = nil
        }
        nav = self.navigationController
        if self.viewModel.id.count > 0 && self.viewModel.url.count == 0 {
            self.viewModel.generateUrlBy(id: self.viewModel.id)
        }
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.playView)
        self.playView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0))
        }
        
        view.addSubview(scribeBtn)
        scribeBtn.snp_makeConstraints { make in
            make.centerX.equalTo(self.playView)
            make.top.equalTo(self.playView.snp_bottom).offset(12)
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.width-28, height: 40))
        }
        // Do any additional setup after loading the view.
    }

}

