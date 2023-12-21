//
//  JTVHomeViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/13.
//

import UIKit
import HandyJSON

enum JTVHomeSectionType: Int {
    case none = 0
    case bannerType = 1
    case categoryType = 2
    case recommandVideoType = 3
    case recommandTeacherType = 4
    case documentResource = 5
}

class JTVHomeViewModel: JTVideoBaseViewModel {
    @objc dynamic var dataArr: [Any] = []
    
    func refreshHomePage(scrollView: UIScrollView) {
        SVPShow(content: "加载中...")
        _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_JTVHOME, params: [:], success: { [weak self] msg, code, response, data in
            scrollView.jt_endRefresh()
            SVPDismiss()
            if code == 0 {
                if let dict = data["data"] as? [String:Any] {
                    var sectionArr: [JTVHomeSectionModel] = []
                    if let bannerArrs = dict["banners"] as? [Any], let bannerModels = [JTVHomeSectionItemModel].deserialize(from: bannerArrs) as? [JTVHomeSectionItemModel] {
                        let sectionModel = JTVHomeSectionModel()
                        sectionModel.sectionType = .bannerType
                        sectionModel.sectionItems = bannerModels
                        var murlArr: [String] = []
                        for im in bannerModels {
                            murlArr.append(im.adUrl)
                        }
                        sectionModel.imgUrls = murlArr
                        sectionArr.append(sectionModel)
                    }
                    if let navsArr = dict["nav"] as? [Any], let navModels = [JTVHomeSectionItemModel].deserialize(from: navsArr) as? [JTVHomeSectionItemModel] {
                        let sectionModel = JTVHomeSectionModel()
                        sectionModel.sectionType = .categoryType
                        sectionModel.sectionItems = navModels
                        sectionArr.append(sectionModel)
                    }
                    if let videosDict = dict["videos"] as? [String:Any], let title = videosDict["key"] as? String, let items = videosDict["value"] as? [Any], let videoModes = [JTVHomeSectionItemModel].deserialize(from: items) as? [JTVHomeSectionItemModel] {
                        let sectionModel = JTVHomeSectionModel()
                        sectionModel.sectionType = .recommandVideoType
                        sectionModel.sectionTitle = title
                        sectionModel.sectionItems = videoModes
                        sectionArr.append(sectionModel)
                    }
                    if let teachersDict = dict["teacher"] as? [String:Any], let title = teachersDict["key"] as? String, let items = teachersDict["value"] as? [Any] , let teacherModes = [JTVHomeSectionItemModel].deserialize(from: items) as? [JTVHomeSectionItemModel] {
                        let sectionModel = JTVHomeSectionModel()
                        sectionModel.sectionType = .recommandTeacherType
                        sectionModel.sectionTitle = title
                        sectionModel.sectionItems = teacherModes
                        sectionArr.append(sectionModel)
                    }
                    
                    if let documentDict = dict["document"] as? [String:Any], let title = documentDict["key"] as? String, let items = documentDict["value"] as? [Any] , let documents = [JTVHomeSectionItemModel].deserialize(from: items) as? [JTVHomeSectionItemModel] {
                        let sectionModel = JTVHomeSectionModel()
                        sectionModel.sectionType = .documentResource
                        sectionModel.sectionTitle = title
                        sectionModel.sectionItems = documents
                        sectionArr.append(sectionModel)
                    }
                    
                    self?.dataArr = sectionArr
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

class JTVHomeSectionModel: JTVideoBaseModel {
    var sectionTitle: String = ""
    var sectionType: JTVHomeSectionType = .none
    var sectionItems: [JTVHomeSectionItemModel] = []
    var imgUrls: [String] = []
}

class JTVHomeSectionItemModel: JTVideoBaseModel {
    var name: String = ""
    var id: String = ""
    var description: String = ""
    var createTime: TimeInterval = 0
    //banner
    var adUrl: String = ""
    var jumpUrl: String = ""
    var adKey: String = ""
    //nav
    var image: String = ""
    //video
    var coverImage: String = ""
    var vipPlay: Bool = false
    var typeid: String = ""
    var typeName: String = ""
    var teacherid: String = ""
    var buyerPlay: Bool = false
    var price: String = ""
    var keywords: String = ""
    var remark: String = ""
    var videoNumber: String = ""
    var teacherName: String = ""
    var ownerUserid: String = ""
    var updateTime: TimeInterval = 0
    //teacher
    var phone: String = ""
    var gender: Int = 0
    var age: String = ""
    var status: String = ""
    var avatarUrl: String = ""
    var agentUserid: String = ""
    var isPrivate: Bool = false
    //
    var title: String = ""
    var content: String = ""
    var source: String = ""
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.isPrivate <-- "private"
    }
}


