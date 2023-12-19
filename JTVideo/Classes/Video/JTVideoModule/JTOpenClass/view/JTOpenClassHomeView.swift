//
//  JTOpenClassHomeView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/19.
//

import UIKit

class JTOpenClassHomeView: UICollectionView {
    var viewModel: JTOpenClassViewModel = JTOpenClassViewModel()
    var dataArr: [JTVHomeSectionModel] = [] {
        didSet {
            reloadData()
        }
    }
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, viewModel vm: JTOpenClassViewModel) {
        super.init(frame: frame, collectionViewLayout: layout)
        viewModel = vm
        backgroundColor = HEX_VIEWBACKCOLOR
        delegate = self
        dataSource = self
        register(JTVHomeBannerItem.self, forCellWithReuseIdentifier: "JTVHomeBannerItem")
        register(JTOpenClassItem.self, forCellWithReuseIdentifier: "JTOpenClassItem")
        register(JTVHomeSectionHeaderView.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JTVHomeSectionHeaderView")
        _ = viewModel.rx.observeWeakly([Any].self, "dataArr").subscribe(onNext: { [weak self]dataArr in
            if let arr = dataArr as? [JTVHomeSectionModel] {
                self?.dataArr = arr
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapSeeMoreBtn(btn: UIButton) {
        let sectionModel = dataArr[btn.tag]
        let sectionType = sectionModel.sectionType
        if sectionType == .recommandVideoType {
            let vc = JTVRecommandVideListVC()
            self.viewModel.navigationVC?.pushViewController(vc, animated: true)
        }
    }
    
}


extension JTOpenClassHomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionModel = dataArr[section]
        if sectionModel.sectionType == .bannerType {
            return sectionModel.imgUrls.count > 0 ? 1 : 0
        } else {
            return sectionModel.sectionItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionModel = dataArr[indexPath.section]
        if sectionModel.sectionType == .bannerType {
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVHomeBannerItem", for: indexPath) as! JTVHomeBannerItem
            item.bannerView.setData(dataArr: sectionModel.imgUrls)
            return item
        } else {
            let model = sectionModel.sectionItems[indexPath.item]
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: "JTOpenClassItem", for: indexPath) as! JTOpenClassItem
            item.imgv.kf.setImage(with: URL(string: model.coverImage), placeholder: jtVideoPlaceHolderImage())
            item.nameLa.text = model.name
            item.classInfoLa.text = model.description
            item.dateLa.text = getDateByInterval(interval: model.updateTime)
            item.hotLa.text = "143"
            item.typeLa.text = "专栏"
            return item
        }
    }
    
    func getDateByInterval(interval: TimeInterval)-> String {
        let dateFormatter = yyyymmddWithDotFormatter()
        let date = Date.init(timeIntervalSince1970: interval/1000)
        return dateFormatter.string(from: date)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionModel = dataArr[section]
        let sectionType = sectionModel.sectionType
        if sectionType == .bannerType {
            return CGSize.zero
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: 67)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionModel = dataArr[indexPath.section]
            let sectionType = sectionModel.sectionType
            if sectionType == .recommandVideoType {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JTVHomeSectionHeaderView", for: indexPath) as! JTVHomeSectionHeaderView
                headerView.seeMoreBtn.tag = indexPath.section
                headerView.seeMoreBtn.addTarget(self, action: #selector(tapSeeMoreBtn(btn:)), for: .touchUpInside)
                headerView.bigTitleLa.text = "热门推荐"
                return headerView
            } else {
                return UICollectionReusableView()
            }
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionModel = dataArr[indexPath.section]
        let sectionType = sectionModel.sectionType
        if sectionType == .recommandVideoType {
            let item = sectionModel.sectionItems[indexPath.item]
            let vc = JTVClassDetailVC()
            vc.viewModel.collectionID = item.id
            self.viewModel.navigationVC?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}


class JTOpenClassItem: UICollectionViewCell {
    
    lazy var imgv: UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        return imv
    }()
    
    lazy var typeLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_FFF
        tl.font = UIFont.systemFont(ofSize: 13)
        tl.backgroundColor = HEX_999.withAlphaComponent(0.3)
        tl.textAlignment = .center
        tl.layer.cornerRadius = 4
        tl.layer.masksToBounds = true
        return tl
    }()
    
    lazy var nameLa: UILabel = {
        let nl = UILabel()
        nl.font = UIFont.systemFont(ofSize: 18)
        nl.textColor = HEX_333
        return nl
    }()
    
    lazy var classInfoLa: UILabel = {
        let ti = UILabel()
        ti.textColor = HEX_COLOR(hexStr: "#919191")
        ti.font = UIFont.systemFont(ofSize: 14)
        ti.numberOfLines = 0
        return ti
    }()
    
    lazy var dateLa: UILabel = {
        let fn = UILabel()
        fn.textColor = HEX_COLOR(hexStr: "#919191")
        fn.font = UIFont.systemFont(ofSize: 13)
        return fn
    }()
    
    lazy var hotLa: UILabel = {
        let fn = UILabel()
        fn.textColor = HEX_COLOR(hexStr: "#919191")
        fn.font = UIFont.systemFont(ofSize: 13)
        return fn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = HEX_FFF
        layer.cornerRadius = 8
        layer.masksToBounds = true
        clipsToBounds = true
        let f: Float = 175/134
        contentView.addSubview(self.imgv)
        self.imgv.snp_makeConstraints { make in
            make.top.left.bottom.equalTo(self.contentView)
            make.width.equalTo(self.imgv.snp_height).multipliedBy(f)
        }
        
        contentView.addSubview(typeLa)
        typeLa.snp_makeConstraints { make in
            make.right.equalTo(self.imgv).offset(-5)
            make.bottom.equalTo(self.imgv).offset(-12)
            make.size.equalTo(CGSize(width: 32, height: 17))
        }
        
        contentView.addSubview(self.nameLa)
        self.nameLa.snp_makeConstraints { make in
            make.left.equalTo(self.imgv.snp_right).offset(13)
            make.top.equalTo(self.imgv).offset(13)
            make.right.equalTo(self.contentView).offset(-15)
        }
        
        let dateIcon = UIImageView()
        dateIcon.image =  JTVideoBundleTool.getBundleImg(with:"jtvclockIcon")
        contentView.addSubview(dateIcon)
        dateIcon.snp_makeConstraints { make in
            make.left.equalTo(self.nameLa)
            make.bottom.equalTo(self.contentView).offset(-12)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        contentView.addSubview(dateLa)
        dateLa.snp_makeConstraints { make in
            make.left.equalTo(dateIcon.snp_right).offset(5)
            make.centerY.equalTo(dateIcon)
            make.width.equalTo(101)
        }
        
        contentView.addSubview(hotLa)
        hotLa.snp_makeConstraints { make in
            make.right.equalTo(self.nameLa)
            make.bottom.equalTo(self.dateLa)
            make.width.lessThanOrEqualTo(self).multipliedBy(0.33)
        }
        
        let clickIcon = UIImageView()
        clickIcon.image = JTVideoBundleTool.getBundleImg(with: "jtvclickrateIcon")
        contentView.addSubview(clickIcon)
        clickIcon.snp_makeConstraints { make in
            make.right.equalTo(self.hotLa.snp_left).offset(-5)
            make.centerY.equalTo(self.hotLa)
            make.size.equalTo(CGSize(width: 13, height: 16))
        }
        
        contentView.addSubview(classInfoLa)
        classInfoLa.snp_makeConstraints { make in
            make.left.right.equalTo(self.nameLa)
            make.top.equalTo(self.nameLa.snp_bottom).offset(13)
            make.bottom.lessThanOrEqualTo(self.dateLa.snp_top).offset(-14)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
