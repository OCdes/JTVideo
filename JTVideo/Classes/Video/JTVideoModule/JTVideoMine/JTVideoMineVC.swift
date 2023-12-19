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
        return lv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.listView)
        self.listView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        _ = self.listView.jt_addRefreshHeader {
            self.viewModel.refreshData(scrollView: self.listView)
        }
        self.listView.jt_startRefresh()
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
