//
//  JTVRecommandVideList.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/14.
//

import UIKit

class JTVRecommandVideList: UITableView {
    
    var viewModel: JTVRecommandVideoViewModel = JTVRecommandVideoViewModel()
    var dataArr: [JTRecommandVideoModel] = [] {
        didSet {
            reloadData()
        }
    }
    lazy var searchBBtn: JTVSearchBarButton = {
        let sbb = JTVSearchBarButton()
        return sbb
    }()
    init(frame: CGRect, style: UITableView.Style, viewModel vm: JTVRecommandVideoViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        backgroundColor = HEX_VIEWBACKCOLOR
        separatorStyle = .none
        delegate = self
        dataSource = self
        sectionHeaderHeight = 0
        register(JTVRecommandVideListCell.self, forCellReuseIdentifier: "JTVRecommandVideListCell")
        _ = viewModel.rx.observeWeakly([Any].self, "dataArr").subscribe(onNext: { [weak self]arr in
            if let dataArr = arr as? [JTRecommandVideoModel] {
                self?.dataArr = dataArr
            }
        })
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        headerView.addSubview(searchBBtn)
        searchBBtn.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 13, left: 0, bottom: 0, right: 0))
        }
        tableHeaderView = headerView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JTVRecommandVideList: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "JTVRecommandVideListCell", for: indexPath) as! JTVRecommandVideListCell
        cell.imgv.kf.setImage(with: URL(string: model.coverImage), placeholder: jtVideoPlaceHolderImage())
        cell.typeLa.text = "精品"
        cell.nameLa.text = model.name
        cell.classInfoLa.text = model.description
        cell.currentPriceLa.text = "¥\(model.price)"
        cell.priceLa.attributedText = NSAttributedString(string: "¥\(model.price)", attributes: [.strikethroughStyle:1])
        cell.followNumLa.text = "\(98)人订阅"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 13
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.section]
        
        let vc = JTVClassDetailVC()
        vc.viewModel.collectionID = model.id
        self.viewModel.navigationVC?.pushViewController(vc, animated: true)
    }
    
}

class JTVRecommandVideListCell: UITableViewCell {
    
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
        tl.backgroundColor = HEX_ThemeColor
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
    
    lazy var followNumLa: UILabel = {
        let fn = UILabel()
        fn.textColor = HEX_COLOR(hexStr: "#919191")
        fn.textAlignment = .right
        fn.font = UIFont.systemFont(ofSize: 13)
        return fn
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = HEX_FFF
        layer.cornerRadius = 8
        layer.masksToBounds = true
        clipsToBounds = true
        
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
        
        contentView.addSubview(currentPriceLa)
        currentPriceLa.snp_makeConstraints { make in
            make.left.equalTo(self.imgv.snp_right).offset(14)
            make.bottom.equalTo(self.followNumLa.snp_top)
        }
        
        contentView.addSubview(priceLa)
        priceLa.snp_makeConstraints { make in
            make.left.equalTo(self.currentPriceLa.snp_right).offset(10)
            make.top.equalTo(self.currentPriceLa)
            make.right.lessThanOrEqualTo(self.nameLa)
        }
        
        contentView.addSubview(classInfoLa)
        classInfoLa.snp_makeConstraints { make in
            make.left.equalTo(self.imgv.snp_right).offset(12)
            make.top.equalTo(self.typeLa.snp_bottom).offset(13)
            make.right.equalTo(self.nameLa)
            make.bottom.lessThanOrEqualTo(self.priceLa.snp_top)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



