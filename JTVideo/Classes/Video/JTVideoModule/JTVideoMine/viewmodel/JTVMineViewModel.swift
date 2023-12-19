//
//  JTVMineViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/13.
//

import UIKit


enum JTVMineSectionType: Int {
    case course = 1
    case menu = 2
}

class JTVMineViewModel: JTVideoBaseViewModel {
    
    @objc dynamic var dataArr: [Any] = []
    
    func refreshData(scrollView: UIScrollView) {
        SVPShow(content: "加载中...")
        _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_MINEPROFILE, params: [:], success: { msg, code, response, data in
            scrollView.jt_endRefresh()
            SVPDismiss()
            if code == 0 {
                
            } else {
                SVPShowError(content: msg)
            }
        }, fail: { error in
            scrollView.jt_endRefresh()
            SVPShowError(content: error.message)
        })
    }
}

class JTVMineSectionModel: JTVideoBaseModel {
    var sectionTitle: String = ""
    var sectionType: JTVMineSectionType = .menu
    var sectionItems: [JTVMineSectionItemModel] = []
}

class JTVMineSectionItemModel: JTVideoBaseModel {
    
}
