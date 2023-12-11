//
//  JTVideoEntranceVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/11.
//

import UIKit
@objc
open class JTVideoEntranceVC: UITabBarController {
    var barItemColor: UIColor = HEX_COLOR(hexStr: "#bfbfbf")
    var barItemSelectedColor: UIColor = HEX_COLOR(hexStr: "#2c2c2c")
    var barItemFont: CGFloat = 12
    open override func viewDidLoad() {
        super.viewDidLoad()
        initTabbar()
        // Do any additional setup after loading the view.
    }
    
    func initTabbar() {
        let homeVc = JTVideoHomeVC()
        homeVc.tabBarItem.title = "首页"
        homeVc.tabBarItem.image = JTVideoBundleTool.getBundleImg(with: "jtvideohome")
        homeVc.tabBarItem.selectedImage = JTVideoBundleTool.getBundleImg(with: "jtvideohome-selected")
        let homeNav = JTVideoNavController(rootViewController: homeVc)
        
        let openClassVC = JTOpenLessonVC()
        openClassVC.tabBarItem.title = "公开课"
        openClassVC.tabBarItem.image = JTVideoBundleTool.getBundleImg(with: "jtopenclass")
        openClassVC.tabBarItem.selectedImage = JTVideoBundleTool.getBundleImg(with: "jtopenclass-selected")
        let openClassNav = JTVideoNavController(rootViewController: openClassVC)
        
        let mineVc = JTVideoMineVC()
        mineVc.tabBarItem.title = "我的"
        mineVc.tabBarItem.image = JTVideoBundleTool.getBundleImg(with: "jtvideomine")
        mineVc.tabBarItem.image = JTVideoBundleTool.getBundleImg(with: "jtvideomine-selected")
        let mineNav = JTVideoNavController(rootViewController: mineVc)
        
        self.viewControllers = [homeNav, openClassNav, mineNav]
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: barItemFont)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.font: UIFont.systemFont(ofSize: barItemFont)], for: .selected)
        self.tabBar.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
    }
    

    

}