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
        sb.addTarget(self, action: #selector(subscribeBtnClicked), for: .touchUpInside)
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.navigationVC = self.navigationController
        
        view.backgroundColor = HEX_VIEWBACKCOLOR
        view.addSubview(scribeBtn)
        scribeBtn.snp_makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-16)
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.width-28, height: 40))
        }
        
        view.addSubview(self.detailView)
        self.detailView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        _ = viewModel.rx.observeWeakly([Any].self, "dataArr").subscribe(onNext: { [weak self]arr in
            if let p = Float(self?.viewModel.detailModel.info.price ?? "0"), p > 0 {
                self?.detailView.snp_remakeConstraints { make in
                    make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0))
                }
            }
            if let strongSelf = self, strongSelf.viewModel.detailModel.info.userPaid == false {
                self?.detailView.snp_remakeConstraints { make in
                    make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0))
                }
            }
            self?.title = self?.viewModel.detailModel.info.name
        })
        
        let _ = self.detailView.jt_addRefreshHeader {
            self.viewModel.refreshData(scrollView: self.detailView)
        }
        
        self.detailView.jt_startRefresh()
        
    }
    
    @objc func subscribeBtnClicked() {
        let vc = JTVBuyClassVC()
        vc.viewModel.cmodel = self.viewModel.detailModel
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
