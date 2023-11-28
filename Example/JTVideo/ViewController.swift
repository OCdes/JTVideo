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
        let titles = ["视频列表","短视频","视频详情页"]
        for i in 0..<3 {
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
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

