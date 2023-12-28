//
//  JTVClassDetailViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/15.
//

import UIKit

class JTVClassDetailViewModel: JTVideoBaseViewModel {
    @objc dynamic var dataArr: [Any] = []
    var collectionID: String = ""
    var detailModel:JTVClassDetailModel = JTVClassDetailModel()
    func refreshData(scrollView: UIScrollView) {
        SVPShow(content: "加载中...")
        let _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_JTVVIDEODETAILS, params: ["collectionId":self.collectionID]) {[weak self] msg, code, response, data in
            scrollView.jt_endRefresh()
            SVPDismiss()
            if code == 0 {
                if let dataDict = data["data"] as? [String: Any] , let model = JTVClassDetailModel.deserialize(from: dataDict){
                    self?.detailModel = model
                    self?.dataArr = model.playDetails
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

class JTVClassDetailModel: JTVideoBaseModel {
    var playDetails: [JTVClassDetailItemModel] = []
    var info: JTVClassDetailInfoModel = JTVClassDetailInfoModel()
}

class JTVClassDetailInfoModel: JTVideoBaseModel {
    var id: String = ""
    var description: String = ""
    var coverImage: String = ""
    var vipPlay: Bool = false
    var typeid: String = ""
    var typeName: String = ""
    var teacherid: String = ""
    var buyerPlay: Bool = false
    var price: String = "0"
    var createTime: String = ""
    var videoNumber: String = ""
    var teacherName: String = ""
    var name: String = ""
    var updateTime: String = ""
    var userPaid: Bool = false
    
}

class JTVClassDetailItemModel: JTVideoBaseModel {
    var status: String = ""
    var sort: String = ""
    var filesize: String = ""
    var id: String = ""
    var userPaid: Bool = false
    var title: String = ""
    var coverImage: String = ""
    var videoBaseurl: String = ""
    var videoid: String = ""
    var createTime: TimeInterval = 0
}
