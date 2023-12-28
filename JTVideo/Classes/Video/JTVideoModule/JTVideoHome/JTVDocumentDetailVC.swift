//
//  JTVDocumentDetailVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/21.
//

import UIKit

class JTVDocumentDetailVC: JTVideoBaseVC {
    var viewModel: JTVDocumentDetailViewModel = JTVDocumentDetailViewModel()
    lazy var detailView: JTVDocutmentDetialHeaderView = {
        let dv = JTVDocutmentDetialHeaderView(frame: self.view.bounds)
        return dv
    }()
    
    lazy var subcribeBtn: UIButton = {
        let sb = UIButton()
        sb.setTitle("订阅", for: .normal)
        sb.setTitleColor(HEX_FFF, for: .normal)
        sb.backgroundColor = HEX_ThemeColor
        sb.layer.cornerRadius = 20
        sb.layer.masksToBounds = true
        sb.addTarget(self, action: #selector(subscribeBtnClicked), for: .touchUpInside)
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.viewModel.model.title
        view.backgroundColor = HEX_VIEWBACKCOLOR
        
        view.addSubview(subcribeBtn)
        subcribeBtn.snp_makeConstraints { make in
            make.bottom.equalTo(self.view).offset(-16)
            make.centerX.equalTo(self.view)
            make.size.equalTo(CGSize(width: kScreenWidth-30, height: 40))
        }
        
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        tableView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        self.detailView.frame = tableView.frame
        tableView.tableHeaderView = self.detailView
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        
        self.detailView.totalLa.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapMore)))
        _ = viewModel.rx.observeWeakly(String.self, "suStr").subscribe(onNext: { [weak self]m in
            if let strongSelf = self {
                let model = strongSelf.viewModel.model
                let bottmMargin: CGFloat = ((Float(model.price) ?? 0) > 0 || model.userPaid == false) ? 70 : 0
                tableView.snp_remakeConstraints { make in
                    make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: bottmMargin, right: 0))
                }
                
                strongSelf.detailView.coverImgv.kf.setImage(with: URL(string: model.coverImage), placeholder: jtVideoPlaceHolderImage())
                strongSelf.detailView.titleLa.text = model.title
                let attris: [NSAttributedString.Key:Any] = [.strikethroughStyle : 1,.baselineOffset: 1]
                let attext = NSMutableAttributedString(string: "¥\(model.price)")
                attext.addAttributes(attris, range: NSRange(location: 0, length: attext.length))
                strongSelf.detailView.priceLa.attributedText = attext
                strongSelf.detailView.currentPriceLa.text = "¥\(model.price)"
                strongSelf.detailView.titleLa.text = model.title
                strongSelf.detailView.typeLa.text = "精品"
                strongSelf.detailView.subTitleLa.text = "\(strongSelf.getDateByInterval(interval: model.createTime))|\(86)次学习"
                strongSelf.detailView.totalLa.text = "共\(0)个文件"
                strongSelf.detailView.textV.text = model.content
            }
        })
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func tapMore() {
        SVPShowError(content: "暂无可下载资源")
    }
    
    func getDateByInterval(interval: TimeInterval)-> String {
        let dateFormatter = yyyymmddWithDotFormatter()
        let date = Date.init(timeIntervalSince1970: interval/1000)
        return dateFormatter.string(from: date)
    }
    
    @objc func subscribeBtnClicked() {
        let vc = JTVBuyClassVC()
        vc.viewModel.dmodel = self.viewModel.model
        self.navigationController?.pushViewController(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
