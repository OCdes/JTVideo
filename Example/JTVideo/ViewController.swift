//
//  ViewController.swift
//  JTVideo
//
//  Created by OCdes on 11/01/2023.
//  Copyright (c) 2023 OCdes. All rights reserved.
//

import UIKit
import JTVideo
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        // Do any additional setup after loading the view, typically from a nib.
        let titles = ["视频列表","短视频","视频详情页","精特云课堂"]
        for i in 0..<4 {
            let btn = UIButton(frame: CGRect(x: 50, y: 100 + i * 70, width: Int(UIScreen.main.bounds.width)-100, height: 50))
            btn.tag = i
            btn.setTitle(titles[i], for: .normal)
            btn.backgroundColor = UIColor.orange
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.addTarget(self, action: #selector(btnClicked(btn:)), for: .touchUpInside)
            view.addSubview(btn)
        }
    }
    
    @objc func btnClicked(btn: UIButton) {
        switch btn.title(for: .normal)! {
        case "视频列表":
            let vc = JTPlayerListVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "短视频":
            let vc = JTShortVideoVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "视频详情页":
            let vc = JTVideoHomeVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "精特云课堂":
            JTVideoManager.manager.AccessToken = "b4670c57da934436a5017c8d081a0225"
            JTVideoManager.manager.url = "http://vod.hzjtyh.com"
            JTVideoManager.manager.name = "iOS 测试"
            JTVideoManager.manager.avatarUrl = "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fsafe-img.xhscdn.com%2Fbw1%2F76264826-a8a7-4481-8d93-8689c1f2107f%3FimageView2%2F2%2Fw%2F1080%2Fformat%2Fjpg&refer=http%3A%2F%2Fsafe-img.xhscdn.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1705826701&t=7ceb1a1975cc4aa557a72903cc604f1b"
            JTVideoEntranceVC.videoModuleEntrance(fromVC: self)
            break
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

