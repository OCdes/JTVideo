//
//  JTVBuyClassViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/22.
//

import UIKit
import RxSwift

enum BuyItemType: Int {
    case course = 1
    case document = 2
}

class JTVBuyClassViewModel: JTVideoBaseViewModel {
    var cmodel: JTVClassDetailModel = JTVClassDetailModel() {
        didSet {
            type = .course
        }
    }
    
    var dmodel: JTVDocumentListModel = JTVDocumentListModel() {
        didSet {
            type = .document
        }
    }
    var remark: String = ""
    var type: BuyItemType = .course
    var paidSuccessSubject: PublishSubject<Bool> = PublishSubject<Bool>()
    func buyClass() {
        SVPShow(content: "请求中...")
        var param:[String:Any] = ["remark":remark, "type":type.rawValue]
        
        if type == .course{
            param["id"] = cmodel.info.id
        } else {
            param["id"] = dmodel.id
        }
        let _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_BUYCOURSEDOCUMENT, params: param) { msg, code, response, data in
            if code == 0 {
                SVPShowSuccess(content: "购买成功")
                self.paidSuccessSubject.onNext(true)
                self.navigationVC?.popViewController(animated: true)
            } else {
                SVPShowError(content: msg)
            }
        } fail: { error in
            SVPShowError(content: error.message)
        }

    }
}
