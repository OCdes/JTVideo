//
//  JTVPowerView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/22.
//

import UIKit

class JTVPowerView: UITableView {
    var viewModel: JTVPowerViewModel = JTVPowerViewModel()
    lazy var headerView: JTVPowerHeaderView = {
        let hv = JTVPowerHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 373), viewModel: self.viewModel)
        return hv
    }()
    init(frame: CGRect, style: UITableView.Style, viewModel vm: JTVPowerViewModel) {
        super.init(frame: frame, style: style)
        tableHeaderView = headerView
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


class JTVPowerHeaderView: UIView {
    
    var viewModel: JTVPowerViewModel = JTVPowerViewModel()
    
    lazy var balanceLa: UILabel = {
        let bl = UILabel()
        bl.font = UIFont.systemFont(ofSize: 30)
        return bl
    }()
    
    lazy var listView: JTVCoinCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let lv = JTVCoinCollectionView(frame: CGRect.zero, collectionViewLayout: layout, viewModel: self.viewModel)
        lv.delegate = self
        lv.dataSource = self
        return lv
    }()
    
    lazy var payBtn: UIButton = {
        let pb = UIButton()
        pb.setTitle("充值", for: .normal)
        pb.setTitleColor(HEX_FFF, for: .normal)
        pb.backgroundColor = HEX_COLOR(hexStr: "#2899F9")
        pb.layer.cornerRadius = 20
        pb.layer.masksToBounds = true
        return pb
    }()
    
    init(frame: CGRect, viewModel vm: JTVPowerViewModel) {
        super.init(frame: frame)
        viewModel = vm
        _ = viewModel.rx.observeWeakly(String.self, "resultStr").subscribe(onNext: { [weak self]s in
            if let strongSelf = self {
                strongSelf.listView.reloadData()
                strongSelf.listView.layoutIfNeeded()
                let height = strongSelf.listView.contentSize.height 
                var f = strongSelf.frame
                f.size.height = f.size.height + height
                strongSelf.frame = f
            }
        })
        
        let bgv = UIImageView()
        bgv.image = JTVideoBundleTool.getBundleImg(with: "jtvMineBg")
        addSubview(bgv)
        bgv.snp_makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(180)
        }
        
        let titleLa1 = UILabel()
        titleLa1.text = "当前余额"
        titleLa1.font = UIFont.systemFont(ofSize: 14)
        addSubview(titleLa1)
        titleLa1.snp_makeConstraints { make in
            make.left.equalTo(self).offset(24)
            make.top.equalTo(self).offset(24)
        }
        
        addSubview(self.balanceLa)
        balanceLa.snp_makeConstraints { make in
            make.left.equalTo(titleLa1)
            make.centerY.equalTo(self)
        }
        
        let titleLa2 = UILabel()
        titleLa2.text = "精特币"
        titleLa2.font = UIFont.systemFont(ofSize: 14)
        addSubview(titleLa2)
        titleLa2.snp_makeConstraints { make in
            make.left.equalTo(self.balanceLa.snp_right).offset(10)
            make.bottom.equalTo(self.balanceLa)
            make.size.equalTo(CGSize(width: 50, height: 15))
        }
        
        let bgv2 = UIView()
        bgv2.backgroundColor = HEX_FFF
        bgv2.layer.cornerRadius = 8
        bgv2.layer.masksToBounds = true
        addSubview(bgv2)
        bgv2.snp_makeConstraints { make in
            make.top.equalTo(bgv.snp_bottom).offset(-20)
            make.left.equalTo(self).offset(14)
            make.right.equalTo(self).offset(-14)
            make.height.equalTo(260)
        }
        
        let titleLa3 = UILabel()
        titleLa3.text = "充值金额"
        titleLa3.font = UIFont.systemFont(ofSize: 14)
        bgv2.addSubview(titleLa3)
        titleLa3.snp_makeConstraints { make in
            make.left.equalTo(bgv2).offset(15)
            make.top.equalTo(bgv2)
            make.right.equalTo(bgv2)
            make.height.equalTo(30)
        }
        
        addSubview(listView)
        listView.snp_makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(self).offset(34)
            make.height.equalTo(353)
        }
        
        addSubview(payBtn)
        payBtn.snp_makeConstraints { make in
            make.top.equalTo(self.listView.snp_bottom).offset(18)
            make.centerX.equalTo(self.listView)
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.width-30, height: 41))
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JTVCoinCollectionView: UICollectionView {
    var viewModel: JTVPowerViewModel = JTVPowerViewModel()
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, viewModel vm: JTVPowerViewModel) {
        super.init(frame: frame, collectionViewLayout: layout)
        viewModel = vm
        register(JTVCoinCollectionCell.self, forCellWithReuseIdentifier: "JTVCoinCollectionCell")
        register(JTVCoinCollectionTFCell.self, forCellWithReuseIdentifier: "JTVCoinCollectionTFCell")
        register(JTVCoinPayWayCell.self, forCellWithReuseIdentifier: "JTVCoinPayWayCell")
        register(JTVCoinCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JTVCoinCollectionHeaderView")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JTVPowerHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? self.viewModel.coinsArr.count : self.viewModel.paywaysArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if indexPath.item == (self.viewModel.coinsArr.count-1) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVCoinCollectionCell", for: indexPath) as! JTVCoinCollectionCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVCoinCollectionTFCell", for: indexPath) as! JTVCoinCollectionTFCell
                _ = cell.tf.rx.controlEvent(.valueChanged).subscribe { a in
                    print(a)
                }
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVCoinPayWayCell", for: indexPath) as! JTVCoinPayWayCell
            cell.titleIcon.image = JTVideoBundleTool.getBundleImg(with: self.viewModel.paywaysArr[indexPath.item])
            cell.titleLa.text = self.viewModel.paywaysArr[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JTVCoinCollectionHeaderView", for: indexPath) as! JTVCoinCollectionHeaderView
            view.titleLa.text = indexPath.section == 0 ? "充值金额" : "充值方式"
            return view
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 13, left: 20, bottom: 13, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let itemWidth = (UIScreen.main.bounds.width-30-17*2)/3
            let itemHeight = itemWidth*67/111
            return CGSize(width: itemWidth, height: itemHeight);
        } else {
            return CGSize(width: UIScreen.main.bounds.width-30, height: 60);
        }
    }
}

