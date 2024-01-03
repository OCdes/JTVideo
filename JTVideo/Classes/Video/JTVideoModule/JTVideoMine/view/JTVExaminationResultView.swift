//
//  JTVExaminationResultView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2024/1/3.
//

import UIKit

class JTVExaminationResultView: UITableView {
    var dataArr: [JTVExaminationPaperModel] = []
    var viewModel: JTVExaminationResultViewModel = JTVExaminationResultViewModel()
    
    init(frame: CGRect, style: UITableView.Style, viewModel vm: JTVExaminationResultViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        separatorStyle = .none
        delegate = self
        dataSource = self
        allowsSelection = false
        register(JTVExaminationAnswerCell.self, forCellReuseIdentifier: "JTVExaminationAnswerCell")
        _ = viewModel.rx.observeWeakly([Any].self, "dataArr").subscribe(onNext: { arr in
            if let darr = arr as? [JTVExaminationPaperModel] {
                self.dataArr = darr
                self.reloadData()
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JTVExaminationResultView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let m = dataArr[section]
        return m.verbs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let m = dataArr[indexPath.section]
        let vm = m.verbs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "JTVExaminationAnswerCell") as! JTVExaminationAnswerCell
        cell.model = vm
        if m.wrong {
            if vm.titleStr == m.answer {
                cell.isSelected = true
                cell.markLa.text = "❌"
            } else {
                if vm.titleStr == m.correct {
                    cell.isSelected = false
                    cell.markLa.text = "✅"
                } else {
                    cell.isSelected = false
                    cell.markLa.text = ""
                }
            }
        } else {
            if m.correct == vm.titleStr {
                cell.isSelected = true
                cell.markLa.text = "✅"
            } else {
                cell.isSelected = false
                cell.markLa.text = ""
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let m = dataArr[indexPath.section]
        let height = (m.verbs[indexPath.row].contentStr as NSString).boundingRect(with: CGSize(width: kScreenWidth-104, height: CGFLOAT_MAX), options: .usesLineFragmentOrigin, attributes: [.font : UIFont.systemFont(ofSize: 10)], context: nil).size.height
        if (height+30) > 50 {
            return height+30
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let m = dataArr[section]
        let height = ("\(section+1)、\(m.title)" as NSString).boundingRect(with: CGSize(width: kScreenWidth-90, height: CGFLOAT_MAX), options: .usesLineFragmentOrigin, attributes: [.font : UIFont.systemFont(ofSize: 10)], context: nil).size.height
        if (height + 30) > 50 {
            return height+30
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == (dataArr.count-1) {
            return 0.01
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let m = dataArr[section]
        let v = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 50))
        let la = UILabel()
        la.font = UIFont.systemFont(ofSize: 18)
        la.textColor = HEX_333
        la.numberOfLines = 0
        la.text = "\(section+1)、\(m.title)"
        v.addSubview(la)
        la.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 15, left: 26, bottom: 15, right: 26))
        }
        
        return v
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 1))
        v.backgroundColor = HEX_999.withAlphaComponent(0.2)
        
        return v
    }
    
    
}


class JTVExaminationAnswerCell: UITableViewCell {
    var model: JTVVerbsModel = JTVVerbsModel() {
        didSet {
            self.titleLa.text = model.titleStr
            self.contentLa.text = model.contentStr
        }
    }
    
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_333
        tl.textAlignment = .center
        tl.layer.cornerRadius = 13
        tl.layer.masksToBounds = true
        tl.backgroundColor = HEX_COLOR(hexStr: "#CECECE")
        tl.font = UIFont.systemFont(ofSize: 20)
        return tl
    }()
    
    lazy var contentLa: UILabel = {
        let cl = UILabel()
        cl.font = UIFont.systemFont(ofSize: 18)
        cl.textColor = HEX_333
        cl.numberOfLines = 0
        return cl
    }()
    
    lazy var markLa: UILabel = {
        let ml = UILabel()
        ml.font = UIFont.systemFont(ofSize: 20)
        return ml
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(markLa)
        markLa.snp_makeConstraints { make in
            make.top.right.bottom.equalTo(self.contentView)
            make.width.equalTo(40)
        }
        
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.top.equalTo(self.contentView).offset(12)
            make.left.equalTo(self.contentView).offset(26)
            make.size.equalTo(CGSize(width: 26, height: 26))
        }
        
        contentView.addSubview(contentLa)
        contentLa.snp_makeConstraints { make in
            make.left.equalTo(self.titleLa.snp_right).offset(12)
            make.right.equalTo(self.markLa.snp_left)
            make.top.equalTo(self.titleLa)
            make.bottom.equalTo(self.contentView).offset(-12)
        }
        
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.titleLa.backgroundColor = HEX_ThemeColor
                backgroundColor = HEX_COLOR(hexStr: "#9CD5EF")
            } else {
                self.titleLa.backgroundColor = HEX_COLOR(hexStr: "#CECECE")
                backgroundColor = HEX_VIEWBACKCOLOR
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
