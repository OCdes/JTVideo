//
//  JTVClassDetailVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/14.
//

import UIKit

class JTVClassDetailVC: JTVideoBaseVC {
    var viewModel: JTVClassDetailViewModel = JTVClassDetailViewModel()
    lazy var detailView: JTVClassDetailView = {
        let dv = JTVClassDetailView.init(frame: self.view.bounds, style: .grouped, viewModel: self.viewModel)
        return dv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "课程详情"
        view.backgroundColor = HEX_VIEWBACKCOLOR
        view.addSubview(self.detailView)
        self.detailView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        let _ = self.detailView.jt_addRefreshHeader {
            self.viewModel.refreshData(scrollView: self.detailView)
        }
        
        self.detailView.jt_startRefresh()
        
    }

}
