//
//  JTVExaminationPaperVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2024/1/2.
//

import UIKit

class JTVExaminationPaperVC: JTVideoBaseVC {
    var viewModel: JTVExaminationPaperViewModel = JTVExaminationPaperViewModel()
    
    lazy var counterHeader: JTVExaminationPaperCountHeader = {
        let ch = JTVExaminationPaperCountHeader(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 48))
        return ch
    }()
    
    lazy var paperView: JTVExaminationPaperView = {
        let pv = JTVExaminationPaperView(frame: CGRectZero, collectionViewLayout: UICollectionViewLayout(), viewModel: self.viewModel)
        return pv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(counterHeader)
        view.addSubview(paperView)
        paperView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 48, left: 0, bottom: 0, right: 0))
        }
        
        _ = paperView.jt_addRefreshHeader {
            self.viewModel.fetchExaminations(scrollView: self.paperView)
        }
        self.viewModel.fetchExaminations(scrollView: self.paperView)
        
        _ = paperView.scrollSubject.subscribe { [weak self]index in
            if let strongSelf = self {
                strongSelf.counterHeader.typeLa.text = "选择题"
                let countStr = "\(index)/\(strongSelf.viewModel.dataArr.count)"
                let attributeText = NSMutableAttributedString(string: countStr)
                attributeText.addAttributes([.font:UIFont.systemFont(ofSize: 22), .foregroundColor: HEX_333], range: (countStr as NSString).range(of: "\(index)"))
                strongSelf.counterHeader.noLa.attributedText = attributeText
            }
        }
    }
    

}
