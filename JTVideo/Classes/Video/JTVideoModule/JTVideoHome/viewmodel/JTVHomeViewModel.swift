//
//  JTVHomeViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/13.
//

import UIKit

enum JTVHomeSectionType: Int {
    case none = 0
    case bannerType = 1
    case categoryType = 2
    case recommandVideoType = 3
    case recommandTeacherType = 4
    
}

class JTVHomeViewModel: JTVideoBaseViewModel {
    @objc dynamic var dataArr: [Any] = []
    
    func refreHomePage(scrollView: UIScrollView) {
        _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_JTVHOME, params: [:], success: { msg, code, response, data in
            
        }, fail: { error in
            
        })
    }
    
}

class JTVHomeSectionModel: JTVideoBaseModel {
    var sectionTitle: String = ""
    var sectionType: JTVHomeSectionType = .none
    var sectionItems: [Any] = []
}


