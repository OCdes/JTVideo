//
//  JTPlayerWindowRootVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/11/29.
//

import UIKit

class JTPlayerFullVC: UIViewController {
    lazy var surfaceView: UIView = {
        let sv = UIView(frame: self.view.bounds)
        return sv
    }()
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }
    
    open override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(surfaceView)
        surfaceView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
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
