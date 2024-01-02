//
//  JTVPaperListVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2024/1/2.
//

import UIKit

class JTVPaperListVC: JTVideoBaseVC {
    var viewModel: JTVPaperListViewModel = JTVPaperListViewModel()
    lazy var listView: JTVPaperListView = {
        let lv = JTVPaperListView(frame: CGRectZero, style: .grouped, viewModel: self.viewModel)
        return lv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.navigationVC = self.navigationController
        view.addSubview(listView)
        listView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        }
        
        _ = listView.jt_addRefreshHeader {
            self.viewModel.pageNum = 1
            self.viewModel.refreshData(scrollView: self.listView)
        }
        
        _ = listView.jt_addRefreshFooter {
            self.viewModel.pageNum += 1
            self.viewModel.refreshData(scrollView: self.listView)
        }
        
        listView.jt_startRefresh()
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
