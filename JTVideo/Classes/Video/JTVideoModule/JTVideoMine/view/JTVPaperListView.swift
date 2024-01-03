//
//  JTVPaperListView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2024/1/2.
//

import UIKit

class JTVPaperListView: UITableView {
    var viewModel: JTVPaperListViewModel = JTVPaperListViewModel()
    var dataArr: [JTVPaperListModel] = []
    
    init(frame: CGRect, style: UITableView.Style, viewModel vm: JTVPaperListViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        separatorStyle = .none
        backgroundColor = HEX_VIEWBACKCOLOR
        delegate = self
        dataSource = self
        register(JTVPaperListCell.self, forCellReuseIdentifier: "JTVPaperListCell")
        register(JTVExaminationResultCell.self, forCellReuseIdentifier: "JTVExaminationResultCell")
        register(JTVCourseListCell.self, forCellReuseIdentifier: "JTVCourseListCell")
        _ = viewModel.rx.observeWeakly([Any].self, "dataArr").subscribe(onNext: { arr in
            if let darr = arr as? [JTVPaperListModel] {
                self.dataArr = darr
                self.reloadData()
            }
        })
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JTVPaperListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let m = dataArr[indexPath.row]
        if self.viewModel.type == .paper {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JTVPaperListCell", for: indexPath) as! JTVPaperListCell
            cell.checkBtn.tag = indexPath.row
            cell.checkBtn.addTarget(self, action: #selector(checkBtnClicked(btn:)), for: .touchUpInside)
            cell.imgv.kf.setImage(with: URL(string: m.coverImage), placeholder: jtVideoPlaceHolderImage())
            cell.titleLa.text = m.name
            cell.dateLa.text = getDateByInterval(interval: m.payTime)
            return cell
        } else if self.viewModel.type == .course {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JTVCourseListCell", for: indexPath) as! JTVCourseListCell
            cell.imgv.kf.setImage(with: URL(string: m.coverImage), placeholder: jtVideoPlaceHolderImage())
            cell.titleLa.text = m.name
            cell.dateLa.text = getDateByInterval(interval: m.payTime)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JTVExaminationResultCell", for: indexPath) as! JTVExaminationResultCell
            cell.imgv.kf.setImage(with: URL(string: m.coverImage), placeholder: jtVideoPlaceHolderImage())
            cell.titleLa.text = m.name
            cell.dateLa.text = getDateByInterval(interval: m.payTime)
            return cell
        }
        
    }
    
    @objc func checkBtnClicked(btn: UIButton) {
        let m = dataArr[btn.tag]
        let vc = JTVExaminationPaperVC()
        vc.viewModel.collectionId = m.id
        viewModel.navigationVC?.pushViewController(vc, animated: true)
    }
    
    func getDateByInterval(interval: TimeInterval)-> String {
        let dateFormatter = yyyymmddWithDotFormatter()
        let date = Date.init(timeIntervalSince1970: interval/1000)
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 129
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.type == .result {
            let m = dataArr[indexPath.row]
            let vc = JTVExamanationResultVC()
            vc.title = "答题卡"
            vc.viewModel.collectionId = m.id
            self.viewModel.navigationVC?.pushViewController(vc, animated: true)
        } else if viewModel.type == .course {
            let m = dataArr[indexPath.row]
            let vc = JTVClassDetailVC()
            vc.viewModel.collectionID = m.id
            vc.title = m.name
            viewModel.navigationVC?.pushViewController(vc, animated: true)
        }
        
        
    }
}

class JTVPaperListCell: UITableViewCell {
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
        tl.textColor = HEX_333
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    lazy var dateLa: UILabel = {
        let dl = UILabel()
        dl.textColor = HEX_999
        dl.font = UIFont.systemFont(ofSize: 14)
        return dl
    }()
    
