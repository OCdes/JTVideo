//
//  JTVBuyClassView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/22.
//

import UIKit

class JTVBuyClassView: UITableView {
    var viewModel: JTVBuyClassViewModel = JTVBuyClassViewModel()
    
    init(frame: CGRect, style: UITableView.Style, viewModel vm: JTVBuyClassViewModel) {
        super.init(frame: frame, style: style)
        delegate = self
        dataSource = self
        sectionHeaderHeight = 0
        register(JTVBuyClassDetailCell.self, forCellReuseIdentifier: "JTVBuyClassDetailCell")
        register(JTVBuyClassOperationCell.self, forCellReuseIdentifier: "JTVBuyClassOperationCell")
        viewModel = vm
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

extension JTVBuyClassView: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "JTVBuyClassDetailCell", for: indexPath) as! JTVBuyClassDetailCell
            if self.viewModel.type == .course {
                let model = self.viewModel.cmodel.info
                cell.imgv.kf.setImage(with: URL(string: model.coverImage), placeholder: jtVideoPlaceHolderImage())
                cell.titleLa.text = model.name
                cell.priceLa.text = "¥\(model.price)"
            } else {
                let model = self.viewModel.dmodel
                cell.imgv.kf.setImage(with: URL(string: model.coverImage), placeholder: jtVideoPlaceHolderImage())
                cell.titleLa.text = model.title
                cell.priceLa.text = "¥\(model.price)"
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "JTVBuyClassOperationCell", for: indexPath) as! JTVBuyClassOperationCell
            cell.textF.delegate = self
            cell.textF.tag = indexPath.row
            cell.titleLa.text = "留言"
            cell.textF.placeholder = "选填，建议和商家沟通后填写"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? (kScreenWidth*179/428) : 58
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textStr = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        self.viewModel.remark = textStr
        return true
    }
}

class JTVBuyClassDetailCell: UITableViewCell {
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
        tl.font = UIFont.systemFont(ofSize: 20)
        return tl
    }()
    
    lazy var priceLa: UILabel = {
        let pl = UILabel()
        pl.textColor = HEX_COLOR(hexStr: "#F03B1D")
        pl.font = UIFont.systemFont(ofSize: 24)
        pl.isHidden = isHiddenPrice
        return pl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        let f: Float = 187/142
        contentView.addSubview(imgv)
        imgv.snp_makeConstraints { make in
            make.left.equalTo(self.contentView).offset(15)
            make.top.equalTo(self.contentView).offset(22)
            make.bottom.equalTo(self.contentView).offset(-22)
            make.width.equalTo(self.imgv.snp_height).multipliedBy(f)
        }
        
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self.imgv.snp_right).offset(27)
            make.top.equalTo(self.imgv).offset(17)
            make.right.equalTo(self.contentView).offset(-15)
        }
        
        contentView.addSubview(priceLa)
        priceLa.snp_makeConstraints { make in
            make.left.right.equalTo(self.titleLa)
            make.bottom.equalTo(self.imgv).offset(-26)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JTVBuyClassOperationCell: UITableViewCell {
    
    lazy var textF: UITextField = {
        let tf = UITextField()
        tf.textColor = HEX_333
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .right
        let rightv = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 44))
        let rightBtn = UIButton(frame: rightv.frame)
        rightBtn.extraArea(area: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        rightBtn.setImage(JTVideoBundleTool.getBundleImg(with: "seeMore"), for: .normal)
        rightv.addSubview(rightBtn)
        tf.rightView = rightv
        tf.rightViewMode = .never
        return tf
    }()
    
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_333
        tl.font = UIFont.systemFont(ofSize: 18)
        return tl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self.contentView).offset(24)
            make.top.bottom.equalTo(self.contentView)
            make.width.equalTo(120)
        }
        
        contentView.addSubview(textF)
        textF.snp_makeConstraints { make in
            make.left.equalTo(self.titleLa.snp_right).offset(15)
            make.right.equalTo(self.contentView).offset(-15)
            make.top.bottom.equalTo(self.contentView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
