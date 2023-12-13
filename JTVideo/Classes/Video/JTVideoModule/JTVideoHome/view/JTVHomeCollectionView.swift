//
//  JTVHomeCollectionView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/13.
//

import UIKit

class JTVHomeCollectionView: UICollectionView {
    var viewModel: JTVHomeViewModel = JTVHomeViewModel()
    var dataArr: [JTVHomeSectionModel] = [] {
        didSet {
            self.reloadData()
        }
    }
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, viewModel vm: JTVHomeViewModel) {
        super.init(frame: frame, collectionViewLayout: layout)
        viewModel = vm
        delegate = self
        dataSource = self
        register(JTVHomeBannerItem.self, forCellWithReuseIdentifier: "JTVHomeBannerItem")
        register(JTVCategoryItem.self, forCellWithReuseIdentifier: "JTVCategoryItem")
        register(JTVRecommandVideoItem.self, forCellWithReuseIdentifier: "JTVRecommandVideoItem")
        register(JTVRecommandTeacherItem.self, forCellWithReuseIdentifier: "JTVRecommandTeacherItem")
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
    
}

extension JTVHomeCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr[section].sectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionModel = dataArr[indexPath.section]
        let sectionType = sectionModel.sectionType
        if sectionType == .bannerType {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVHomeBannerItem", for: indexPath) as! JTVHomeBannerItem
            return cell
        } else if sectionType == .categoryType {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVCategoryItem", for: indexPath) as! JTVCategoryItem
            return cell
        } else if sectionType == .recommandVideoType {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVRecommandVideoItem", for: indexPath) as! JTVRecommandVideoItem
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVRecommandTeacherItem", for: indexPath) as! JTVRecommandTeacherItem
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 87)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JTVHomeSectionHeaderView", for: indexPath)
            return headerView
        } else {
            return UICollectionReusableView()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionModel = dataArr[indexPath.section]
        let sectionType = sectionModel.sectionType
        if sectionType == .bannerType {
            return CGSizeZero
        } else if sectionType == .categoryType {
            
            return CGSizeZero
        } else if sectionType == .recommandVideoType {
            
            return CGSizeZero
        } else {
            
            return CGSizeZero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let sectionModel = dataArr[section]
        let sectionType = sectionModel.sectionType
        if sectionType == .bannerType {
            return 10
        } else if sectionType == .categoryType {
            
            return 10
        } else if sectionType == .recommandVideoType {
            
            return 10
        } else {
            
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let sectionModel = dataArr[section]
        let sectionType = sectionModel.sectionType
        if sectionType == .bannerType {
            return 10
        } else if sectionType == .categoryType {
            
            return 10
        } else if sectionType == .recommandVideoType {
            
            return 10
        } else {
            
            return 10
        }
    }
}

class JTVHomeBannerItem: UICollectionViewCell {
    lazy var bannerView: JTVHomeBannerView = {
        let bv = JTVHomeBannerView(frame: CGRectZero)
        bv.backgroundColor = HEX_VIEWBACKCOLOR
        return bv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HEX_VIEWBACKCOLOR
        self.contentView.addSubview(bannerView)
        self.bannerView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class JTVCategoryItem: UICollectionViewCell {
    lazy var imgv: UIImageView = {
        let imgv = UIImageView()
        return imgv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HEX_VIEWBACKCOLOR
        self.contentView.addSubview(self.imgv)
        self.imgv.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class JTVRecommandVideoItem: UICollectionViewCell {
    lazy var imgv: UIImageView = {
        let imgv = UIImageView()
        return imgv
    }()
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_333
        tl.font = UIFont.systemFont(ofSize: 23)
        return tl
    }()
    lazy var currentPriceLa: UILabel = {
        let cp = UILabel()
        cp.textColor = HEX_COLOR(hexStr: "#F03B1D")
        cp.font = UIFont.systemFont(ofSize: 23)
        return cp
    }()
    lazy var priceLa: UILabel = {
        let pl = UILabel()
        pl.textColor = HEX_COLOR(hexStr: "#919191")
        pl.font = UIFont.systemFont(ofSize: 20)
        return pl
    }()
    lazy var followNumLa: UILabel = {
        let fnl = UILabel()
        fnl.textColor = HEX_COLOR(hexStr: "#919191")
        fnl.font = UIFont.systemFont(ofSize: 17)
        return fnl
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HEX_FFF
        layer.cornerRadius = 10
        layer.masksToBounds = true
        self.contentView.addSubview(self.imgv)
        contentView.addSubview(imgv)
        imgv.snp_makeConstraints { make in
            make.left.top.right.equalTo(self.contentView)
            make.height.equalTo(184)
        }
        
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self.contentView).offset(17)
            make.right.equalTo(self.contentView).offset(17)
            make.top.equalTo(self.imgv.snp_bottom).offset(15)
        }
        
        contentView.addSubview(currentPriceLa)
        currentPriceLa.snp_makeConstraints { make in
            make.left.equalTo(self.titleLa)
            make.top.equalTo(self.titleLa.snp_bottom).offset(15)
        }
        
        contentView.addSubview(priceLa)
        priceLa.snp_makeConstraints { make in
            make.left.equalTo(self.currentPriceLa.snp_right).offset(10)
            make.top.equalTo(self.currentPriceLa)
            make.right.equalTo(self.titleLa)
        }
        
        contentView.addSubview(followNumLa)
        followNumLa.snp_makeConstraints { make in
            make.left.equalTo(self.currentPriceLa)
            make.right.equalTo(self.priceLa)
            make.top.equalTo(self.priceLa.snp_bottom).offset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JTVRecommandTeacherItem: UICollectionViewCell {
    
    lazy var imgv: UIImageView = {
        let imv = UIImageView()
        imv.layer.cornerRadius = 10
        imv.layer.masksToBounds = true
        return imv
    }()
    
    lazy var typeLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_FFF
        tl.font = UIFont.systemFont(ofSize: 16)
        tl.backgroundColor = HEX_ThemeColor
        return tl
    }()
    
    lazy var nameLa: UILabel = {
        let nl = UILabel()
        nl.font = UIFont.systemFont(ofSize: 23)
        nl.textColor = HEX_333
        return nl
    }()
    
    lazy var teacherInfoLa: UILabel = {
        let ti = UILabel()
        ti.textColor = HEX_COLOR(hexStr: "#919191")
        ti.numberOfLines = 0
        return ti
    }()
    
    lazy var followNumLa: UILabel = {
        let fn = UILabel()
        fn.textColor = HEX_COLOR(hexStr: "#919191")
        fn.textAlignment = .right
        return fn
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = HEX_FFF
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        contentView.addSubview(self.imgv)
        self.imgv.snp_makeConstraints { make in
            make.top.left.bottom.equalTo(self.contentView)
            make.width.equalTo(220)
        }
        
        
        contentView.addSubview(typeLa)
        typeLa.snp_makeConstraints { make in
            make.left.equalTo(self.imgv.snp_right).offset(20)
            make.top.equalTo(self.imgv).offset(20)
            make.size.equalTo(CGSize(width: 32, height: 15))
        }
        
        contentView.addSubview(self.nameLa)
        self.nameLa.snp_makeConstraints { make in
            make.left.equalTo(self.typeLa.snp_right).offset(12)
            make.centerY.equalTo(self.typeLa)
            make.right.equalTo(self.contentView).offset(-15)
        }
        
        contentView.addSubview(followNumLa)
        followNumLa.snp_makeConstraints { make in
            make.right.equalTo(self.nameLa)
            make.bottom.equalTo(self.imgv).offset(-18)
        }
        
        contentView.addSubview(teacherInfoLa)
        teacherInfoLa.snp_makeConstraints { make in
            make.left.equalTo(self.imgv.snp_right).offset(15)
            make.top.equalTo(self.typeLa.snp_bottom).offset(19)
            make.right.equalTo(self.nameLa)
            make.bottom.lessThanOrEqualTo(self.followNumLa)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


class JTVHomeSectionHeaderView: UICollectionReusableView {
    lazy var bigTitleLa: UILabel = {
        let btl = UILabel()
        btl.textColor = HEX_COLOR(hexStr: "#262626")
        btl.font = UIFont.systemFont(ofSize: 33)
        return btl
    }()

    lazy var seeMoreBtn: UIButton = {
        let smb = UIButton()
        smb.setTitle("查看更多", for: .normal)
        smb.titleLabel?.font = UIFont.systemFont(ofSize: 23)
        smb.setImage(JTVideoBundleTool.getBundleImg(with: "seeMore"), for: .normal)
        return smb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HEX_VIEWBACKCOLOR
        addSubview(seeMoreBtn)
        seeMoreBtn.snp_makeConstraints { make in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 120, height: 30))
        }
        
        addSubview(bigTitleLa)
        bigTitleLa.snp_makeConstraints { make in
            make.left.equalTo(self).offset(19)
            make.centerY.equalTo(self.seeMoreBtn)
            make.right.equalTo(self.seeMoreBtn.snp_left).offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
