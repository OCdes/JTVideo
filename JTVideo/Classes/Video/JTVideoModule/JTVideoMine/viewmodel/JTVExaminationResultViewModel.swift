//
//  JTVExaminationViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2024/1/3.
//

import UIKit

class JTVExaminationResultViewModel: JTVideoBaseViewModel {
    
    var collectionId: String = ""
    @objc dynamic var dataArr: [Any] = []
    
    func refreshData(scrollView: UIScrollView) {
        _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_QUERYRESULT, params: ["collectionId":self.collectionId], success: { [weak self](msg, code, response, data) in
            scrollView.jt_endRefresh()
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
                                            verbm.titleStr = "\(j+1)"
                                            verbm.contentStr = verbStr
                                        }
                                    } else {
                                        verbm.titleStr = "\(j+1)"
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
            SVPShowError(content: error.message)
        })
    }
}
