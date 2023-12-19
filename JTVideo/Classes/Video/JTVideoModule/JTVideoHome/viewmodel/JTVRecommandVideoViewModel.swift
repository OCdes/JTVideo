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
    var teacherID: String = ""
    func refreshData(withScrollView: UIScrollView) {
        SVPShow(content: "加载中...")
        let apistr = teacherID.count > 0 ? POST_TEACHERSALLVIDEO : POST_JTVVIDEOS
        var params: [String:Any] = ["pageNum":pageNum,"pageSize":"12"]
        if teacherID.count > 0 {
            params["teacherId"] = teacherID
        }
        let _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: apistr, params: params) { msg, code, response, data in
            withScrollView.jt_endRefresh()
            SVPDismiss()
            if code == 0 {
                if let dataDict = data["data"] as? [String: Any], let listData = dataDict["list"] as? [[String:Any]], let lastPage = dataDict["isLastPage"] as? Bool, let arr = [JTRecommandVideoModel].deserialize(from: listData) {
                    if self.pageNum == 1 {
                        self.dataArr = arr as [Any]
                    } else {
                        var marr = Array(self.dataArr)
                        marr.append(contentsOf: arr as [Any])
                        self.dataArr = marr
                    }
                    if lastPage {
                        withScrollView.jt_endRefreshWithNoMoreData()
                    }
                }
            } else {
               SVPShowError(content: msg)
            }
        } fail: { error in
            withScrollView.jt_endRefresh()
            SVPShowError(content: error.message)
        }

    }
}

class JTRecommandVideoModel: JTVideoBaseModel {
    var id: String = ""
    var description: String = ""
    var coverImage: String = ""
    var vipPlay: Bool = false
    var typeid: String = ""
    var typeName: String = ""
    var teacherid: String = ""
    var buyerPlay: Bool = false
    var price: String = ""
    var createTime: String = ""
    var videoNumber: String = ""
    var teacherName: String = ""
    var name: String = ""
}
