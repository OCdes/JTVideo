//
//  JTPlayerWindowRootVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/11/29.
//

import UIKit

class JTPlayerFullVC: UIViewController {
    var playerSurface: UIView?
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }
    
    
    open func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.playerSurface?.frame = self.view.bounds
        print("%@", self.playerSurface?.bounds)
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
