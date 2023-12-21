//
//  JTVDocumentResouceVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/21.
//

import UIKit

class JTVDocumentResouceVC: JTVideoBaseVC {
    var viewModel: JTVDocumentListViewModel = JTVDocumentListViewModel()
    lazy var listView: JTVDouctmenListView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 15
        let itemWidth = (kScreenWidth-24-16)/2
        let itemHeight = itemWidth*150/194 + 108
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        let lv = JTVDouctmenListView(frame: CGRectZero, collectionViewLayout: layout, viewModel: self.viewModel)
        return lv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "学习资料"
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
        
        // Do any additional setup after loading the view.
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
