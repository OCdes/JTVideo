//
//  JTVideoBaseVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/11.
//

import UIKit

open class JTVideoBaseVC: UIViewController {

    
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = HEX_VIEWBACKCOLOR
        setupNavBtns()
        // Do any additional setup after loading the view.
    }
    
    func setupNavBtns() {
        self.navigationController?.navigationBar.isTranslucent = false
        if let nav = self.navigationController {
            if nav.viewControllers.count > 3 {
                
                let bb = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                bb.setImage(JTVideoBundleTool.getBundleImg(with: "jtvNavBackIcon"), for: .normal)
                bb.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
                
                let bbItem = UIBarButtonItem(customView: bb)
                
                let hb = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                hb.setImage(JTVideoBundleTool.getBundleImg(with: "mimiprogramhome"), for: .normal)
                hb.addTarget(self, action: #selector(homeBtnClicked), for: .touchUpInside)
                
                let homeItem = UIBarButtonItem(customView: hb)
                
                self.navigationItem.leftBarButtonItems = [bbItem,homeItem]
            } else if nav.viewControllers.count != 1 {
                let bb = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                bb.setImage(JTVideoBundleTool.getBundleImg(with: "jtvNavBackIcon"), for: .normal)
                bb.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
                
                let bbItem = UIBarButtonItem(customView: bb)
                
                self.navigationItem.leftBarButtonItems = [bbItem]
            }
        }
        
        
        
        let cb = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        cb.setImage(JTVideoBundleTool.getBundleImg(with: "miniprogramclose"), for: .normal)
        cb.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
        
        let closetItem = UIBarButtonItem(customView: cb)
        
        
        self.navigationItem.rightBarButtonItems = [closetItem]
    }
    
    
    @objc func homeBtnClicked() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func backBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func closeBtnClicked() {
        if let vc = self.navigationController?.viewControllers.first {
            vc.dismiss(animated: true)
        }
    }
    

}
