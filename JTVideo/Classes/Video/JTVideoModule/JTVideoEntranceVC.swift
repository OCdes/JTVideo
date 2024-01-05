//
//  JTVideoEntranceVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/11.
//

import UIKit
var miniprograms: [JTVideoEntranceVC] = []
@objc
open class JTVideoEntranceVC: UITabBarController {
    var barItemColor: UIColor = HEX_COLOR(hexStr: "#bfbfbf")
    var barItemSelectedColor: UIColor = HEX_ThemeColor
    var barItemFont: CGFloat = 12
    var isShow: Bool = false
    weak var fromVc: UIViewController?
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    open override var interfaceOrientation: UIInterfaceOrientation {
        return .portrait
    }
    
    open override var shouldAutorotate: Bool {
        return false
    }
    
    public static func videoModuleEntrance(fromVC: UIViewController) {
        if miniprograms.count != 0 {
            fromVC.present(miniprograms[0], animated: true)
        } else {
            let vc = JTVideoEntranceVC()
            vc.modalPresentationStyle = .overFullScreen
            vc.fromVc = fromVC
            miniprograms.append(vc)
            fromVC.present(vc, animated: true)
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isShow = true
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        //        self.transitioningDelegate = self
        initTabbar()
        // Do any additional setup after loading the view.
    }
    
    func initTabbar() {
        let homeVc = JTClassHomeVC()
        homeVc.tabBarItem.title = "首页"
        homeVc.tabBarItem.image = JTVideoBundleTool.getBundleImg(with: "jtvideohome")
        let homeNav = JTVideoNavController(rootViewController: homeVc)
        
        let openClassVC = JTOpenLessonVC()
        openClassVC.tabBarItem.title = "公开课"
        openClassVC.tabBarItem.image = JTVideoBundleTool.getBundleImg(with: "jtopenclass")
        let openClassNav = JTVideoNavController(rootViewController: openClassVC)
        
        let mineVc = JTVideoMineVC()
        mineVc.tabBarItem.title = "我的"
        mineVc.tabBarItem.image = JTVideoBundleTool.getBundleImg(with: "jtvideomine")
        let mineNav = JTVideoNavController(rootViewController: mineVc)
        
        self.viewControllers = [homeNav, openClassNav, mineNav]
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: barItemFont), .foregroundColor: barItemColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: barItemFont), .foregroundColor: barItemSelectedColor], for: .selected)
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.isTranslucent = false
        
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerVC?.playerView.destroyPlayerView()
    }
    
    
}

extension JTVideoEntranceVC: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JTVEnterMiniprogramTransition()
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JTVExitMiniprogramTransition()
    }
}
