//
//  JTVideoHomeVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/10/31.
//

import UIKit
import AliyunPlayer
open class JTVideoHomeVC: UIViewController {
    var viewModel = VideoHomeViewModel()
    lazy var listView: JTVideoHomeListView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: kScreenWidth, height: 120)
        let lv = JTVideoHomeListView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), collectionViewLayout: flowLayout, viewModel: self.viewModel)
        return lv
    }()
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initView()
        bindViewModel()
    }
    
    func initView() {
        view.backgroundColor = kIsFlagShip ? HEX_VIEWBACKCOLOR : HEX_COLOR(hexStr: "#EBEBEB");
        view.addSubview(self.listView)
    }
    
    func bindViewModel() {
        self.viewModel.refreshData(scrollView: self.listView)
        _ = self.listView.tapSubject.subscribe(onNext: { [weak self]model in
            if let pv = playerVC, pv.url == "http://player.alicdn.com/video/aliyunmedia.mp4" {
                self?.navigationController?.pushViewController(pv, animated: true)
            } else {
                if model is ViewHomeListModel {
                    let vc = JTVideoDetailVC()
                    vc.url = "http://player.alicdn.com/video/aliyunmedia.mp4"
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        })
    }
    
}
