//
//  JTVPowerVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/22.
//

import UIKit

class JTVPowerVC: JTVideoBaseVC {
    var viewModel: JTVPowerViewModel = JTVPowerViewModel()
    lazy var coinView: JTVPowerView = {
        let cv = JTVPowerView(frame: self.view.bounds, style: .grouped, viewModel: self.viewModel)
        return cv
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(coinView)
        coinView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        _ = coinView.jt_addRefreshHeader {
            self.viewModel.fetchCoins(scrollView: self.coinView)
        }
        
        coinView.jt_startRefresh()
    }
    

    

}
