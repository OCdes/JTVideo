//
//  JTVHomeBannerView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/13.
//

import UIKit
import SDCycleScrollView

@objc protocol JTVBannerViewProtocol: NSObjectProtocol {
    func bannerViewDidSelectect(atIndex: Int)
}

class JTVHomeBannerView: UIView {
    weak var delegate: JTVBannerViewProtocol?
    var dataArr: [String] = []
    
    lazy var bannerView: SDCycleScrollView = {
        var b: SDCycleScrollView = SDCycleScrollView.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), delegate: self, placeholderImage: JTVideoBundleTool.getBundleImg(with: "JTVideoPlaceHolder"))
        b.layer.cornerRadius = 8
        b.layer.masksToBounds = true
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bannerView)
        bannerView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18))
        }
    }
    
    func setData(dataArr: [String]) {
        self.dataArr = dataArr
        bannerView.imageURLStringsGroup = dataArr
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JTVHomeBannerView: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        if let de = delegate {
            de.bannerViewDidSelectect(atIndex: index)
        }
    }
}
