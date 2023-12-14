//
//  JTVRecommandVideList.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/14.
//

import UIKit

class JTVRecommandVideList: UITableView {
    
    var viewModel: JTVRecommandVideoViewModel = JTVRecommandVideoViewModel()
    var dataArr: [String] = [] {
        didSet {
            reloadData()
        }
    }
    init(frame: CGRect, style: UITableView.Style, viewModel vm: JTVRecommandVideoViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        delegate = self
        dataSource = self
        register(JTVRecommandVideListCell.self, forCellReuseIdentifier: "JTVRecommandVideListCell")
        _ = viewModel.rx.observeWeakly([Any].self, "dataArr").subscribe(onNext: { [weak self]arr in
            if let dataArr = arr as? [String] {
                self?.dataArr = dataArr
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JTVRecommandVideList: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JTVRecommandVideListCell", for: indexPath) as! JTVRecommandVideListCell
        
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
}

class JTVRecommandVideListCell: UITableViewCell {
    
    lazy var imgv: UIImageView = {
        let imv = UIImageView()
        imv.layer.cornerRadius = 8
        imv.layer.masksToBounds = true
        return imv
    }()
    
    lazy var typeLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_FFF
        tl.font = UIFont.systemFont(ofSize: 13)
        tl.backgroundColor = HEX_ThemeColor
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
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
        contentView.addSubview(classInfoLa)
        classInfoLa.snp_makeConstraints { make in
            make.left.equalTo(self.imgv.snp_right).offset(12)
            make.top.equalTo(self.typeLa.snp_bottom).offset(13)
            make.right.equalTo(self.nameLa)
            make.bottom.lessThanOrEqualTo(self.followNumLa)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



