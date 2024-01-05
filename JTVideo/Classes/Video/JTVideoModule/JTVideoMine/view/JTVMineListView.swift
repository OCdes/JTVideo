//
//  JTVMineListView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/13.
//

import UIKit

class JTVMineListView: UICollectionView {
    let courseInterSapce: CGFloat = 22
    let menuInterSpace: CGFloat = 0
    var viewModel: JTVMineViewModel = JTVMineViewModel()
    var dataArr: [JTVMineSectionModel] = [] {
        didSet {
            reloadData()
        }
    }
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, viewModel vm: JTVMineViewModel) {
        super.init(frame: frame, collectionViewLayout: layout)
        viewModel = vm
        backgroundColor = HEX_FFF
        delegate = self
        dataSource = self
        register(JTVMineHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JTVMineHeaderView")
        register(JTVMineFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "JTVMineFooterView")
        register(JTVMineClassCell.self, forCellWithReuseIdentifier: "JTVMineClassCell")
        register(JTVMineMenuCell.self, forCellWithReuseIdentifier: "JTVMineMenuCell")
        register(JTVMineProfileCell.self, forCellWithReuseIdentifier: "JTVMineProfileCell")
        _ = viewModel.rx.observeWeakly([Any].self, "dataArr").subscribe(onNext: { [weak self] arr in
            if let darr = arr as? [JTVMineSectionModel] {
                self?.dataArr = darr
            }
        })
    }
    
    @objc func chargeBtnClicked() {
        let vc = JTVPowerVC()
        self.viewModel.navigationVC?.pushViewController(vc, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JTVMineListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionModel = dataArr[section]
        switch sectionModel.sectionType {
        case .profile:
            return 1
        case .course:
            return sectionModel.sectionItems.count
        case .menu:
            return sectionModel.navTitles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionModel = dataArr[indexPath.section]
        if sectionModel.sectionType == .profile {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVMineProfileCell", for: indexPath) as! JTVMineProfileCell
            cell.coinLa.attributedText = attributeText(inStr: "¥\(self.viewModel.model.jtcoin)\n我的账户", targetStr: self.viewModel.model.jtcoin)
            cell.pointLa.attributedText = attributeText(inStr: "¥\(self.viewModel.model.point)\n我的积分", targetStr: self.viewModel.model.point)
            cell.portraitV.kf.setImage(with: URL(string: self.viewModel.model.avatarUrl), placeholder: JTVideoBundleTool.getBundleImg(with: "jtvportraitPlaceHolder"))
            cell.nameLa.text = self.viewModel.model.nickname
            cell.chargeBtn.addTarget(self, action: #selector(chargeBtnClicked), for: .touchUpInside)
            return cell
        } else if sectionModel.sectionType == .course {
            let sectionItem = sectionModel.sectionItems[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVMineClassCell", for: indexPath) as! JTVMineClassCell
            cell.imgv.kf.setImage(with: URL(string: sectionItem.coverImage), placeholder: jtVideoPlaceHolderImage())
            cell.titleLa.text = sectionItem.name
            cell.dateLa.text = getDateByInterval(interval: sectionItem.payTime)
            return cell
        } else {
            let navTitle = sectionModel.navTitles[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVMineMenuCell", for: indexPath) as! JTVMineMenuCell
            cell.title = navTitle
            return cell
        }
    }
    
    func getDateByInterval(interval: TimeInterval)-> String {
        let dateFormatter = yyyymmddWithDotFormatter()
        let date = Date.init(timeIntervalSince1970: interval/1000)
        return dateFormatter.string(from: date)
    }
    
    func attributeText(inStr: String, targetStr: String)-> NSAttributedString {
        let range = (inStr as NSString).range(of: targetStr)
        let mattrStr = NSMutableAttributedString(string: inStr)
        let attribute:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 24)]
        mattrStr.addAttributes(attribute, range: range)
        return mattrStr
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionModel = dataArr[indexPath.section]
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JTVMineHeaderView", for: indexPath) as! JTVMineHeaderView
            v.titleLa.text = sectionModel.sectionTitle
            v.moreBtn.isHidden = sectionModel.sectionType != .course
            v.moreBtn.addTarget(self, action: #selector(moreBtnClicked), for: .touchUpInside)
            return v
        } else {
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JTVMineFooterView", for: indexPath)
            return v
        }
    }
    
    @objc func moreBtnClicked() {
        let vc = JTVPaperListVC()
        vc.viewModel.type = .course
        vc.title = "我的课程"
        self.viewModel.navigationVC?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionModel = dataArr[section]
        return sectionModel.sectionType == .profile ? CGSizeZero : CGSize(width: kScreenWidth, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return section == dataArr.count-1 ? CGSizeZero : CGSize(width: kScreenWidth, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionModel = dataArr[indexPath.section]
        if sectionModel.sectionType == .course {
            let width = (kScreenWidth - 48 - 50)/3
            let height = width*89/111 + 65
            return CGSize(width: width, height: height)
        } else if sectionModel.sectionType == .profile {
            let width = kScreenWidth
            let height = (isHiddenPrice ? 0 : 182) + 126 + kNavStatusBarHeight
            return CGSizeMake(width, height)
        } else {
            let width = kScreenWidth/5
            return CGSize(width: width, height: 91)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionModel = dataArr[section]
        if sectionModel.sectionType == .course {
            return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        } else {
            return UIEdgeInsets.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionModel = dataArr[indexPath.section]
        if sectionModel.sectionType == .menu {
            let menuStr = sectionModel.navTitles[indexPath.item]
            if menuStr == "试卷" {
                let vc = JTVPaperListVC()
                vc.viewModel.type = .paper
                vc.title = "试卷"
                viewModel.navigationVC?.pushViewController(vc, animated: true)
            } else if menuStr == "成绩" {
                let vc = JTVPaperListVC()
                vc.viewModel.type = .result
                vc.title = "成绩"
                viewModel.navigationVC?.pushViewController(vc, animated: true)
            }
        } else if sectionModel.sectionType == .course {
            let item = sectionModel.sectionItems[indexPath.item]
            let vc = JTVClassDetailVC()
            vc.viewModel.collectionID = item.id
            vc.title = item.name
            viewModel.navigationVC?.pushViewController(vc, animated: true)
        }
    }
}

class JTVMineProfileCell: UICollectionViewCell {
    
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        pv.contentMode = .scaleAspectFill
        pv.clipsToBounds = true
        pv.layer.cornerRadius = 35
        pv.layer.masksToBounds = true
        pv.image = JTVideoBundleTool.getBundleImg(with: "jtvportraitPlaceHolder")
        return pv
    }()
    
    lazy var nameLa: UILabel = {
        let nl = UILabel()
        nl.textColor = HEX_FFF
        nl.font = UIFont.systemFont(ofSize: 22)
        nl.text = "佚名"
        return nl
    }()
    
    lazy var coinLa: UILabel = {
        let cl = UILabel()
        cl.textColor = HEX_333
        cl.font = UIFont.systemFont(ofSize: 18)
        cl.textAlignment = .center
        cl.numberOfLines = 2
        cl.isHidden = isHiddenPrice
        return cl
    }()
    
    lazy var pointLa: UILabel = {
        let cl = UILabel()
        cl.textColor = HEX_333
        cl.font = UIFont.systemFont(ofSize: 18)
        cl.textAlignment = .center
        cl.numberOfLines = 2
        cl.isHidden = isHiddenPrice
        return cl
    }()
    
    lazy var chargeBtn: UIButton = {
        let cb = UIButton()
        cb.backgroundColor = HEX_ThemeColor
        cb.setTitleColor(HEX_FFF, for: .normal)
        cb.setTitle("充值", for: .normal)
        cb.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cb.layer.cornerRadius = 14
        cb.layer.masksToBounds = true
        cb.isHidden = isHiddenPrice
        return cb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let bgv = UIImageView()
        bgv.image = JTVideoBundleTool.getBundleImg(with: "jtvMineBg")
        let f: CGFloat = 126 + kNavStatusBarHeight
        contentView.addSubview(bgv)
        bgv.snp_makeConstraints { make in
            make.left.right.top.equalTo(self.contentView)
            make.height.equalTo(f)
        }
        
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { make in
            make.bottom.equalTo(bgv).offset(-56)
            make.left.equalTo(bgv).offset(28)
            make.size.equalTo(CGSize(width: 70, height: 70))
        }
        
        contentView.addSubview(nameLa)
        nameLa.snp_makeConstraints { make in
            make.top.equalTo(self.portraitV).offset(2)
            make.left.equalTo(self.portraitV.snp_right).offset(27)
            make.right.equalTo(bgv).offset(-18)
        }
        
        let la = UILabel()
        la.textColor = HEX_333
        la.font = UIFont.systemFont(ofSize: 20)
        la.text = "资产管理"
        la.isHidden = isHiddenPrice
        contentView.addSubview(la)
        la.snp_makeConstraints { make in
            make.left.equalTo(self).offset(18)
            make.top.equalTo(bgv.snp_bottom).offset(24)
            make.size.equalTo(CGSize(width: 88, height: 20))
        }
        let width = frame.width/3
        contentView.addSubview(coinLa)
        coinLa.snp_makeConstraints { make in
            make.top.equalTo(la.snp_bottom).offset(30)
            make.left.equalTo(self.contentView)
            make.size.equalTo(CGSize(width: width, height: 88))
        }
        
        contentView.addSubview(pointLa)
        pointLa.snp_makeConstraints { make in
            make.left.equalTo(self.coinLa.snp_right)
            make.size.centerY.equalTo(self.coinLa)
        }
        
        contentView.addSubview(chargeBtn)
        chargeBtn.snp_makeConstraints { make in
            make.centerY.equalTo(self.pointLa)
            make.right.equalTo(self.contentView).offset(-16)
            make.size.equalTo(CGSize(width: 67, height: 28))
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class JTVMineClassCell: UICollectionViewCell {
    
    lazy var imgv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.layer.masksToBounds = true
        return iv
    }()
    
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.textAlignment = .center
        return tl
    }()
    
    lazy var dateLa: UILabel = {
        let dl = UILabel()
        dl.textColor = HEX_999
        dl.textAlignment = .center
        dl.font = UIFont.systemFont(ofSize: 14)
        return dl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let f: Float = 89/111
        contentView.addSubview(imgv)
        imgv.snp_makeConstraints { make in
            make.left.top.right.equalTo(self.contentView)
            make.height.equalTo(self.imgv.snp_width).multipliedBy(f)
        }
        
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.right.equalTo(self.contentView)
            make.top.equalTo(self.imgv.snp_bottom)
            make.height.equalTo(27)
        }
        
        contentView.addSubview(dateLa)
        dateLa.snp_makeConstraints { make in
            make.top.equalTo(self.titleLa.snp_bottom)
            make.left.height.right.equalTo(self.titleLa)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class JTVMineMenuCell: UICollectionViewCell {
    
    var title: String = "" {
        didSet {
            self.imgv.image = JTVideoBundleTool.getBundleImg(with: title)
            self.titleLa.text = title
        }
    }
    
    lazy var imgv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
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
        super.init(coder: coder)
    }
}

class JTVMineHeaderView: UICollectionReusableView {
    
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFont(ofSize: 20)
        return tl
    }()
    
    lazy var moreBtn: UIButton = {
        let mb = UIButton()
        mb.setImage(JTVideoBundleTool.getBundleImg(with: "seeMore"), for: .normal)
        return mb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self).offset(19)
            make.top.bottom.equalTo(self)
            make.width.equalTo(120)
        }
        
        addSubview(moreBtn)
        moreBtn.snp_makeConstraints { make in
            make.right.equalTo(self)
            make.top.bottom.equalTo(self)
            make.width.equalTo(60)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class JTVMineFooterView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HEX_VIEWBACKCOLOR
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
