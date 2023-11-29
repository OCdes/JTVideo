//
//  JTVideoDetailVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/11/28.
//

import UIKit

@objc
open class JTVideoDetailVC: UIViewController, JTPlayerViewDelegate {
    func requirePopVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func playerWillEnterPictureInPicture() {
        
    }
    
    func requireFullScreen(fullScreen: Bool) {
        isFullScreen = fullScreen
        setOrientation()
    }
    
    lazy var playerView: JTPlayerView = {
        let pv = JTPlayerView(frame: CGRectZero)
        pv.delegate = self
        return pv
    }()
    
    var isFullScreen: Bool = false
    
    var url: String = "" {
        didSet {
            self.playerView.urlSource = url
        }
    }
    
    open override func prefersHomeIndicatorAutoHidden() -> Bool {
        return isFullScreen
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = HEX_FFF
        view.addSubview(playerView)
        playerView.snp_makeConstraints { make in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(kScreenWidth)
        }
    }
    
    func setOrientation() {
        if #available(iOS 16.0, *) {
            setNeedsUpdateOfSupportedInterfaceOrientations()
            if let Scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: isFullScreen ? .landscapeLeft : .portrait)
                
                Scene.requestGeometryUpdate(geometryPreferences) { error in
                    print("屏幕旋转失败,error:\(error.localizedDescription)")
                }
            }
            
        } else {
            let orientation: UIInterfaceOrientation = isFullScreen ? .landscapeLeft : .portrait
            UIDevice.current.setValue(orientation.rawValue , forKey: "orientation")
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
