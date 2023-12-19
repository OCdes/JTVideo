//
//  JTVTeacherListViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/19.
//

import UIKit

class JTVTeacherListViewModel: JTVideoBaseViewModel {
    @objc dynamic var dataArr: [Any] = []
    var pageNum: Int = 1
    func refreshData(scrollView: UIScrollView) {
        SVPShow(content: "加载中...")
        let _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_TEACHERLIST, params: ["pageNum":pageNum,"pageSize":"12"]) { msg, code, response, data in
            scrollView.jt_endRefresh()
            SVPDismiss()
            if code == 0 {
                if let dataDict = data["data"] as? [String: Any], let listData = dataDict["list"] as? [[String:Any]], let lastPage = dataDict["lastPage"] as? Bool, let arr = [JTVTeacherListItemModel].deserialize(from: listData) {
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
               SVPShowError(content: msg)
            }
        } fail: { error in
            scrollView.jt_endRefresh()
            SVPShowError(content: error.message)
        }

    }
    
}

class JTVTeacherListItemModel: JTVideoBaseModel {
    var phone: String = ""
    var id: String = ""
    var avatarUrl: String = ""
    var description: String = ""
    var agentUserid: String = ""
    var name: String = ""
}
