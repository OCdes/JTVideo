//
//  JTVAnswerCardViewModel.swift
//  JTVideo
//
//  Created by 袁炳生 on 2024/1/3.
//

import UIKit

class JTVAnswerCardViewModel: JTVideoBaseViewModel {

    var dataArr: [JTVExaminationPaperModel] = []
    
    var collectionId: String = ""
    
    @objc dynamic var isSubmitted: Bool = false
    
    var score: String = "0"
    
    var note: String = ""
    
    func submitPaper() {
        var correctCount = 0
        var answerContents: [String] = []
        for m in dataArr {
            if m.answeredItem == m.correct {
                m.isCorrect = true
                correctCount += 1
            } else {
                m.isCorrect = false
            }
            answerContents.append("\(m.id)=\(m.answeredItem)")
        }
        SVPNoUserinteractShow(content: "正在提交试卷...")
        _ = VideoNetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_SUBMITSCORE, params: ["collectionId":self.collectionId,"score":self.score,"result":"\((answerContents as NSArray).componentsJoined(by: "&"))&"], success: { [weak self](msg, code, response, data) in
            if code == 0 {
                self?.isSubmitted = true
                SVPShowSuccess(content: "您的试卷已提交")
                self?.score = "\(correctCount)"
                self?.note = "共\(correctCount)题,答对\(self?.dataArr.count ?? 0)题"
            } else {
                SVPShowError(content: msg)
            }
        }, fail: { error in
            SVPShowError(content: error.message)
        })
    }
    
}
