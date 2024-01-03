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
    
    lazy var answerCardBtn: UIButton = {
        let acb = UIButton()
        acb.setTitle("答题卡", for: .normal)
        acb.setTitleColor(HEX_ThemeColor, for: .normal)
        acb.setImage(JTVideoBundleTool.getBundleImg(with: "jtvanswercard"), for: .normal)
        let titleSize = acb.titleLabel!.intrinsicContentSize
        let imageSize = acb.imageView!.intrinsicContentSize
        acb.titleEdgeInsets = UIEdgeInsets(top: imageSize.height/2, left: -imageSize.width, bottom: -imageSize.height/2, right: 0)
        acb.imageEdgeInsets = UIEdgeInsets(top: -titleSize.height/2, left: 0, bottom: titleSize.height/2, right: -titleSize.width)
        acb.addTarget(self, action: #selector(answerCarBtnClicked), for: .touchUpInside)
        return acb
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(counterHeader)
        view.addSubview(paperView)
        paperView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 48, left: 0, bottom: 0, right: 0))
        }
        view.addSubview(answerCardBtn)
        answerCardBtn.snp_makeConstraints { make in
            make.bottom.equalTo(self.view).offset(-100)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSize(width: 80, height: 80))
            
        }
        self.viewModel.fetchExaminations(scrollView: self.paperView)
        
        _ = paperView.scrollSubject.subscribe { [weak self]index in
            if let strongSelf = self {
                strongSelf.counterHeader.typeLa.text = "选择题"
                let countStr = "\(index.element ?? "")/\(strongSelf.viewModel.dataArr.count)"
                let attributeText = NSMutableAttributedString(string: countStr)
                attributeText.addAttributes([.font:UIFont.systemFont(ofSize: 22), .foregroundColor: HEX_333], range: (countStr as NSString).range(of: "\(index.element ?? "")"))
                strongSelf.counterHeader.noLa.attributedText = attributeText
            }
        }
        
        _ = viewModel.rx.observeWeakly([Any].self, "dataArr").subscribe(onNext: { arr in
            if let darr = arr as? [JTVExaminationPaperModel], darr.count > 0 {
                self.counterHeader.typeLa.text = "选择题"
                let countStr = "1/\(self.viewModel.dataArr.count)"
                let attributeText = NSMutableAttributedString(string: countStr)
                attributeText.addAttributes([.font:UIFont.systemFont(ofSize: 22), .foregroundColor: HEX_333], range: (countStr as NSString).range(of: "1"))
                self.counterHeader.noLa.attributedText = attributeText
            }
        })
    }
    
    @objc func answerCarBtnClicked() {
        let vc = JTVAnswerCardVC()
        vc.viewModel.collectionId = self.viewModel.collectionId
        vc.viewModel.dataArr = self.viewModel.dataArr as! [JTVExaminationPaperModel]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
