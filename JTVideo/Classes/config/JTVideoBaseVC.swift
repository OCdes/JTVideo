//
//  JTVideoBaseVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/11.
//

import UIKit

open class JTVideoBaseVC: UIViewController, UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 1 {
            if let pan = gestureRecognizer as? UIScreenEdgePanGestureRecognizer {
                let velocity = pan.velocity(in: self.view)
                if let vc = self.navigationController?.viewControllers.first {
                    vc.dismiss(animated: true)
                }
                return false
            }
        }
        return true
        
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.isKind(of: UIScreenEdgePanGestureRecognizer.self)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private lazy var pan: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizer(pan:)))
    }()
    
    @objc func panGestureRecognizer(pan: UIPanGestureRecognizer) {
        let state = pan.state
        if let vc = self.navigationController?.viewControllers.first {
            vc.dismiss(animated: true)
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.navigationController?.viewControllers.count == 1 {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self.pan.isEnabled = true
        } else {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.pan.isEnabled = false
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = HEX_VIEWBACKCOLOR
        view.addGestureRecognizer(pan)
        setupNavBtns()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @objc func popGesturerecognizer(gesture: UIGestureRecognizer) {
        let state = gesture.state
        if state == .began {
            
        } else if state == .changed {
            
        } else if state == .ended {
            
        }
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
        let enterVC = miniprograms[0]
        enterVC.isShow = false
        enterVC.dismiss(animated: true)
//        if let vc = self.navigationController?.viewControllers.first {
//            vc.dismiss(animated: true)
//        }
    }
    

}
