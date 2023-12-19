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
    
    lazy var scribeBtn: UIButton = {
        let sb = UIButton()
        sb.layer.cornerRadius = 20
        sb.layer.masksToBounds = true
        sb.backgroundColor = HEX_ThemeColor
        sb.setTitleColor(HEX_FFF, for: .normal)
        sb.setTitle("立即订阅", for: .normal)
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.navigationVC = self.navigationController
        self.title = "课程详情"
        view.backgroundColor = HEX_VIEWBACKCOLOR
        view.addSubview(self.detailView)
        self.detailView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0))
        }
        view.addSubview(scribeBtn)
        scribeBtn.snp_makeConstraints { make in
            make.centerX.equalTo(self.detailView)
            make.top.equalTo(self.detailView.snp_bottom).offset(12)
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.width-28, height: 40))
        }
        
        let _ = self.detailView.jt_addRefreshHeader {
            self.viewModel.refreshData(scrollView: self.detailView)
        }
        
        self.detailView.jt_startRefresh()
        
    }

}
