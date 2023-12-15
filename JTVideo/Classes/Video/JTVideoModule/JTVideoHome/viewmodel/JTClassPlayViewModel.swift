//
//  JTClassPlayViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/15.
//

import UIKit

class JTClassPlayViewModel: JTVideoBaseViewModel {
    var id: String = ""
    var dataArr: [JTVClassDetailItemModel] = []
    @objc dynamic var url: String = ""
    func generateUrlBy(id: String) {
        SVPShow(content: "正在生成播放链...")
        let _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_GENERATEURL, params: ["videoId":id]) { msg, code, response, data in
            SVPDismiss()
            if code == 0 {
                
            } else {
                SVPShowError(content: msg)
            }
        } fail: { error in
            SVPShowError(content: error.message)
        }

    }
}

