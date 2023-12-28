//
//  JTVDocumentDetailViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/21.
//

import UIKit

class JTVDocumentDetailViewModel: JTVideoBaseViewModel {
    var model: JTVDocumentListModel = JTVDocumentListModel()
    @objc dynamic var suStr: String = ""
    func refreshData(scrollView: UIScrollView) {
        let _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_DOCUMENTRESOURCEDETAIL, params: ["documentId":self.model.id]) { [weak self](msg, code, response, data) in
            scrollView.jt_endRefresh()
            if code == 0 {
                if let dict = data["data"] as? [String: Any], let m = JTVDocumentListModel.deserialize(from: dict) {
                    self?.model = m
                    self?.suStr = ""
                }
            } else {
                SVPShowError(content: msg)
            }
        } fail: { error in
            scrollView.jt_endRefresh()
            SVPShowError(content: error.message)
        }

    }
    
}
