//
//  JTVExamanationResultVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2024/1/3.
//

import UIKit

class JTVExamanationResultVC: JTVideoBaseVC {
    var viewModel: JTVExaminationResultViewModel = JTVExaminationResultViewModel()
    lazy var answerView: JTVExaminationResultView = {
        let av = JTVExaminationResultView(frame: CGRectZero, style: .grouped, viewModel: self.viewModel)
        return av
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(answerView)
        answerView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        _ = answerView.jt_addRefreshHeader {
            self.viewModel.refreshData(scrollView: self.answerView)
        }
        
        self.viewModel.refreshData(scrollView: self.answerView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
