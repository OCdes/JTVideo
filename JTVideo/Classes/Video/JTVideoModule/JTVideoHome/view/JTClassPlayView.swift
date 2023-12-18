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
        register(JTVClassDetailItemCell.self, forCellReuseIdentifier: "JTVClassDetailItemCell")
        let _ = viewModel.rx.observeWeakly(String.self, "url").subscribe { [weak self]ustr in
            if let strongSelf = self, let url = self?.viewModel.url, (url.count != 0), let darr = self?.viewModel.detailModel.playDetails {
                strongSelf.dataArr =  darr
                strongSelf.headerV.playView.urlSource = url
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JTClassPlayView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
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
        
        if model.id == self.viewModel.id {
            self.headerV.titleLa.text = model.title
            self.headerV.subTitleLa.text = "已经更新\(self.viewModel.detailModel.info.videoNumber)期|89人订阅"
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.15, execute: DispatchWorkItem(block: {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
            }))
            
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
        let v = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 60))
        let la = UILabel(frame: CGRect(x: 23, y: 0, width: self.frame.width, height: 60))
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
        pv.controlBar.backBtn.isHidden = true
        pv.controlBar.titleLa.isHidden = true
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
        addSubview(playView)
        
        
        addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self).offset(18)
            make.right.equalTo(self).offset(-18)
            make.top.equalTo(self).offset(38+self.playView.frame.height)
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
}