class JTVCoinCollectionCell: UICollectionViewCell {
    
    lazy var moneyLa: UILabel = {
        let ml = UILabel()
        ml.font = UIFont.systemFont(ofSize: 22)
        ml.textAlignment = .center
        ml.textColor = HEX_333
        return ml
    }()
    
    lazy var coinLa: UILabel = {
        let cl = UILabel()
        cl.font = UIFont.systemFont(ofSize: 16)
        cl.textColor = HEX_999
        cl.textAlignment = .center
        return cl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = HEX_COLOR(hexStr: "#2899F9")
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = HEX_ThemeColor.cgColor
        contentView.addSubview(self.moneyLa)
        self.moneyLa.snp_makeConstraints { make in
            make.left.right.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView).multipliedBy(0.55)
        }
        
        contentView.addSubview(self.coinLa)
        self.coinLa.snp_makeConstraints { make in
            make.left.right.equalTo(self.moneyLa)
            make.top.equalTo(self.moneyLa.snp_bottom).offset(10)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = HEX_ThemeColor
                moneyLa.textColor = HEX_FFF
                coinLa.textColor = HEX_FFF
            } else {
                backgroundColor = HEX_COLOR(hexStr: "#2899F9")
                moneyLa.textColor = HEX_333
                coinLa.textColor = HEX_999
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JTVCoinCollectionTFCell: UICollectionViewCell {
    
    lazy var tf: UITextField = {
        let f = UITextField()
        f.placeholder = "自定义金额"
        f.textColor = HEX_333
        f.textAlignment = .center
        f.font = UIFont.systemFont(ofSize: 18)
        return f
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = HEX_COLOR(hexStr: "#2899F9")
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = HEX_ThemeColor.cgColor
        
        contentView.addSubview(self.tf)
        self.tf.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = HEX_ThemeColor
                tf.textColor = HEX_FFF
            } else {
                backgroundColor = HEX_COLOR(hexStr: "#2899F9")
                tf.textColor = HEX_333
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JTVCoinPayWayCell: UICollectionViewCell {
    lazy var titleIcon: UIImageView = {
        let ii = UIImageView()
        ii.contentMode = .scaleAspectFill
        ii.clipsToBounds = true
        return ii
    }()
    
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_333
        tl.font = UIFont.systemFont(ofSize: 17)
        return tl
    }()
    
    lazy var seleBtn: UIButton = {
        let sb = UIButton()
        sb.setImage(JTVideoBundleTool.getBundleImg(with: "jtvnormalIcon"), for: .normal)
        sb.setImage(JTVideoBundleTool.getBundleImg(with: "jtvselectIcon"), for: .selected)
        return sb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleIcon)
        titleIcon.snp_makeConstraints { make in
            make.left.equalTo(self.contentView).offset(21)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSize(width: 29, height: 29))
        }
        
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(titleIcon.snp_right).offset(10)
            make.centerY.equalTo(titleIcon)
            make.width.equalTo(120)
        }
        
        contentView.addSubview(seleBtn)
        seleBtn.snp_makeConstraints { make in
            make.right.equalTo(self.contentView).offset(-22)
            make.centerY.equalTo(titleLa)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JTVCoinCollectionHeaderView: UICollectionReusableView {
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_333
        tl.font = UIFont.systemFont(ofSize: 18)
        return tl
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self).offset(22)
            make.top.bottom.right.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
