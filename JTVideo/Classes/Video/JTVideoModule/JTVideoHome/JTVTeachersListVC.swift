//
//  JTVTeachersListVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/19.
//

import UIKit

class JTVTeachersListVC: JTVideoBaseVC {
    var viewModel: JTVTeacherListViewModel = JTVTeacherListViewModel()
    lazy var listView: JTVTeacherListView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 11
        layout.minimumInteritemSpacing = 15
        let itemWidth = (UIScreen.main.bounds.width - 39)/2
        let itemHeight = (itemWidth*180/194) + 80
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        let lv = JTVTeacherListView(frame: CGRect.zero, collectionViewLayout: layout, viewModel: self.viewModel)
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return lv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "全部导师"
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
