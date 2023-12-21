//
//  JTVDocumentDetailVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/21.
//

import UIKit

class JTVDocumentDetailVC: JTVideoBaseVC {
    var model: JTVDocumentListModel = JTVDocumentListModel()
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
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.model.title
        view.backgroundColor = HEX_VIEWBACKCOLOR
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
        view.addSubview(tableView)
        tableView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0))
        }
        
        self.detailView.frame = tableView.frame
        tableView.tableHeaderView = self.detailView
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        self.detailView.totalLa.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapMore)))
        view.addSubview(subcribeBtn)
        subcribeBtn.snp_makeConstraints { make in
            make.top.equalTo(tableView.snp_bottom).offset(12)
            make.left.equalTo(self.view).offset(15)
            make.size.equalTo(CGSize(width: kScreenWidth-30, height: 40))
        }
        
        self.detailView.coverImgv.kf.setImage(with: URL(string: model.coverImage), placeholder: jtVideoPlaceHolderImage())
        self.detailView.titleLa.text = model.title
        let attris: [NSAttributedString.Key:Any] = [.strikethroughStyle : 1,.baselineOffset: 1]
        let attext = NSMutableAttributedString(string: "¥\(model.price)")
        attext.addAttributes(attris, range: NSRange(location: 0, length: attext.length))
        self.detailView.priceLa.attributedText = attext
        self.detailView.currentPriceLa.text = "¥\(model.price)"
        self.detailView.titleLa.text = model.title
        self.detailView.typeLa.text = "精品"
        self.detailView.subTitleLa.text = "\(getDateByInterval(interval: model.createTime))|\(86)次学习"
        self.detailView.totalLa.text = "共\(0)个文件"
        self.detailView.textV.text = model.content
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
