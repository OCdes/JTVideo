//
//  JTClassPlayViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/15.
//

import UIKit

class JTClassPlayViewModel: JTVideoBaseViewModel {
    var detailModel: JTVClassDetailModel = JTVClassDetailModel() 
    var id: String = ""
    @objc dynamic var url: String = ""
    func generateUrlBy(id: String) {
        self.id = id
        SVPShow(content: "正在生成播放链...")
        let _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_GENERATEURL, params: ["videoId":id]) { [weak self]msg, code, response, data in
            SVPDismiss()
            if code == 0 {
                if let urlStr = data["data"] as? String {
                    self?.url = urlStr
                }
            } else {
                SVPShowError(content: msg)
            }
        } fail: { error in
            SVPShowError(content: error.message)
        }

    }
}

