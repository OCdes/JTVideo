//
//  JTVPowerViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/22.
//

import UIKit

class JTVPowerViewModel: JTVideoBaseViewModel {
    
    var model: JTVCoinModel = JTVCoinModel()
    var paywaysArr: [String] = ["微信","支付宝"]
    var payChannel: String = "WEIXIN"//WEIXIN//ALIPAY
    var amount: Int = 0
    @objc dynamic var resultStr: String = ""
    func fetchCoins(scrollView: UIScrollView) {
        SVPShow(content: "加载中...")
        let _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_BUYENTRANCETICKET, params: [:]) { [weak self](msg, code, response, data) in
            SVPDismiss()
            scrollView.jt_endRefresh()
            if code == 0 {
                if let dataDict = data["data"] as? [String:Any], let model = JTVCoinModel.deserialize(from: dataDict) {
                    model.exchange_list.append(0)
                    self?.model = model
                    self?.resultStr = "0"
                }
            } else {
                SVPShowError(content: msg)
            }
        } fail: { error in
            scrollView.jt_endRefresh()
            SVPShowError(content: error.message)
        }
    }
    
    func charJTC() {
        SVPNoUserinteractShow(content: "支付中...")
        let _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_CHARJTC, params: ["amount":self.amount, "paymentChannel": self.payChannel]) { msg, code, response, data in
            if code == 0 {
                if let dataDict = data["data"] as? [String:Any], let qr_code = dataDict["qr_code"] as? String, let url = URL(string: qr_code), let terminal_trace = dataDict["terminal_trace"] as? String, let terminal_time = dataDict["terminal_time"] as? String, let merchant_no = dataDict["merchant_no"]  as? String{
                    UIApplication.shared.open(url, options: [:]) { b in
                        self.payResult(orderNo: terminal_trace, terminalTime: terminal_time, merchantNo: merchant_no)
                    }
                }
            } else {
                SVPShowError(content: msg)
            }
        } fail: { error in
            SVPShow(content: error.message)
        }

    }
    
    
    static var count = 0
    func payResult(orderNo: String, terminalTime: String, merchantNo: String) {
        SVPNoUserinteractShow(content: "支付结果查询中。。。")
        _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: "/v1/recharge/fineOrderPaymentResult", params: ["payTerminalTrace":orderNo,"payTerminalTime":terminalTime,"payMerchantNo":merchantNo], success: { msg, code, response, data in
            guard let dataDict = data["data"] as? [String:Any] else { return }
            guard let result_code = dataDict["result_code"] as? String else { return }
            if result_code == "01" {
                SVPShowSuccess(content: "支付成功")
                self.fetchCoins(scrollView: UIScrollView())
            } else if result_code == "02" {
                SVPShowError(content: "支付失败")
            } else  {
                if JTVPowerViewModel.count < 6 {
                    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()+5, execute: DispatchWorkItem(block: {
                        JTVPowerViewModel.count += 1
                        self.payResult(orderNo: orderNo, terminalTime: terminalTime, merchantNo: merchantNo)
                    }))
                } else {
                    JTVPowerViewModel.count = 0
                    SVPShowError(content: "结果查询失败,请联系管理员")
                }
                
            }
        }, fail: { errorInfo in
            JTVPowerViewModel.count = 0
            SVPShowError(content: errorInfo.message)
        })
    }
}



class JTVCoinModel: JTVideoBaseModel {
    var exchange_list: [Int] = []
    var jtcoin: Int = 0
    var exchange_rate: Float = 0
    var point: Int = 0
}

class JTVPayWayModel: JTVideoBaseModel {
    
}
