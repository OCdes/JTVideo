//
//  JTVRecommandVideListVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/14.
//

import UIKit

class JTVRecommandVideListVC: JTVideoBaseVC {
    var viewModel: JTVRecommandVideoViewModel = JTVRecommandVideoViewModel()
    lazy var listView: JTVRecommandVideList = {
        let lv = JTVRecommandVideList(frame: CGRect.zero, style: .grouped, viewModel: self.viewModel)
        return lv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(listView)
        listView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        _ = listView.jt_addRefreshHeader {
            self.viewModel.pageNum = 1
            self.viewModel.refreshData(withScrollView: self.listView)
        }
        
        _ = listView.jt_addRefreshFooter {
            self.viewModel.pageNum += 1
            self.viewModel.refreshData(withScrollView: self.listView)
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
