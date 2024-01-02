//
//  JTVideoMineVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/11.
//

import UIKit

class JTVideoMineVC: JTVideoBaseVC {
    var viewModel: JTVMineViewModel = JTVMineViewModel()
    lazy var listView: JTVMineListView = {
        let layout = UICollectionViewFlowLayout()
        let lv = JTVMineListView(frame: CGRectZero, collectionViewLayout: layout, viewModel: self.viewModel)
        if #available(iOS 11.0, *) {
            lv.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return lv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = self.navigationController as? JTVideoNavController {
            nav.setClearNavBg()
            nav.navigationBar.isTranslucent = true
        }
        self.viewModel.refreshData(scrollView: self.listView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let nav = self.navigationController as? JTVideoNavController {
            nav.setupNavAppearence()
            nav.navigationBar.isTranslucent = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.navigationVC = self.navigationController
        self.navigationController?.navigationBar.isTranslucent = true
        view.addSubview(self.listView)
        self.listView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        _ = self.listView.jt_addRefreshHeader {
            self.viewModel.refreshData(scrollView: self.listView)
        }
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
