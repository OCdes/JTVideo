//
//  JTVExaminationPaperViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2024/1/2.
//

import UIKit

class JTVExaminationPaperViewModel: JTVideoBaseViewModel {
    
    var collectionId: String = ""
    @objc dynamic var dataArr: [Any] = []
    func fetchExaminations(scrollView: UIScrollView) {
        SVPShow(content: "正在获取试卷....")
        
        _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_FETCHEXAMINATIONS, params: ["collectionId":self.collectionId], success: { [weak self](msg, code, response, data) in
            scrollView.jt_endRefresh()
            SVPDismiss()
            if code == 0 {
                if let dataDict = data["data"] as? [[String:Any]], let dataList = [JTVExaminationPaperModel].deserialize(from: dataDict) {
                    var marr: [JTVExaminationPaperModel] = []
                    for i in 0..<dataList.count {
                        if let m = dataList[i] {
                            var mvarr: [JTVVerbsModel] = []
                            let carr: [String] = (m.content as NSString).components(separatedBy: "\r\n")
                            if carr.count > 0 {
                                for j in 0..<carr.count {
                                    let verbm = JTVVerbsModel()
                                    let verbStr: String = carr[j]
                                    let varr: [String] = (verbStr as NSString).components(separatedBy: "、")
                                    if varr.count > 0 {
                                        if varr.count == 2 {
                                            verbm.titleStr = varr[0]
                                            verbm.contentStr = varr[1]
                                        }  else {
                                            verbm.titleStr = "\(i)"
                                            verbm.contentStr = verbStr
                                        }
                                    } else {
                                        verbm.titleStr = "\(i)"
                                        verbm.contentStr = carr[j]
                                    }
                                    mvarr.append(verbm)
                                }
                            }
                            m.verbs = mvarr
                            marr.append(m)
                        }
                    }
                    self?.dataArr = marr
                }
            } else {
                SVPShowError(content: msg)
            }
        }, fail: { error in
            scrollView.jt_endRefresh()
        })
    }
    
}


class JTVExaminationPaperModel: JTVideoBaseModel {
    var content: String = ""
    var id: String = ""
    var title: String = ""
    var teacherId: String = ""
    var correct: String = ""
    var teacherName: String = ""
    var createTime: TimeInterval = 0
    var verbs: [JTVVerbsModel] = []
}

class JTVVerbsModel: JTVideoBaseModel {
    var titleStr: String = ""
    var contentStr: String = ""
    var isSelected: Bool = false
}
