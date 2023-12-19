//
//  JTOpenClassViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/13.
//

import UIKit

class JTOpenClassViewModel: JTVideoBaseViewModel {
    @objc dynamic var dataArr: [Any] = []
    
    func refreshData(scrollView: UIScrollView) {
        SVPShow(content: "加载中...")
        _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_OPENCLASSHOMEPAGE, params: [:], success: { [weak self](msg, code, response, data) in
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
                    
                    if let items = dict["recommend"] as? [Any], let videoModes = [JTVHomeSectionItemModel].deserialize(from: items) as? [JTVHomeSectionItemModel] {
                        let sectionModel = JTVHomeSectionModel()
                        sectionModel.sectionType = .recommandVideoType
                        sectionModel.sectionTitle = "title"
                        sectionModel.sectionItems = videoModes
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
