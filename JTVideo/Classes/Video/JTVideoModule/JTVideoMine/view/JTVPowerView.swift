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
        let hv = JTVPowerHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 513), viewModel: self.viewModel)
        return hv
    }()
    init(frame: CGRect, style: UITableView.Style, viewModel vm: JTVPowerViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        tableHeaderView = headerView
        backgroundColor = HEX_VIEWBACKCOLOR
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


class JTVPowerHeaderView: UIView {
    
    var viewModel: JTVPowerViewModel = JTVPowerViewModel()
    
    var layout = UICollectionViewFlowLayout()
    
    lazy var balanceLa: UILabel = {
        let bl = UILabel()
        bl.font = UIFont.systemFont(ofSize: 30)
        bl.textColor = HEX_FFF
        return bl
    }()
    
    lazy var listView: JTVCoinCollectionView = {
        let lv = JTVCoinCollectionView(frame: CGRect.zero, collectionViewLayout: layout, viewModel: self.viewModel)
        lv.layer.cornerRadius = 8
        lv.layer.masksToBounds = true
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
        let _ = viewModel.rx.observe(String.self, "resultStr").subscribe(onNext: { [weak self]s in
            if let strongSelf = self, strongSelf.viewModel.resultStr == "0" {
                strongSelf.balanceLa.text = "\(strongSelf.viewModel.model.jtcoin)"
                strongSelf.listView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3, execute: DispatchWorkItem(block: {
                    let height = strongSelf.layout.collectionViewContentSize.height
                    var f = strongSelf.frame
                    f.size.height = 513 + height
                    strongSelf.frame = f
                    if strongSelf.viewModel.amount == 0 {
                        strongSelf.collectionView(strongSelf.listView, didSelectItemAt: IndexPath(row: 0, section: 0))
                        strongSelf.listView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
                    }
                    
                }))
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
        titleLa1.textColor = HEX_FFF
        titleLa1.font = UIFont.systemFont(ofSize: 14)
        addSubview(titleLa1)
        titleLa1.snp_makeConstraints { make in
            make.left.equalTo(self).offset(24)
            make.top.equalTo(self).offset(24)
        }
        
        addSubview(self.balanceLa)
        balanceLa.snp_makeConstraints { make in
            make.left.equalTo(titleLa1)
            make.top.equalTo(titleLa1.snp_bottom).offset(31)
        }
        
        let titleLa2 = UILabel()
        titleLa2.text = "精特币"
        titleLa2.textColor = HEX_FFF
        titleLa2.font = UIFont.systemFont(ofSize: 14)
        addSubview(titleLa2)
        titleLa2.snp_makeConstraints { make in
            make.left.equalTo(self.balanceLa.snp_right).offset(10)
            make.bottom.equalTo(self.balanceLa).offset(-5)
            make.size.equalTo(CGSize(width: 50, height: 15))
        }
        
        addSubview(listView)
        listView.snp_makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(bgv.snp_bottom).offset(-20)
            make.bottom.equalTo(self).offset(-353)
        }
        
        addSubview(payBtn)
        payBtn.snp_makeConstraints { make in
            make.top.equalTo(self.listView.snp_bottom).offset(38)
            make.centerX.equalTo(self.listView)
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.width-30, height: 41))
        }
        
        _ = payBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            if let strongSelf = self {
                strongSelf.viewModel.charJTC()
            }
        })
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JTVCoinCollectionView: UICollectionView {
    var viewModel: JTVPowerViewModel = JTVPowerViewModel()
    var payways = ["ALIPAY"]//"WEIXIN",
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, viewModel vm: JTVPowerViewModel) {
        super.init(frame: frame, collectionViewLayout: layout)
        viewModel = vm
        register(JTVCoinCollectionCell.self, forCellWithReuseIdentifier: "JTVCoinCollectionCell")
        register(JTVCoinCollectionTFCell.self, forCellWithReuseIdentifier: "JTVCoinCollectionTFCell")
        register(JTVCoinPayWayCell.self, forCellWithReuseIdentifier: "JTVCoinPayWayCell")
        register(JTVCoinCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JTVCoinCollectionHeaderView")
        register(JTVCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "JTVCollectionFooterView")
    }
    
    override func reloadData() {
        super.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2, execute: DispatchWorkItem(block: {
            if self.viewModel.amount == 0 && self.bounds.height > 0 {
                self.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .top)
            } else {
                if let index = self.viewModel.model.exchange_list.firstIndex(of: self.viewModel.amount) {
                    self.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .top)
                }
                
            }
            
        }))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JTVPowerHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let txtStr = textField.text ?? ""
        let tstr = (txtStr as NSString).replacingCharacters(in: range, with: string)
        if tstr.count > 0  {
            if let numTstr = Int(tstr), numTstr > 0 {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? self.viewModel.model.exchange_list.count : self.viewModel.paywaysArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if indexPath.item < (self.viewModel.model.exchange_list.count-1) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVCoinCollectionCell", for: indexPath) as! JTVCoinCollectionCell
                let money = self.viewModel.model.exchange_list[indexPath.item]
                let coin = money*Int(self.viewModel.model.exchange_rate * 100)/100
                cell.moneyLa.text = "\(self.viewModel.model.exchange_list[indexPath.item])元"
                cell.coinLa.text = "\(coin)精特币"
                if self.viewModel.amount == 0 {
                    if indexPath.item == 0 {
                        self.viewModel.amount = self.viewModel.model.exchange_list[0]
                    }
                }
                cell.isSelected = (self.viewModel.amount == self.viewModel.model.exchange_list[indexPath.item])
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVCoinCollectionTFCell", for: indexPath) as! JTVCoinCollectionTFCell
                _ = cell.tf.rx.controlEvent(.editingChanged).subscribe { [weak self]a in
                    if let strongSelf = self, let textStr = cell.tf.text, let numtstr = Int(textStr) {
                        let index = strongSelf.viewModel.model.exchange_list.count - 1
                        strongSelf.viewModel.model.exchange_list[index] = numtstr
                        let mon = strongSelf.viewModel.model.exchange_list[indexPath.item]
                        cell.coinLa.text = "\(mon*Int(strongSelf.viewModel.model.exchange_rate*100)/100)精特币"
                        cell.moneyLa.text = "\(mon)元"
                        strongSelf.viewModel.amount = mon
                    }
                }
                cell.tf.delegate = self
                let mon = self.viewModel.model.exchange_list[indexPath.item]
                cell.coinLa.text = "\(mon*Int(self.viewModel.model.exchange_rate*100)/100)精特币"
                cell.moneyLa.text = "\(mon)元"
                cell.tf.text = mon > 0 ? "\(mon)" : ""
                cell.isSelected = self.viewModel.amount == mon
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVCoinPayWayCell", for: indexPath) as! JTVCoinPayWayCell
            cell.titleIcon.image = JTVideoBundleTool.getBundleImg(with: self.viewModel.paywaysArr[indexPath.item])
            cell.titleLa.text = self.viewModel.paywaysArr[indexPath.item]
            cell.seleBtn.isSelected = self.viewModel.payChannel == self.listView.payways[indexPath.item]
            cell.seleBtn.tag = indexPath.item
            cell.seleBtn.addTarget(self, action: #selector(selePayWayBtn(btn:)), for: .touchUpInside)
            return cell
        }
    }
    
    @objc func selePayWayBtn(btn: UIButton) {
        let payway = self.listView.payways[btn.tag]
        if payway == "WEIXIN" {
            SVPShowError(content: "暂不支持当前支付方式")
            return
        }
        self.viewModel.payChannel = payway
        self.listView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JTVCoinCollectionHeaderView", for: indexPath) as! JTVCoinCollectionHeaderView
            view.titleLa.text = indexPath.section == 0 ? "充值金额" : "充值方式"
            return view
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JTVCollectionFooterView", for: indexPath) as! JTVCollectionFooterView
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 13, left: 20, bottom: 13, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let itemWidth = (UIScreen.main.bounds.width-20-40-17*2)/3
            let itemHeight = itemWidth*67/111
            return CGSize(width: itemWidth, height: itemHeight);
        } else {
            return CGSize(width: UIScreen.main.bounds.width-30, height: 60);
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(UIScreen.main.bounds.width, 41)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeMake(UIScreen.main.bounds.width, 23)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.item < self.viewModel.model.exchange_list.count {
                self.viewModel.amount = self.viewModel.model.exchange_list[indexPath.item]
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVCoinCollectionTFCell", for: indexPath) as! JTVCoinCollectionTFCell
                if let tstr = Int(cell.tf.text ?? ""), tstr > 0 {
                    self.viewModel.amount = tstr
                }
            }
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
    
    private var isSelect: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HEX_COLOR(hexStr: "#EEF6FF")
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = HEX_ThemeColor.cgColor
        contentView.addSubview(self.moneyLa)
        self.moneyLa.snp_makeConstraints { make in
            make.left.right.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView).multipliedBy(0.75)
        }
        
        contentView.addSubview(self.coinLa)
        self.coinLa.snp_makeConstraints { make in
            make.left.right.equalTo(self.moneyLa)
            make.top.equalTo(self.moneyLa.snp_bottom)
        }
    }
    
    override var isSelected: Bool {
        set {
            self.isSelect = newValue
            if newValue {
                backgroundColor = HEX_ThemeColor
                moneyLa.textColor = HEX_FFF
                coinLa.textColor = HEX_FFF
            } else {
                backgroundColor = HEX_COLOR(hexStr: "#EEF6FF")
                moneyLa.textColor = HEX_333
                coinLa.textColor = HEX_999
            }
        }
        
        get {
            return self.isSelect
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JTVCoinCollectionTFCell: UICollectionViewCell {
    
    lazy var moneyLa: UILabel = {
        let ml = UILabel()
        ml.font = UIFont.systemFont(ofSize: 22)
        ml.textAlignment = .center
        ml.textColor = HEX_333
        ml.isHidden = true
        return ml
    }()
    
    lazy var coinLa: UILabel = {
        let cl = UILabel()
        cl.font = UIFont.systemFont(ofSize: 16)
        cl.textColor = HEX_999
        cl.textAlignment = .center
        cl.isHidden = true
        return cl
    }()
    
    lazy var tf: UITextField = {
        let f = UITextField()
        f.placeholder = "自定义金额"
        f.textColor = HEX_333
        f.textAlignment = .center
        f.font = UIFont.systemFont(ofSize: 18)
        f.isUserInteractionEnabled = false
        f.returnKeyType = .done
        return f
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = HEX_COLOR(hexStr: "#EEF6FF")
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = HEX_ThemeColor.cgColor
        
        contentView.addSubview(self.moneyLa)
        self.moneyLa.snp_makeConstraints { make in
            make.left.right.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView).multipliedBy(0.75)
        }
        
        contentView.addSubview(self.coinLa)
        self.coinLa.snp_makeConstraints { make in
            make.left.right.equalTo(self.moneyLa)
            make.top.equalTo(self.moneyLa.snp_bottom)
        }
        
        contentView.addSubview(self.tf)
        self.tf.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            tf.isUserInteractionEnabled = isSelected
            if isSelected {
                coinLa.isHidden = true
                moneyLa.isHidden = true
                tf.isHidden = false
                backgroundColor = HEX_ThemeColor
                tf.textColor = HEX_FFF
                tf.becomeFirstResponder()
            } else {
                if let tstr = tf.text, tstr.count > 0 {
                    coinLa.isHidden = false
                    moneyLa.isHidden = false
                    tf.isHidden = true
                } else {
                    coinLa.isHidden = true
                    moneyLa.isHidden = true
                    tf.isHidden = false
                }
                backgroundColor = HEX_COLOR(hexStr: "#EEF6FF")
                tf.textColor = HEX_333
                tf.resignFirstResponder()
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
        
        let bgv = UIView(frame: frame)

        addSubview(bgv)
        bgv.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        let bezierPath = UIBezierPath(roundedRect: bgv.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8, height: 8))
        let slayer = CAShapeLayer()
        slayer.frame = bgv.bounds
        slayer.path = bezierPath.cgPath
        slayer.masksToBounds  = true
        slayer.fillColor = HEX_FFF.cgColor
        bgv.layer.addSublayer(slayer)
        addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self).offset(22)
            make.top.bottom.right.equalTo(self)
        }
        
        backgroundColor = HEX_VIEWBACKCOLOR
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JTVCollectionFooterView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let v = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 10))
        addSubview(v)
        let bezierPath = UIBezierPath(roundedRect: v.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 8, height: 8))
        let slayer = CAShapeLayer()
        slayer.frame = v.bounds
        slayer.path = bezierPath.cgPath
        slayer.masksToBounds  = true
        slayer.fillColor = HEX_FFF.cgColor
        v.layer.addSublayer(slayer)
        backgroundColor = HEX_VIEWBACKCOLOR
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
