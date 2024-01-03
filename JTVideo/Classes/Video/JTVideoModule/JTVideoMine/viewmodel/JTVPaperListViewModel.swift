//
//  JTVPaperListViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2024/1/2.
//

import UIKit

enum PaperListType: Int {
    case paper = 1
    case course = 2
    case result = 3
}

class JTVPaperListViewModel: JTVideoBaseViewModel {
    var type: PaperListType = .paper
    var pageNum: Int = 1
    @objc dynamic var dataArr: [Any] = []
    
    func refreshData(scrollView: UIScrollView) {
        _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_FETCHMYCOURSE, params: ["pageNum":pageNum, "pageSize":"12"], success: { msg, code, response, data in
            scrollView.jt_endRefresh()
            if code == 0 {
                if let dataDict = data["data"] as? [String: Any], let listData = dataDict["list"] as? [[String:Any]], let lastPage = dataDict["isLastPage"] as? Bool, let arr = [JTVPaperListModel].deserialize(from: listData) {
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

class JTVPaperListModel: JTVideoBaseModel {
    var coverImage: String = ""
    var id: String = ""
    var name: String = ""
    var payAmount: String = ""
    var payOrderNo: String = ""
    var payTime: TimeInterval = 0
}
