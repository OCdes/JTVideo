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
        let lv = JTVRecommandVideList(frame: CGRect(x:0, y:0, width: self.view.frame.width, height: self.view.frame.height), style: .grouped, viewModel: self.viewModel)
        return lv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.navigationVC = self.navigationController
        self.title = "视频课程"
        view.backgroundColor = HEX_VIEWBACKCOLOR
        view.addSubview(listView)
        listView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14))
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
