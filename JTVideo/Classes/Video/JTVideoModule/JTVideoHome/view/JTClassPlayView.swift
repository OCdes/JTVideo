//
//  JTClassPlayView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/15.
//

import UIKit

class JTClassPlayView: UITableView {
    var viewModel: JTClassPlayViewModel = JTClassPlayViewModel()
    var dataArr: [JTVClassDetailItemModel] = [] {
        didSet {
            reloadData()
        }
    }
    
    lazy var headerV: JTVClassPlayerHeaderView = {
        let hv = JTVClassPlayerHeaderView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 125 + self.frame.width*(294/428)))
        return hv
    }()
    
    init(frame: CGRect, style: UITableView.Style, viewModel vm: JTClassPlayViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        delegate = self
        dataSource = self
        tableHeaderView = self.headerV
        self.headerV.playView.delegate = self
        register(JTVClassDetailItemCell.self, forCellReuseIdentifier: "JTVClassDetailItemCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JTClassPlayView: JTPlayerViewDelegate {
    func playerWillEnterPictureInPicture() {
        
    }
    
    func playerWillStopPictureInPicture(completionHandler: ((Bool) -> Void)?) {
        
    }
    
    func requirePopVC() {
        
    }
    
    
}

extension JTClassPlayView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "JTVClassDetailItemCell", for: indexPath) as! JTVClassDetailItemCell
        cell.titleLa.text = model.title
        cell.subTitleLa.text = "\(getDateByInterval(interval: model.createTime))|95次学习"
        if model.userPaid {
            cell.priceTypeLa.isHidden = true
            cell.playBtn.isSelected = true
        } else {
            cell.priceTypeLa.isHidden = indexPath.row != 0
            cell.playBtn.isSelected = indexPath.row == 0
        }
        return cell
    }
    
    func getDateByInterval(interval: TimeInterval)-> String {
        let dateFormatter = yyyymmddWithDotFormatter()
        let date = Date.init(timeIntervalSince1970: interval)
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 44))
        let la = UILabel(frame: CGRect(x: 23, y: 11, width: 40, height: 20))
        la.text = "目录"
        la.font = UIFont.systemFont(ofSize: 20)
        v.addSubview(la)
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        self.viewModel.generateUrlBy(id: model.id)
    }
    
}

class JTVClassPlayerHeaderView: UIView {
    
    lazy var playView: JTPlayerView = {
        let pv = JTPlayerView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width*(294/428)))
        pv.controlBar.isListMode = false
        return pv
    }()
    
    lazy var coverImgv: UIImageView = {
        let civ = UIImageView()
        civ.contentMode = .scaleAspectFill
        civ.clipsToBounds = true
        return civ
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
        stl.font = UIFont.systemFont(ofSize: 16)
        return stl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = HEX_FFF
        let f: Float = 294/428
        addSubview(coverImgv)
        coverImgv.snp_makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(self.coverImgv.snp_width).multipliedBy(f)
        }
        
        
        addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self).offset(18)
            make.right.equalTo(self).offset(-18)
            make.top.equalTo(self.coverImgv.snp_bottom).offset(38)
        }
        
        addSubview(subTitleLa)
        subTitleLa.snp_makeConstraints { make in
            make.left.right.equalTo(self.titleLa)
            make.top.equalTo(self.titleLa.snp_bottom).offset(27)
        }
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupUI() {
        
    }
}
