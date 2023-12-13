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
        let cv = JTVHomeCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout(), viewModel: viewModel)
        return cv
    }()
    lazy var searchBar: UIButton = {
        let sb = UIButton(frame: CGRect(x: 17, y: 15, width: UIScreen.main.bounds.width-36, height: 47))
        sb.setTitle("搜索", for: .normal)
        sb.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        sb.setTitleColor(HEX_COLOR(hexStr: "#919191"), for: .normal)
        sb.setImage(JTVideoBundleTool.getBundleImg(with: "homeSearch"), for: .normal)
        sb.layer.cornerRadius = 23.5
        sb.layer.masksToBounds = true
        sb.backgroundColor = HEX_COLOR(hexStr: "#ECECEC")
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        collectionView.snp_makeConstraints { make in
            make.left.bottom.right.equalTo(self.view)
            make.top.equalTo(self.searchBar.snp_bottom)
        }
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
