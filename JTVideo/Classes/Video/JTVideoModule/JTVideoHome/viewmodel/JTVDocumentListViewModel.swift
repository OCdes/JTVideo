//
//  JTVDocumentListViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/21.
//

import UIKit

class JTVDocumentListViewModel: JTVideoBaseViewModel {
    @objc dynamic var dataArr: [Any] = []
    var pageNum: Int = 1
    
    func refreshData(scrollView: UIScrollView) {
        SVPShow(content: "加载中...")
        let _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_ALLDOCUMENTRESOURCE, params: ["pageNum":pageNum, "pageSize":"12"]) { msg, code, response, data in
            scrollView.jt_endRefresh()
            SVPDismiss()
            if code == 0 {
                if let dataDict = data["data"] as? [String: Any], let listData = dataDict["list"] as? [[String:Any]], let lastPage = dataDict["lastPage"] as? Bool, let arr = [JTVDocumentListModel].deserialize(from: listData) {
                    if self.pageNum == 1 {
                        self.dataArr = arr as [Any]
                    } else {
                        var marr = Array(self.dataArr)
                        marr.append(contentsOf: arr as [Any])
                        self.dataArr = marr
                    }
                    if lastPage {
                        scrollView.jt_endRefreshWithNoMoreData()
                    }
                }
            } else {
                
            }
        } fail: { error in
            
        }

    }
}

class JTVDocumentListModel: JTVideoBaseModel {
    var id: String = ""
    var coverImage: String = ""
    var source: String = ""
    var title: String = ""
    var teacherName: String = ""
    var price: String = ""
    var content: String = ""
    var createTime: TimeInterval = 0
    var updateTime: TimeInterval = 0
}
