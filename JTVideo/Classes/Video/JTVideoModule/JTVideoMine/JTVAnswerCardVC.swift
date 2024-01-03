//
//  JTVAnswerCardVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2024/1/3.
//

import UIKit

class JTVAnswerCardVC: JTVideoBaseVC {
    var viewModel: JTVAnswerCardViewModel = JTVAnswerCardViewModel()
    lazy var answerView: JTVAnswerCardView = {
        let av = JTVAnswerCardView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout(), viewModel: self.viewModel)
        return av
    }()
    
    lazy var submitBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("交卷并查看结果", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 21)
        btn.setTitleColor(HEX_FFF, for: .normal)
        btn.setTitleColor(HEX_FFF, for: .selected)
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(submitBtnClicked), for: .touchUpInside)
        btn.backgroundColor = HEX_ThemeColor
        return btn
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.answerView)
        self.answerView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 70+kBottomSafeHeight, right: 0))
        }
        
        view.addSubview(submitBtn)
        submitBtn.snp_makeConstraints { make in
            make.top.equalTo(self.answerView.snp_bottom).offset(15)
            make.centerX.equalTo(self.answerView)
            make.size.equalTo(CGSize(width: kScreenWidth-36, height: 40))
        }
        
        _ = viewModel.rx.observeWeakly(Bool.self, "isSubmitted").subscribe(onNext: { b in
            if self.viewModel.isSubmitted {
                self.submitBtn.setTitle("确定", for: .normal)
                self.submitBtn.isSelected = self.viewModel.isSubmitted
            }
        })
    }
    
    @objc func submitBtnClicked() {
        if self.submitBtn.isSelected {
            if let vcs = self.navigationController?.viewControllers {
                for vc in vcs {
                    if vc.isKind(of: JTVPaperListVC.self) {
                        self.navigationController?.popToViewController(vc, animated: true)
                    }
                }
            }
            
        } else {
            self.viewModel.submitPaper()
        }
        
    }
    

}
