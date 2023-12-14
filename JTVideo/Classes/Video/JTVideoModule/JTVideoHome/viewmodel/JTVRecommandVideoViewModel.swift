//
//  JTVRecommandVideoViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/14.
//

import UIKit

class JTVRecommandVideoViewModel: JTVideoBaseViewModel {
    @objc dynamic var dataArr: [Any] = []
    var pageNum: Int = 1
    func refreshData(withScrollView: UIScrollView) {
        SVPShow(content: "加载中...")
        let _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_JTVVIDEOS, params: ["pageNum":pageNum,"pageSize":"12"]) { msg, code, response, data in
            withScrollView.jt_endRefresh()
            SVPDismiss()
            if code == 0 {
                
            } else {
                
            }
        } fail: { error in
            withScrollView.jt_endRefresh()
            SVPShowError(content: error.message)
        }

    }
}
