//
//  JTVPowerViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/22.
//

import UIKit

class JTVPowerViewModel: JTVideoBaseViewModel {
    
    var coinsArr: [JTVCoinMoneyModel] = []
    var paywaysArr: [String] = ["微信","支付宝"]
    var resultStr: String = ""
    func fetchCoins() {
        let _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_BUYENTRANCETICKET, params: [:]) { [weak self](msg, code, response, data) in
            
        } fail: { error in
            
        }

    }
    
}



class JTVCoinMoneyModel: JTVideoBaseModel {
    
}

class JTVPayWayModel: JTVideoBaseModel {
    
}
