//
//  JTVTeacherInfoViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/19.
//

import UIKit

class JTVTeacherInfoViewModel: JTVideoBaseViewModel {
    @objc dynamic var dataArr: [Any] = []
    var pageNum: Int = 1
    var model: JTVTeacherListItemModel = JTVTeacherListItemModel()
    
    func refreshData(scrollView: UIScrollView) {
        SVPShow(content: "加载中...")
        _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_TEACHERINFO, params: ["pageNum":pageNum, "teacherId":self.model.id, "pageSize":"12"], success: { msg, code, response, data in
            scrollView.jt_endRefresh()
            SVPDismiss()
            if code == 0 {
                if let dataDict = data["data"] as? [String: Any], let listData = dataDict["list"] as? [[String:Any]], let lastPage = dataDict["isLastPage"] as? Bool, let arr = [JTVHomeSectionItemModel].deserialize(from: listData) {
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
        }, fail: { error in
            scrollView.jt_endRefresh()
            SVPShowError(content: error.message)
        })
    }
}

