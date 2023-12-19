//
//  JTVTeachInfoVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/19.
//

import UIKit

class JTVTeachInfoVC: JTVideoBaseVC {
    var viewModel: JTVTeacherInfoViewModel = JTVTeacherInfoViewModel()
    lazy var listView: JTVTeacherInfoListView = {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width-28-4)/2
        layout.itemSize = CGSize(width: width, height: width*145/204 + 108)
        layout.minimumLineSpacing = 13
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 14, bottom: 20, right: 14)
        let lv = JTVTeacherInfoListView(frame: CGRect.zero, collectionViewLayout: layout, viewModel: self.viewModel)
        return lv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.navigationVC = self.navigationController
        view.addSubview(listView)
        listView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        _ = listView.jt_addRefreshHeader {
            self.viewModel.pageNum = 1
            self.viewModel.refreshData(scrollView: self.listView)
        }
        
        _ = listView.jt_addRefreshFooter {
            self.viewModel.pageNum += 1
            self.viewModel.refreshData(scrollView: self.listView)
        }
        
        listView.jt_startRefresh()
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
