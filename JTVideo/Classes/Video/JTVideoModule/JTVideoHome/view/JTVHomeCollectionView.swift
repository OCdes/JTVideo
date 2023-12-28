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
        showsVerticalScrollIndicator = false
        backgroundColor = HEX_VIEWBACKCOLOR
        delegate = self
        dataSource = self
        register(JTVHomeBannerItem.self, forCellWithReuseIdentifier: "JTVHomeBannerItem")
        register(JTVCategoryItem.self, forCellWithReuseIdentifier: "JTVCategoryItem")
        register(JTVRecommandVideoItem.self, forCellWithReuseIdentifier: "JTVRecommandVideoItem")
        register(JTVRecommandTeacherItem.self, forCellWithReuseIdentifier: "JTVRecommandTeacherItem")
        register(JTVHomeSectionHeaderView.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JTVHomeSectionHeaderView")
        register(JTHomeSearchBarHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JTHomeSearchBarHeaderView")
        _ = viewModel.rx.observeWeakly([Any].self, "dataArr").subscribe(onNext: { [weak self]dataArr in
            if let arr = dataArr as? [JTVHomeSectionModel] {
                self?.dataArr = arr
            }
        })
        
    }
    
    @objc func tapSearchBar() {
        
    }
    
    @objc func tapSeeMoreBtn(btn: UIButton) {
        let sectionModel = dataArr[btn.tag]
        let sectionType = sectionModel.sectionType
        if sectionType == .recommandVideoType {
            let vc = JTVRecommandVideListVC()
            self.viewModel.navigationVC?.pushViewController(vc, animated: true)
        }
        if sectionType == .recommandTeacherType {
            let vc = JTVTeachersListVC()
            self.viewModel.navigationVC?.pushViewController(vc, animated: true)
        }
        if sectionType == .documentResource {
            let vc = JTVDocumentResouceVC()
            self.viewModel.navigationVC?.pushViewController(vc, animated: true)
        }
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
        let sectionModel = dataArr[section]
        let sectionType = sectionModel.sectionType
        if sectionType == .bannerType {
            return sectionModel.imgUrls.count > 0 ? 1 : 0
        } else {
            return sectionModel.sectionItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionModel = dataArr[indexPath.section]
        let sectionType = sectionModel.sectionType
        if sectionType == .bannerType {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVHomeBannerItem", for: indexPath) as! JTVHomeBannerItem
            cell.bannerView.setData(dataArr: sectionModel.imgUrls)
            return cell
        } else if sectionType == .categoryType {
            let item = sectionModel.sectionItems[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVCategoryItem", for: indexPath) as! JTVCategoryItem
            cell.imgv.kf.setImage(with: URL(string: item.image))
            cell.titleLa.text = item.name
            return cell
        } else if sectionType == .recommandVideoType {
            let item = sectionModel.sectionItems[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVRecommandVideoItem", for: indexPath) as! JTVRecommandVideoItem
            cell.imgv.kf.setImage(with: URL(string: item.coverImage), placeholder: jtVideoPlaceHolderImage())
            cell.titleLa.text = item.name
            let attris: [NSAttributedString.Key:Any] = [.strikethroughStyle : 1,.baselineOffset: 1]
            let attext = NSMutableAttributedString(string: "¥\(item.price)")
            attext.addAttributes(attris, range: NSRange(location: 0, length: attext.length))
            cell.priceLa.attributedText = attext
            cell.currentPriceLa.text = "¥\(item.price)"
            cell.followNumLa.text = "\(86)人订阅"
            return cell
        } else if sectionType == .recommandTeacherType {
            let item = sectionModel.sectionItems[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVRecommandTeacherItem", for: indexPath) as! JTVRecommandTeacherItem
            cell.imgv.kf.setImage(with: URL(string: item.avatarUrl), placeholder: jtVideoPlaceHolderImage())
            cell.nameLa.text = item.name
            cell.typeLa.text = "优秀"
            cell.teacherInfoLa.text = "讲师简介:\(item.description)"
            cell.followNumLa.text = "\(66)人订阅"
            return cell
        } else {
            let item = sectionModel.sectionItems[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVRecommandTeacherItem", for: indexPath) as! JTVRecommandTeacherItem
            cell.imgv.kf.setImage(with: URL(string: item.avatarUrl), placeholder: jtVideoPlaceHolderImage())
            cell.nameLa.text = item.title
            cell.typeLa.text = "精品"
            cell.teacherInfoLa.text = "资料简介:\(item.content)"
            cell.followNumLa.text = "\(166)次查阅"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionModel = dataArr[section]
        let sectionType = sectionModel.sectionType
        if sectionType == .bannerType {
            return CGSize(width: UIScreen.main.bounds.width, height: 61)
        } else if sectionType == .categoryType {
            return CGSize.zero
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: 67)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionModel = dataArr[indexPath.section]
            let sectionType = sectionModel.sectionType
            if sectionType == .bannerType {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JTHomeSearchBarHeaderView", for: indexPath) as! JTHomeSearchBarHeaderView
                headerView.searchBar.addTarget(self, action: #selector(tapSearchBar), for: .touchUpInside)
                return headerView
            } else if sectionType == .categoryType {
                return UICollectionReusableView()
            } else {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JTVHomeSectionHeaderView", for: indexPath) as! JTVHomeSectionHeaderView
                headerView.seeMoreBtn.tag = indexPath.section
                headerView.seeMoreBtn.addTarget(self, action: #selector(tapSeeMoreBtn(btn:)), for: .touchUpInside)
                headerView.bigTitleLa.text = sectionModel.sectionTitle
                return headerView
            }
        } else {
            return UICollectionReusableView()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionModel = dataArr[indexPath.section]
        let sectionType = sectionModel.sectionType
        if sectionType == .bannerType {
            let width = UIScreen.main.bounds.width-28
            return CGSize(width: UIScreen.main.bounds.width, height: width*217/400)
        } else if sectionType == .categoryType {
            let width = UIScreen.main.bounds.width/5
            return CGSize(width: width, height: width)
        } else if sectionType == .recommandVideoType {
            return CGSize(width: 194, height: 255)
        } else {
            return CGSize(width: 400, height: 134)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let sectionModel = dataArr[section]
        let sectionType = sectionModel.sectionType
        if sectionType == .bannerType {
            return 0
        } else if sectionType == .categoryType {
            
            return 0
        } else if sectionType == .recommandVideoType {
            
            return 14
        } else {
            
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let sectionModel = dataArr[section]
        let sectionType = sectionModel.sectionType
        if sectionType == .bannerType {
            return 0
        } else if sectionType == .categoryType {
            return 0
        } else if sectionType == .recommandVideoType {
            
            return 13
        } else {
            
            return 13
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionModel = dataArr[section]
        let sectionType = sectionModel.sectionType
        if sectionType == .bannerType {
            return UIEdgeInsets(top: 0, left: 13, bottom: 10, right: 13)
        } else if sectionType == .categoryType {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else if sectionType == .recommandVideoType {
            return UIEdgeInsets(top: 0, left: 11, bottom: 10, right: 11)
        } else {
            return UIEdgeInsets(top: 0, left: 13, bottom: 10, right: 13)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionModel = dataArr[indexPath.section]
        let sectionType = sectionModel.sectionType
        if sectionType == .categoryType {
            let item = sectionModel.sectionItems[indexPath.item]
            if item.name == "优秀讲师" {
                let vc = JTVTeachersListVC()
                self.viewModel.navigationVC?.pushViewController(vc, animated: true)
            } else if item.name == "视频课程" {
                let vc = JTVRecommandVideListVC()
                vc.viewModel.listType = .common
                self.viewModel.navigationVC?.pushViewController(vc, animated: true)
            } else if item.name == "学习资料" {
                let vc = JTVDocumentResouceVC()
                self.viewModel.navigationVC?.pushViewController(vc, animated: true)
            }
        }
        if sectionType == .recommandVideoType {
            let sectionItemModel = sectionModel.sectionItems[indexPath.item]
            let vc = JTVClassDetailVC()
            vc.viewModel.collectionID = sectionItemModel.id
            self.viewModel.navigationVC?.pushViewController(vc, animated: true)
        }
        if sectionType == .recommandTeacherType {
            let itemModel = sectionModel.sectionItems[indexPath.item]
            let model = JTVTeacherListItemModel()
            model.name = itemModel.name
            model.description = itemModel.description
            model.id = itemModel.id
            model.avatarUrl = itemModel.avatarUrl
            model.phone = itemModel.phone
            model.agentUserid = itemModel.agentUserid
            let vc = JTVTeachInfoVC()
            vc.viewModel.model = model
            self.viewModel.navigationVC?.pushViewController(vc, animated: true)
        }
        if sectionType == .documentResource {
            let itemModel = sectionModel.sectionItems[indexPath.item]
            let vc = JTVDocumentDetailVC()
            let model = JTVDocumentListModel()
            model.content = itemModel.content
            model.coverImage = itemModel.coverImage
            model.createTime = itemModel.createTime
            model.updateTime = itemModel.updateTime
            model.price = itemModel.price
            model.content = itemModel.content
            model.title = itemModel.title
            vc.viewModel.model = model
            self.viewModel.navigationVC?.pushViewController(vc, animated: true)
        }
    }
}

class JTVHomeBannerItem: UICollectionViewCell {
    lazy var bannerView: JTVHomeBannerView = {
        let width = UIScreen.main.bounds.width-26
        let bv = JTVHomeBannerView(frame: self.bounds)
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
        let iv = UIImageView()
        return iv
    }()
    
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.adjustsFontSizeToFitWidth = true
        tl.textAlignment = .center
        return tl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HEX_VIEWBACKCOLOR
        let centerV = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        centerV.addSubview(self.imgv)
        self.imgv.snp_makeConstraints { make in
            make.size.equalTo(CGSize(width: 35, height: 35))
            make.top.centerX.equalTo(centerV)
        }
        centerV.addSubview(self.titleLa)
        self.titleLa.snp_makeConstraints { make in
            make.top.equalTo(self.imgv.snp_bottom)
            make.left.bottom.right.equalTo(centerV)
        }
        self.contentView.addSubview(centerV)
        centerV.snp_makeConstraints { make in
            make.center.equalTo(self.contentView)
            make.size.equalTo(CGSize(width: 65, height: 60))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class JTVRecommandVideoItem: UICollectionViewCell {
    lazy var imgv: UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFill
        imgv.clipsToBounds = true
        return imgv
    }()
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_333
        tl.font = UIFont.systemFont(ofSize: 18)
        return tl
    }()
    lazy var currentPriceLa: UILabel = {
        let cp = UILabel()
        cp.textColor = HEX_COLOR(hexStr: "#F03B1D")
        cp.font = UIFont.systemFont(ofSize: 18)
        return cp
    }()
    lazy var priceLa: UILabel = {
        let pl = UILabel()
        pl.textColor = HEX_COLOR(hexStr: "#919191")
        pl.font = UIFont.systemFont(ofSize: 16)
        return pl
    }()
    lazy var followNumLa: UILabel = {
        let fnl = UILabel()
        fnl.textColor = HEX_COLOR(hexStr: "#919191")
        fnl.font = UIFont.systemFont(ofSize: 13)
        return fnl
    }()
    
    lazy var typeLa: UILabel = {
        let tl = UILabel()
        tl.layer.cornerRadius = 4
        tl.layer.masksToBounds = true
        tl.textColor = HEX_FFF
        tl.font = UIFont.systemFont(ofSize: 13)
        tl.backgroundColor = HEX_999.withAlphaComponent(0.3)
        tl.textAlignment = .center
        tl.text = "专栏"
        return tl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HEX_FFF
        layer.cornerRadius = 8
        layer.masksToBounds = true
        self.contentView.addSubview(self.imgv)
        contentView.addSubview(imgv)
        imgv.snp_makeConstraints { make in
            make.left.top.right.equalTo(self.contentView)
            make.height.equalTo(146)
        }
        
        contentView.addSubview(typeLa)
        typeLa.snp_makeConstraints { make in
            make.right.equalTo(self.imgv).offset(-5)
            make.bottom.equalTo(self.imgv).offset(-12)
            make.size.equalTo(CGSize(width: 32, height: 17))
        }
        
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self.contentView).offset(13)
            make.right.equalTo(self.contentView).offset(-13)
            make.top.equalTo(self.imgv.snp_bottom).offset(13)
        }
        
        contentView.addSubview(currentPriceLa)
        currentPriceLa.snp_makeConstraints { make in
            make.left.equalTo(self.titleLa)
            make.top.equalTo(self.titleLa.snp_bottom).offset(13)
        }
        
        contentView.addSubview(priceLa)
        priceLa.snp_makeConstraints { make in
            make.left.equalTo(self.currentPriceLa.snp_right).offset(10)
            make.top.equalTo(self.currentPriceLa)
            make.right.lessThanOrEqualTo(self.titleLa)
        }
        
        contentView.addSubview(followNumLa)
        followNumLa.snp_makeConstraints { make in
            make.left.equalTo(self.currentPriceLa)
            make.right.equalTo(self.priceLa)
            make.top.equalTo(self.priceLa.snp_bottom).offset(13)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JTVRecommandTeacherItem: UICollectionViewCell {
    
    lazy var imgv: UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFill
        imv.clipsToBounds = true
        return imv
    }()
    
    lazy var typeLa: UILabel = {
        let tl = UILabel()
        tl.layer.cornerRadius = 4
        tl.layer.masksToBounds = true
        tl.textColor = HEX_FFF
        tl.font = UIFont.systemFont(ofSize: 13)
        tl.backgroundColor = HEX_ThemeColor
        tl.textAlignment = .center
        return tl
    }()
    
    lazy var nameLa: UILabel = {
        let nl = UILabel()
        nl.font = UIFont.systemFont(ofSize: 18)
        nl.textColor = HEX_333
        return nl
    }()
    
    lazy var teacherInfoLa: UILabel = {
        let ti = UILabel()
        ti.textColor = HEX_COLOR(hexStr: "#919191")
        ti.font = UIFont.systemFont(ofSize: 14)
        ti.numberOfLines = 0
        return ti
    }()
    
    lazy var followNumLa: UILabel = {
        let fn = UILabel()
        fn.textColor = HEX_COLOR(hexStr: "#919191")
        fn.textAlignment = .right
        fn.font = UIFont.systemFont(ofSize: 13)
        return fn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = HEX_FFF
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        contentView.addSubview(self.imgv)
        self.imgv.snp_makeConstraints { make in
            make.top.left.bottom.equalTo(self.contentView)
            make.width.equalTo(175)
        }
        
        contentView.addSubview(typeLa)
        typeLa.snp_makeConstraints { make in
            make.left.equalTo(self.imgv.snp_right).offset(13)
            make.top.equalTo(self.imgv).offset(13)
            make.size.equalTo(CGSize(width: 32, height: 17))
        }
        
        contentView.addSubview(self.nameLa)
        self.nameLa.snp_makeConstraints { make in
            make.left.equalTo(self.typeLa.snp_right).offset(7)
            make.centerY.equalTo(self.typeLa)
            make.right.equalTo(self.contentView).offset(-15)
        }
        
        contentView.addSubview(followNumLa)
        followNumLa.snp_makeConstraints { make in
            make.right.equalTo(self.nameLa)
            make.bottom.equalTo(self.imgv).offset(-14)
        }
        
        contentView.addSubview(teacherInfoLa)
        teacherInfoLa.snp_makeConstraints { make in
            make.left.equalTo(self.imgv.snp_right).offset(12)
            make.top.equalTo(self.typeLa.snp_bottom).offset(13)
            make.right.equalTo(self.nameLa)
            make.bottom.lessThanOrEqualTo(self.followNumLa.snp_top)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class JTHomeSearchBarHeaderView: UICollectionReusableView {
    lazy var searchBar: UIButton = {
        let sb = UIButton(frame: CGRect(x: 14, y: 12, width: UIScreen.main.bounds.width-28, height: 37))
        sb.setTitle("    搜索", for: .normal)
        sb.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        sb.setTitleColor(HEX_COLOR(hexStr: "#919191"), for: .normal)
        sb.setImage(JTVideoBundleTool.getBundleImg(with: "homeSearch"), for: .normal)
        sb.layer.cornerRadius = 18.5
        sb.layer.masksToBounds = true
        sb.backgroundColor = HEX_COLOR(hexStr: "#ECECEC")
        return sb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HEX_VIEWBACKCOLOR
        addSubview(self.searchBar)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class JTVHomeSectionHeaderView: UICollectionReusableView {
    lazy var bigTitleLa: UILabel = {
        let btl = UILabel()
        btl.textColor = HEX_COLOR(hexStr: "#262626")
        btl.font = UIFont.systemFont(ofSize: 26)
        return btl
    }()

    lazy var seeMoreBtn: UIButton = {
        let smb = UIButton()
        smb.setTitle("查看更多", for: .normal)
        smb.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        smb.setTitleColor(HEX_COLOR(hexStr: "#919191"), for: .normal)
        return smb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HEX_VIEWBACKCOLOR
        addSubview(seeMoreBtn)
        seeMoreBtn.snp_makeConstraints { make in
            make.right.equalTo(self).offset(-35)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize(width: 75, height: 20))
        }
        
        let imgv = UIImageView()
        imgv.image = JTVideoBundleTool.getBundleImg(with: "seeMore")
        addSubview(imgv)
        imgv.snp_makeConstraints { make in
            make.left.equalTo(seeMoreBtn.snp_right).offset(5)
            make.centerY.equalTo(seeMoreBtn)
            make.size.equalTo(CGSize(width: 9, height: 12))
        }
        
        addSubview(bigTitleLa)
        bigTitleLa.snp_makeConstraints { make in
            make.left.equalTo(self).offset(15)
            make.centerY.equalTo(self.seeMoreBtn)
            make.right.equalTo(self.seeMoreBtn.snp_left).offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class JTVSearchBarButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
    }
    
    private func setUpUI() {
        setTitle("    搜索", for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 20)
        setTitleColor(HEX_COLOR(hexStr: "#919191"), for: .normal)
        setImage(JTVideoBundleTool.getBundleImg(with: "homeSearch"), for: .normal)
        layer.cornerRadius = 18.5
        layer.masksToBounds = true
        backgroundColor = HEX_COLOR(hexStr: "#ECECEC")
    }
}
