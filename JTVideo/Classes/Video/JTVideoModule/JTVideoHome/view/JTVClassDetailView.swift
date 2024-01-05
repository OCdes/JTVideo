//
//  JTVClassDetailView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/15.
//

import UIKit

class JTVClassDetailView: UITableView {
    var viewModel: JTVClassDetailViewModel = JTVClassDetailViewModel()
    var dataArr: [JTVClassDetailItemModel] = [] {
        didSet {
            reloadData()
        }
    }
    private var isMenu: Bool = false
    lazy var tableHeaderV: JTVClassDetailHeaderView = {
        let tv = JTVClassDetailHeaderView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 174+(self.frame.width)*308/428))
        return tv
    }()
    
    lazy var infoBtn: UIButton = {
        let infoBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 60))
        infoBtn.setAttributedTitle(NSAttributedString(string: "详情", attributes: [.foregroundColor : HEX_COLOR(hexStr: "#919191")]), for: .normal)
        infoBtn.setAttributedTitle(NSAttributedString(string: "详情", attributes: [.foregroundColor: HEX_333, .underlineStyle: 2, .underlineColor: HEX_ThemeColor, .baselineOffset: 10]), for: .selected)
        infoBtn.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        infoBtn.isSelected = true
        _ = infoBtn.rx.controlEvent(.touchUpInside).subscribe { [weak self]e in
            infoBtn.isSelected = true
            self?.menuBtn.isSelected = false
            self?.isMenu = false
            self?.separatorStyle = .none
            self?.reloadData()
        }
        return infoBtn
    }()
    
    lazy var menuBtn: UIButton = {
        let menuBtn = UIButton(frame: CGRect(x: 72, y: 0, width: 72, height: 60))
        menuBtn.setAttributedTitle(NSAttributedString(string: "目录", attributes: [.foregroundColor : HEX_COLOR(hexStr: "#919191")]), for: .normal)
        menuBtn.setAttributedTitle(NSAttributedString(string: "目录", attributes: [.foregroundColor: HEX_333, .underlineStyle: 2, .underlineColor: HEX_ThemeColor, .baselineOffset: 10]), for: .selected)
        menuBtn.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        _ = menuBtn.rx.controlEvent(.touchUpInside).subscribe { [weak self]e in
            self?.infoBtn.isSelected = false
            menuBtn.isSelected = true
            self?.isMenu = true
            self?.separatorStyle = .singleLine
            self?.reloadData()
        }
        return menuBtn
    }()
    
    lazy var btnsHeaderV: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 60))
        v.addSubview(infoBtn)
        v.addSubview(menuBtn)
        return v
    }()
    
    init(frame: CGRect, style: UITableView.Style, viewModel vm: JTVClassDetailViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        showsVerticalScrollIndicator = false
        backgroundColor = HEX_VIEWBACKCOLOR
        separatorStyle = .none
        delegate = self
        dataSource = self
        tableHeaderView = tableHeaderV
        register(JTVClassDetailItemCell.self, forCellReuseIdentifier: "JTVClassDetailItemCell")
        register(JTVClassDetailInfoCell.self, forCellReuseIdentifier: "JTVClassDetailInfoCell")
        _ = viewModel.rx.observeWeakly([Any].self, "dataArr").subscribe(onNext: { [weak self]arr in
            if let dataArr = arr as? [JTVClassDetailItemModel] {
                self?.updateHeaderView()
                self?.dataArr = dataArr
            }
        })
    }
    
    func updateHeaderView() {
        self.tableHeaderV.coverImgv.kf.setImage(with: URL(string: self.viewModel.detailModel.info.coverImage),placeholder: jtVideoPlaceHolderImage())
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 34)]
        let priceText = self.viewModel.detailModel.info.price
        let totalPriceText = "¥\(priceText)"
        let attrText =  NSMutableAttributedString(string: totalPriceText)
        attrText.addAttributes(attributes, range: NSRange(location: totalPriceText.count-priceText.count, length: priceText.count))
        self.tableHeaderV.priceLa.attributedText = attrText
        self.tableHeaderV.typeLa.text = "精品"
        self.tableHeaderV.titleLa.text  = self.viewModel.detailModel.info.name
        self.tableHeaderV.subTitleLa.text = "已经更新\(self.viewModel.detailModel.info.videoNumber)期|89人订阅"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JTVClassDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isMenu ? dataArr.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isMenu {
            let model = dataArr[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "JTVClassDetailItemCell", for: indexPath) as! JTVClassDetailItemCell
            cell.titleLa.text = model.title
            cell.subTitleLa.text = "\(getDateByInterval(interval: model.createTime))|95次学习"
            if model.userPaid {
                cell.playBtn.isEnabled = true
                cell.priceTypeLa.isHidden = true
                cell.playBtn.isUserInteractionEnabled = true
            } else {
                cell.priceTypeLa.isHidden = indexPath.row != 0
                cell.playBtn.isEnabled = indexPath.row == 0
                cell.playBtn.isUserInteractionEnabled = indexPath.row == 0
            }
            if isHiddenPrice {
                cell.priceTypeLa.isHidden = true
                cell.playBtn.isEnabled = true
                cell.playBtn.isUserInteractionEnabled = true
            }
            cell.playBtn.tag = indexPath.row
            cell.playBtn.addTarget(self, action: #selector(playBtnClicked(btn:)), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JTVClassDetailInfoCell", for: indexPath) as! JTVClassDetailInfoCell
            cell.textV.text = self.viewModel.detailModel.info.description
            return cell
        }
        
    }
    
    @objc func playBtnClicked(btn: UIButton) {
        let model = dataArr[btn.tag]
        if let vc = classPlayVC, vc.viewModel.id == model.id {
            self.viewModel.navigationVC?.pushViewController(vc, animated: true)
        } else {
            let vc = JTClassPlayVC()
            vc.viewModel.detailModel = self.viewModel.detailModel
            vc.viewModel.id = model.id
            self.viewModel.navigationVC?.pushViewController(vc, animated: true)
        }
        
    }
    
    func getDateByInterval(interval: TimeInterval)-> String {
        let dateFormatter = yyyymmddWithDotFormatter()
        let date = Date.init(timeIntervalSince1970: interval/1000)
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isMenu {
            return 102
        } else {
            return self.frame.height - (self.tableHeaderView?.frame.height ?? 0) - 60
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return btnsHeaderV
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    
    
    
    
}

class JTVClassDetailInfoCell: UITableViewCell {
    lazy var textV: UITextView = {
        let tv = UITextView()
        tv.textColor = HEX_333
        tv.isEditable = false
        tv.layer.cornerRadius = 8
        tv.layer.masksToBounds = true
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = HEX_VIEWBACKCOLOR
        contentView.addSubview(self.textV)
        self.textV.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class JTVClassDetailItemCell: UITableViewCell {
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_333
        tl.font = UIFont.systemFont(ofSize: 19)
        return tl
    }()
    
    lazy var subTitleLa: UILabel = {
        let stl = UILabel()
        stl.textColor = HEX_999
        stl.font = UIFont.systemFont(ofSize: 17)
        return stl
    }()
    
    lazy var priceTypeLa: UILabel = {
        let ptl = UILabel()
        ptl.text = "试看"
        ptl.isHidden = true
        ptl.textColor = HEX_FFF
        ptl.textAlignment = .center
        ptl.font = UIFont.systemFont(ofSize: 15)
        ptl.layer.cornerRadius = 4
        ptl.layer.masksToBounds = true
        ptl.backgroundColor = HEX_ThemeColor

        return ptl
    }()
    
    lazy var playBtn: UIButton = {
        let pb = UIButton()
        
        pb.setImage(JTVideoBundleTool.getBundleImg(with: "menuPauseIcon"), for: .selected)
        pb.setImage(JTVideoBundleTool.getBundleImg(with: "menuPlayeIcon"), for: .normal)
        pb.setImage(JTVideoBundleTool.getBundleImg(with: "jtvideLock"), for: .disabled)
        pb.isUserInteractionEnabled = false
        return pb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        backgroundColor = HEX_FFF
        
        contentView.addSubview(playBtn)
        playBtn.snp_makeConstraints { make in
            make.right.equalTo(self.contentView).offset(-29)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        
        contentView.addSubview(priceTypeLa)
        priceTypeLa.snp_makeConstraints { make in
            make.right.equalTo(self.playBtn.snp_left).offset(-8)
            make.centerY.equalTo(self.playBtn)
            make.size.equalTo(CGSize(width: 38, height: 22))
        }
        
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self.contentView).offset(23)
            make.top.equalTo(self.contentView).offset(19)
            make.right.equalTo(self.priceTypeLa.snp_left).offset(-8)
        }
        
        contentView.addSubview(subTitleLa)
        subTitleLa.snp_makeConstraints { make in
            make.bottom.equalTo(self.contentView).offset(-24)
            make.left.right.equalTo(self.titleLa)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class JTVClassDetailHeaderView: UIView {
    
    lazy var coverImgv: UIImageView = {
        let civ = UIImageView()
        civ.contentMode = .scaleAspectFill
        civ.clipsToBounds = true
        return civ
    }()
    
    lazy var priceLa: UILabel = {
        let pl = UILabel()
        pl.textColor = HEX_COLOR(hexStr: "#F03B1D")
        pl.font = UIFont.systemFont(ofSize: 18)
        pl.isHidden = isHiddenPrice
        return pl
    }()
    
    lazy var typeLa: UILabel = {
        let tl = UILabel()
        tl.layer.cornerRadius = 4
        tl.layer.masksToBounds = true
        tl.textAlignment = .center
        tl.font = UIFont.systemFont(ofSize: 17)
        tl.textColor = HEX_FFF
        tl.backgroundColor = HEX_ThemeColor
        return tl
    }()
    
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_333
        tl.font = UIFont.systemFont(ofSize: 24)
        return tl
    }()
    
    lazy var subTitleLa: UILabel = {
        let stl = UILabel()
        stl.textColor = HEX_999
        stl.font = UIFont.systemFont(ofSize: 15)
        return stl
    }()
    
    lazy var gitfBtn: UIButton = {
        let gb = UIButton()
        gb.setImage(JTVideoBundleTool.getBundleImg(with: "jtvideoGiftIcon"), for: .normal)
        gb.extraArea(area: UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10))
        return gb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = HEX_FFF
        let f: Float = 308/428
        addSubview(coverImgv)
        coverImgv.snp_makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(self.coverImgv.snp_width).multipliedBy(f)
        }
        
        addSubview(priceLa)
        priceLa.snp_makeConstraints { make in
            make.left.equalTo(self).offset(19)
            make.right.equalTo(self).offset(-19)
            make.height.equalTo(81)
            make.top.equalTo(self.coverImgv.snp_bottom)
        }
        
        addSubview(typeLa)
        typeLa.snp_makeConstraints { make in
            make.top.equalTo(self.priceLa.snp_bottom).offset(7)
            make.left.equalTo(self.priceLa)
            make.size.equalTo(CGSize(width: 38, height: 22))
        }
        
        addSubview(gitfBtn)
        gitfBtn.snp_makeConstraints { make in
            make.right.equalTo(self).offset(-39)
            make.centerY.equalTo(self.typeLa)
            make.size.equalTo(CGSize(width: 23, height: 23))
        }
        
        let la = UILabel()
        la.textColor = HEX_ThemeColor
        la.text = "送好友"
        la.font = UIFont.systemFont(ofSize: 14)
        la.textAlignment = .center
        addSubview(la)
        la.snp_makeConstraints { make in
            make.top.equalTo(self.gitfBtn.snp_bottom).offset(5)
            make.centerX.equalTo(self.gitfBtn)
        }
        
        addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self.typeLa.snp_right).offset(10)
            make.right.equalTo(la.snp_left).offset(-10)
            make.centerY.equalTo(typeLa)
        }
        
        addSubview(subTitleLa)
        subTitleLa.snp_makeConstraints { make in
            make.left.equalTo(self.typeLa)
            make.top.equalTo(self.typeLa.snp_bottom).offset(29)
            make.right.equalTo(la.snp_left)
        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
