//
//  JTVideoNavController.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/11.
//

import UIKit

class JTVideoNavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavAppearence()
        // Do any additional setup after loading the view.
    }
    
    func setupNavAppearence() {
        if #available(iOS 13.0, *) {
            let appearence = UINavigationBarAppearance()
            appearence.backgroundColor = HEX_ThemeColor
            appearence.titleTextAttributes = [.font : UIFont.systemFont(ofSize: 16), .foregroundColor : UIColor.white]
            self.navigationBar.standardAppearance = appearence
            self.navigationBar.scrollEdgeAppearance = self.navigationBar.standardAppearance
        } else {
            // Fallback on earlier versions
            self.navigationBar.barTintColor = HEX_ThemeColor
            self.navigationBar.backgroundColor = HEX_ThemeColor
            self.navigationBar.titleTextAttributes = [.font : UIFont.systemFont(ofSize: 15), .foregroundColor : UIColor.white]
        }
    }
    
    func setClearNavBg() {
        if #available(iOS 13.0, *) {
            let attributes = [
                NSAttributedString.Key.foregroundColor : HEX_FFF,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)
            ]
            let appearnce = UINavigationBarAppearance()
            appearnce.configureWithOpaqueBackground()
            appearnce.backgroundColor = UIColor.clear
            appearnce.titleTextAttributes = attributes
            appearnce.shadowColor = UIColor.clear
            appearnce.shadowImage = UIImage()
            appearnce.backgroundImage = UIImage()
            navigationBar.standardAppearance = appearnce
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        } else {
            // Fallback on earlier versions
            self.navigationBar.barTintColor = UIColor.clear
            self.navigationBar.backgroundColor = UIColor.clear
            self.navigationBar.titleTextAttributes = [.font : UIFont.systemFont(ofSize: 15), .foregroundColor : UIColor.white]
        }
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = self.viewControllers.count > 0
        super.pushViewController(viewController, animated: animated)
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