    lazy var checkBtn: UIButton = {
        let cb = UIButton()
        cb.setTitle("查看试卷", for: .normal)
        cb.backgroundColor = HEX_ThemeColor
        cb.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cb.setTitleColor(HEX_FFF, for: .normal)
        cb.layer.cornerRadius = 16
        return cb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = HEX_VIEWBACKCOLOR
        let f: Float = 107/75
        
        let contentv = UIView()
        contentv.layer.cornerRadius = 8
        contentv.layer.masksToBounds = true
        contentv.backgroundColor = HEX_FFF
        
        contentView.addSubview(contentv)
        contentv.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 14, bottom: 5, right: 14))
        }
        
        contentv.addSubview(imgv)
        imgv.snp_makeConstraints { make in
            make.left.equalTo(contentv).offset(12)
            make.top.equalTo(contentv).offset(20)
            make.bottom.equalTo(contentv).offset(-20)
            make.width.equalTo(self.imgv.snp_height).multipliedBy(f)
        }
        
        contentv.addSubview(checkBtn)
        checkBtn.snp_makeConstraints { make in
            make.right.equalTo(contentv).offset(-11)
            make.top.equalTo(self.imgv).offset(7)
            make.size.equalTo(CGSize(width: 87, height: 32))
        }
        
        contentv.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self.imgv.snp_right).offset(16)
            make.top.equalTo(self.imgv).offset(4)
            make.right.equalTo(self.checkBtn.snp_left).offset(-20)
        }
        
        let clockV = UIImageView()
        clockV.image = JTVideoBundleTool.getBundleImg(with: "jtvclockIcon")
        contentv.addSubview(clockV)
        clockV.snp_makeConstraints { make in
            make.left.equalTo(self.imgv.snp_right).offset(15)
            make.bottom.equalTo(self.imgv).offset(-4)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        contentv.addSubview(self.dateLa)
        self.dateLa.snp_makeConstraints { make in
            make.left.equalTo(clockV.snp_right).offset(6)
            make.centerY.equalTo(clockV)
            make.right.equalTo(contentv).offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JTVCourseListCell: UITableViewCell {
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
        tl.textColor = HEX_333
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    lazy var dateLa: UILabel = {
        let dl = UILabel()
        dl.textColor = HEX_999
        dl.font = UIFont.systemFont(ofSize: 14)
        return dl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = HEX_VIEWBACKCOLOR
        let f: Float = 107/75
        
        let contentv = UIView()
        contentv.layer.cornerRadius = 8
        contentv.layer.masksToBounds = true
        contentv.backgroundColor = HEX_FFF
        
        contentView.addSubview(contentv)
        contentv.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 14, bottom: 5, right: 14))
        }
        
        contentv.addSubview(imgv)
        imgv.snp_makeConstraints { make in
            make.left.equalTo(contentv).offset(12)
            make.top.equalTo(contentv).offset(20)
            make.bottom.equalTo(contentv).offset(-20)
            make.width.equalTo(self.imgv.snp_height).multipliedBy(f)
        }
        
        contentv.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self.imgv.snp_right).offset(16)
            make.top.equalTo(self.imgv).offset(4)
            make.right.equalTo(self.contentView).offset(-20)
        }
        
        let clockV = UIImageView()
        clockV.image = JTVideoBundleTool.getBundleImg(with: "jtvclockIcon")
        contentv.addSubview(clockV)
        clockV.snp_makeConstraints { make in
            make.left.equalTo(self.imgv.snp_right).offset(15)
            make.bottom.equalTo(self.imgv).offset(-4)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        contentv.addSubview(self.dateLa)
        self.dateLa.snp_makeConstraints { make in
            make.left.equalTo(clockV.snp_right).offset(6)
            make.centerY.equalTo(clockV)
            make.right.equalTo(contentv).offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JTVExaminationResultCell: UITableViewCell {
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
        tl.textColor = HEX_333
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    lazy var dateLa: UILabel = {
        let dl = UILabel()
        dl.textColor = HEX_999
        dl.font = UIFont.systemFont(ofSize: 14)
        return dl
    }()
    
    lazy var resultLa: UILabel = {
        let rl = UILabel()
        rl.textColor = HEX_COLOR(hexStr: "#F03B1D")
        rl.font = UIFont.systemFont(ofSize: 18)
        return rl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = HEX_VIEWBACKCOLOR
        let f: Float = 107/75
        
        let contentv = UIView()
        contentv.layer.cornerRadius = 8
        contentv.layer.masksToBounds = true
        contentv.backgroundColor = HEX_FFF
        
        contentView.addSubview(contentv)
        contentv.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 14, bottom: 5, right: 14))
        }
        
        contentv.addSubview(imgv)
        imgv.snp_makeConstraints { make in
            make.left.equalTo(contentv).offset(12)
            make.top.equalTo(contentv).offset(20)
            make.bottom.equalTo(contentv).offset(-20)
            make.width.equalTo(self.imgv.snp_height).multipliedBy(f)
        }
        
        contentv.addSubview(resultLa)
        resultLa.snp_makeConstraints { make in
            make.right.equalTo(contentv).offset(-15)
            make.top.equalTo(self.imgv).offset(7)
            make.size.equalTo(CGSize(width: 60, height: 20))
        }
        
        let la = UILabel()
        la.textColor = HEX_333
        la.font = UIFont.systemFont(ofSize: 18)
        la.text = "得分:"
        la.isHidden = true
        la.adjustsFontSizeToFitWidth = true
        contentv.addSubview(la)
        la.snp_makeConstraints { make in
            make.right.equalTo(self.resultLa.snp_left)
            make.centerY.equalTo(self.resultLa)
        }
        
        contentv.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self.imgv.snp_right).offset(16)
            make.top.equalTo(self.imgv).offset(4)
            make.right.equalTo(la.snp_left).offset(-10)
        }
        
        let clockV = UIImageView()
        clockV.image = JTVideoBundleTool.getBundleImg(with: "jtvclockIcon")
        contentv.addSubview(clockV)
        clockV.snp_makeConstraints { make in
            make.left.equalTo(self.imgv.snp_right).offset(15)
            make.bottom.equalTo(self.imgv).offset(-4)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        contentv.addSubview(self.dateLa)
        self.dateLa.snp_makeConstraints { make in
            make.left.equalTo(clockV.snp_right).offset(6)
            make.centerY.equalTo(clockV)
            make.right.equalTo(contentv).offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
