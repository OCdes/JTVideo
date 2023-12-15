//
//  JTClassHomeVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/13.
//

import UIKit

class JTClassHomeVC: JTVideoBaseVC {
    var viewModel = JTVHomeViewModel()
    lazy var collectionView: JTVHomeCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        let cv = JTVHomeCollectionView(frame: CGRect.zero, collectionViewLayout: layout, viewModel: viewModel)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.navigationVC = self.navigationController
        self.title = "精特云课堂"
        self.tabBarItem.title = "首页"
        view.backgroundColor = HEX_VIEWBACKCOLOR
        view.addSubview(collectionView)
        collectionView.snp_makeConstraints { make in
            make.top.left.bottom.right.equalTo(self.view)
        }
        // Do any additional setup after loading the view.
        _ = collectionView.jt_addRefreshHeader {
            self.viewModel.refreshHomePage(scrollView: self.collectionView)
        }
        collectionView.jt_startRefresh()
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
