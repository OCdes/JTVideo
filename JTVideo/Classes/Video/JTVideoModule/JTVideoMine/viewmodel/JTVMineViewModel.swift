//
//  JTVMineViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/13.
//

import UIKit


enum JTVMineSectionType: Int {
    case profile = 0
    case course = 1
    case menu = 2
}

class JTVMineViewModel: JTVideoBaseViewModel {
    
    @objc dynamic var dataArr: [Any] = []
    var model: JTVMineModel = JTVMineModel()
    func refreshData(scrollView: UIScrollView) {
        SVPShow(content: "加载中...")
        _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_MINEPROFILE, params: [:], success: { [weak self](msg, code, response, data) in
            scrollView.jt_endRefresh()
            SVPDismiss()
            if code == 0 {
                if let dict = data["data"] as? [String:Any], let model = JTVMineModel.deserialize(from: dict) {
                    var marr: [JTVMineSectionModel] = []
                    self?.model = model
                    let sectionModel = JTVMineSectionModel()
                    sectionModel.sectionType = .profile
                    marr.append(sectionModel)
                    
                    if model.course.count > 0 {
                        let sectionModel2 = JTVMineSectionModel()
                        sectionModel2.sectionType = .course
                        sectionModel2.sectionItems = model.course
                        sectionModel2.sectionTitle = "我的课程"
                        marr.append(sectionModel2)
                    }
                    
                    let sectionModel3 = JTVMineSectionModel()
                    sectionModel3.sectionType = .menu
                    sectionModel3.navTitles = ["试卷","成绩"]
                    sectionModel3.sectionTitle = "我的测试"
                    marr.append(sectionModel3)
                    
                    let sectionModel4 = JTVMineSectionModel()
                    sectionModel4.sectionType = .menu
                    sectionModel4.navTitles = ["我的订单"]
                    sectionModel4.sectionTitle = "常用工具"
                    marr.append(sectionModel4)
                    
                    self?.dataArr = marr
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

class JTVMineModel: JTVideoBaseModel {
    var jtcoin: String = "0"
    var point: String = "0"
    var course: [JTVMineSectionItemModel] = []
}

class JTVMineSectionModel: JTVideoBaseModel {
    var sectionTitle: String = ""
    var sectionType: JTVMineSectionType = .menu
    var sectionItems: [JTVMineSectionItemModel] = []
    var navTitles: [String] = []
}

class JTVMineSectionItemModel: JTVideoBaseModel {
    
}
