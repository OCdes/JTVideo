//
//  JTClassPlayVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/15.
//

import UIKit

class JTClassPlayVC: JTVideoBaseVC {
    var viewModel: JTClassPlayViewModel = JTClassPlayViewModel()
    lazy var playView: JTClassPlayView = {
        let pv = JTClassPlayView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), style: .grouped, viewModel: self.viewModel)
        return pv
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

