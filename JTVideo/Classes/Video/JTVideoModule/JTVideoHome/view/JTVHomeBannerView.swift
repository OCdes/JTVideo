//
//  JTVHomeBannerView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/13.
//

import UIKit
import ZCycleView

@objc protocol JTVBannerViewProtocol: NSObjectProtocol {
    func bannerViewDidSelectect(atIndex: Int)
}

class JTVHomeBannerView: UIView {

    lazy var bannerView: ZCycleView = {
        let bv = ZCycleView(frame: self.bounds)
        bv.placeholderImage = JTVideoBundleTool.getBundleImg(with: "JTVideoPlaceHolder")
        bv.itemSize = CGSize(width: UIScreen.main.bounds.width-36, height: 270)
        bv.delegate = self
        return bv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bannerView)
        bannerView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18))
        }
    }
    
    func setData(dataArr: [String]) {
        bannerView.reloadItemsCount(dataArr.count)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JTBannerCell: UICollectionViewCell {
    
    lazy var coverImgv: UIImageView = {
        let civ = UIImageView()
        civ.contentMode = .scaleAspectFill
        return civ
    }()
    
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_FFF
        tl.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        tl.isHidden = true
        return tl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        self.contentView.addSubview(self.coverImgv)
        self.coverImgv.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        self.contentView.addSubview(self.titleLa)
        self.titleLa.snp_makeConstraints { make in
            make.left.right.bottom.equalTo(self.contentView)
            make.height.equalTo(40)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JTVHomeBannerView: ZCycleViewProtocol {
    func cycleViewRegisterCellClasses() -> [String : AnyClass] {
        return ["JTBannerCell":JTBannerCell.self]
    }
    
    func cycleViewConfigureCell(collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, realIndex: Int) -> UICollectionViewCell {
        let cc = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVHomeBannerCell", for: indexPath) as! JTBannerCell
        return cc
    }
    
    func cycleViewDidSelectedIndex(_ cycleView: ZCycleView, index: Int) {
        
    }
    
    
}
