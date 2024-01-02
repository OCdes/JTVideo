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
        
        if miniprograms.count > 0 {
           let enterVC = miniprograms[0]
            if !enterVC.isShow {
                if let fromvc = enterVC.fromVc {
                    fromvc.present(enterVC, animated: true)
                }
            }
        }
        
        if let navc = nav, navc.viewControllers.contains(self) != true {
            classPlayVC = nil
            
            navc.pushViewController(self, animated: true)
            let block = completionHandler
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2, execute: DispatchWorkItem(block: {
                block?(true)
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
            
            self.headerV.playView.parentView = self.headerV
            self.headerV.playView.parentFrame = self.headerV.playView.frame
            self.headerV.playView.toVCFrame = self.headerV.convert(self.headerV.playView.frame, to: APPWINDOW)
            let enterFullVC = JTPlayerFullVC()
            enterFullVC.playerSurface = self.headerV.playView
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
        return JTEnterPlayerFullTransition(playerView: self.headerV.playView)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JTExitPlayerFullTransition(playerView: self.headerV.playView, fromVc: self)
    }
    weak var fullVC: UIViewController?
    weak var nav: UINavigationController?
    var isFullScreen: Bool = false
    
    var viewModel: JTClassPlayViewModel = JTClassPlayViewModel()
    lazy var playView: JTClassPlayView = {
        let pv = JTClassPlayView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), style: .grouped, viewModel: self.viewModel)
        return pv
    }()
    
    lazy var headerV: JTVClassPlayerHeaderView = {
        let hv = JTVClassPlayerHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 125 + self.view.frame.width*(294/428)))
        hv.playView.delegate  = self
        return hv
    }()
    
    lazy var scribeBtn: UIButton = {
        let sb = UIButton()
        sb.layer.cornerRadius = 20
        sb.layer.masksToBounds = true
        sb.backgroundColor = HEX_ThemeColor
        sb.setTitleColor(HEX_FFF, for: .normal)
        sb.setTitle("立即订阅", for: .normal)
        sb.addTarget(self, action: #selector(subscribeBtnClicked), for: .touchUpInside)
        return sb
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let pv = classPlayVC, pv == self {
            pv.headerV.playView.stopPip()
            classPlayVC = nil
        }
        nav = self.navigationController
        if self.viewModel.id.count > 0 && self.viewModel.url.count == 0 {
            self.viewModel.generateUrlBy(id: self.viewModel.id)
        }
        
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.viewModel.detailModel.info.name
        view.addSubview(self.headerV)
        
        view.addSubview(scribeBtn)
        scribeBtn.snp_makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-16)
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.width-28, height: 40))
        }
        let bottomMargin: CGFloat = (self.viewModel.detailModel.info.buyerPlay == true && self.viewModel.detailModel.info.userPaid == false) ? 70 : 0
        view.addSubview(self.playView)
        self.playView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: self.headerV.frame.height, left: 0, bottom: bottomMargin, right: 0))
        }
        
        
        
        let _ = viewModel.rx.observeWeakly(String.self, "url").subscribe { [weak self]ustr in
            if let strongSelf = self, let url = self?.viewModel.url, (url.count != 0) {
                strongSelf.headerV.playView.urlSource = url
                strongSelf.headerV.playView.player.isAutoPlay = true
                strongSelf.headerV.titleLa.text = strongSelf.viewModel.detailModel.info.name
                strongSelf.headerV.subTitleLa.text = "已经更新\(strongSelf.viewModel.detailModel.info.videoNumber)期|89人订阅"
            }
        }
        
        _ = playView.tapPlaySubject.subscribe { [weak self]a in
            self?.headerV.playView.controlBar.playerBtnClicked()
        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func subscribeBtnClicked() {
        self.headerV.playView.player.pause()
        let vc = JTVBuyClassVC()
        vc.viewModel.cmodel = self.viewModel.detailModel
        _ = vc.viewModel.paidSuccessSubject.subscribe { [weak self]b in
            if let strongSelf = self {
                strongSelf.viewModel.detailModel.info.userPaid = true
                for m in strongSelf.viewModel.detailModel.playDetails {
                    m.userPaid = true
                }
                
                strongSelf.playView.snp_remakeConstraints { make in
                    make.edges.equalTo(UIEdgeInsets(top: strongSelf.headerV.frame.height, left: 0, bottom: 0, right: 0))
                }
                
                strongSelf.playView.reloadData()
            }
            
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

