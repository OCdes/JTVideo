//
//  JTVBuyClassVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/22.
//

import UIKit

class JTVBuyClassVC: JTVideoBaseVC {
    var viewModel: JTVBuyClassViewModel = JTVBuyClassViewModel()
    
    lazy var buyView: JTVBuyClassView = {
        let bv = JTVBuyClassView(frame: CGRectZero, style: .grouped, viewModel: self.viewModel)
        return bv
    }()
    
    lazy var amoutLa: UILabel = {
        let al = UILabel()
        al.textColor = HEX_COLOR(hexStr: "#F03B1D")
        al.font = UIFont.systemFont(ofSize: 24)
        al.text = "¥\(self.viewModel.type == .course ? self.viewModel.cmodel.info.price : self.viewModel.dmodel.price)"
        return al
    }()
    
    lazy var payBtn: UIButton = {
        let pb = UIButton()
        pb.backgroundColor = HEX_ThemeColor
        pb.layer.cornerRadius = 24
        pb.layer.masksToBounds = true
        pb.addTarget(self, action: #selector(payBtnClicked), for: .touchUpInside)
        pb.setTitle("提交订单", for: .normal)
        return pb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(buyView)
        buyView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0))
        }
        
        let la = UILabel()
        la.text = "实付金额："
        la.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(la)
        la.snp_makeConstraints { make in
            make.left.equalTo(self.view).offset(24)
            make.top.equalTo(self.buyView.snp_bottom).offset(25)
            make.width.equalTo(88)
        }
        
        view.addSubview(payBtn)
        payBtn.snp_makeConstraints { make in
            make.right.equalTo(self.view).offset(-24)
            make.centerY.equalTo(la)
            make.size.equalTo(CGSize(width: 134, height: 48))
        }
        
        view.addSubview(self.amoutLa)
        self.amoutLa.snp_makeConstraints { make in
            make.left.equalTo(la.snp_right).offset(5)
            make.centerY.equalTo(la)
            make.right.equalTo(self.payBtn.snp_left).offset(-15)
        }
    }
    
    @objc func payBtnClicked() {
        self.viewModel.buyClass()
    }

}
