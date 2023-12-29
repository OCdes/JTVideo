//
//  JTOpenLessonVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/11.
//

import UIKit

class JTOpenLessonVC: JTVideoBaseVC {

    var viewModel: JTOpenClassViewModel = JTOpenClassViewModel()
    lazy var listView: JTOpenClassHomeView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width-27, height: 134)
        layout.minimumLineSpacing = 13
        let lv = JTOpenClassHomeView(frame: CGRect.zero, collectionViewLayout: layout, viewModel: self.viewModel)
        return lv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "视频课程"
        self.tabBarItem.title = "公开课"
        viewModel.navigationVC = self.navigationController
        view.backgroundColor = HEX_VIEWBACKCOLOR
        view.addSubview(listView)
        listView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14))
        }
        
        _ = listView.jt_addRefreshHeader {
            self.viewModel.refreshData(scrollView: self.listView)
        }
        
        self.listView.jt_startRefresh()
        // Do any additional setup after loading the view.
    }

}
