//
//  JTOpenLessonVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/11.
//

import UIKit

class JTOpenLessonVC: JTVideoBaseVC {

    var viewModel: JTVRecommandVideoViewModel = JTVRecommandVideoViewModel()
    lazy var listView: JTVRecommandVideList = {
        let lv = JTVRecommandVideList(frame: CGRect(x:0, y:0, width: self.view.frame.width, height: self.view.frame.height), style: .grouped, viewModel: self.viewModel)
        return lv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "视频课程"
        self.tabBarItem.title = "公开课"
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

}
