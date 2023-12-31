//
//  JTVExaminationPaperView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2024/1/2.
//

import UIKit
import RxSwift
class JTVExaminationPaperView: UICollectionView {
    var viewModel: JTVExaminationPaperViewModel = JTVExaminationPaperViewModel()
    var dataArr: [JTVExaminationPaperModel] = []
    var scrollSubject: PublishSubject<Any> = PublishSubject<Any>()
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, viewModel vm: JTVExaminationPaperViewModel) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        super.init(frame: frame, collectionViewLayout: flowLayout)
        viewModel = vm
        isPagingEnabled = true
        delegate = self
        dataSource = self
        scrollsToTop = false
        register(JTVExaminationPaperCell.self, forCellWithReuseIdentifier: "JTVExaminationPaperCell")
        register(JTVExaminationPaperCountHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JTVExaminationPaperCountHeader")
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

extension JTVExaminationPaperView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVExaminationPaperCell", for: indexPath) as! JTVExaminationPaperCell
        cell.model = dataArr[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth, height: self.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetIndex = Int(scrollView.contentOffset.x/kScreenWidth)
        self.scrollSubject.onNext(contentOffsetIndex+1)
    }
    
}

class JTVExaminationPaperCountHeader: UIView {
    lazy var typeLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_333
        tl.font = UIFont.systemFont(ofSize: 18)
        return tl
    }()
    
    lazy var noLa: UILabel = {
        let nl = UILabel()
        nl.textColor = HEX_999
        nl.font = UIFont.systemFont(ofSize: 18)
        nl.textAlignment = .right
        return nl
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HEX_FFF
        addSubview(typeLa)
        typeLa.snp_makeConstraints { make in
            make.left.equalTo(self).offset(27)
            make.top.bottom.equalTo(self)
            make.width.equalTo(100)
        }
        
        addSubview(noLa)
        noLa.snp_makeConstraints { make in
            make.right.equalTo(self).offset(-29)
            make.top.bottom.equalTo(self)
            make.width.equalTo(120)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

class JTVExaminationPaperCell: UICollectionViewCell {
    var model: JTVExaminationPaperModel = JTVExaminationPaperModel() {
        didSet {
            examView.model = model
        }
    }
    
    lazy var examView: JTVExaminationTableView = {
        let exv = JTVExaminationTableView(frame: self.bounds, style: .grouped)
        return exv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(examView)
        examView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class JTVEXaminationQuestionHeader: UIView {
    
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_333
        tl.font = UIFont.systemFont(ofSize: 18)
        tl.numberOfLines = 0
        return tl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HEX_VIEWBACKCOLOR
        addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self).offset(27)
            make.top.bottom.equalTo(self)
            make.right.equalTo(self).offset(-27)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class JTVExaminationTableView: UITableView {
    private var dataArr: [JTVVerbsModel] = [] {
        didSet {
            reloadData()
        }
    }
    
    var model: JTVExaminationPaperModel = JTVExaminationPaperModel() {
        didSet {
            dataArr = model.verbs
            headerView.titleLa.text = model.title
            let titleHeight = getTitleHeight(by: model.title)
            if (titleHeight+32) > 50 {
                let frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 32 + titleHeight)
                headerView.frame = frame
            }
        }
    }
    
    lazy var headerView: JTVEXaminationQuestionHeader = {
        let hv = JTVEXaminationQuestionHeader(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 50))
        return hv
    }()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        separatorStyle = .none
        tableHeaderView = headerView
        delegate = self
        dataSource = self
        register(JTVExaminationTableCell.self, forCellReuseIdentifier: "JTVExaminationTableCell")
        
    }
    
    func getTitleHeight(by string: String)->CGFloat {
        let height = (string as NSString).boundingRect(with: CGSize(width: kScreenWidth-54, height: CGFLOAT_MAX), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 18)], context: nil).size.height
        return height
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JTVExaminationTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JTVExaminationTableCell") as! JTVExaminationTableCell
        cell.model = dataArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let verbm = dataArr[indexPath.row]
        let height = (verbm.contentStr as NSString).boundingRect(with: CGSize(width: kScreenWidth-90, height: CGFLOAT_MAX), options: .usesLineFragmentOrigin, attributes: [.font : UIFont.systemFont(ofSize: 10)], context: nil).size.height
        if (height+30) > 50 {
            return height+30
        } else {
            return 50
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let m = dataArr[indexPath.row]
        m.isSelected = true
        model.isAnswered = true
        model.answeredItem = m.titleStr
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let m = dataArr[indexPath.row]
        m.isSelected = false
    }
    
}


class JTVExaminationTableCell: UITableViewCell {
    var model: JTVVerbsModel = JTVVerbsModel() {
        didSet {
            self.titleLa.text = model.titleStr
            self.contentLa.text = model.contentStr
            self.isSelected = model.isSelected
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.top.equalTo(self.contentView).offset(12)
            make.left.equalTo(self.contentView).offset(26)
            make.size.equalTo(CGSize(width: 26, height: 26))
        }
        
        contentView.addSubview(contentLa)
        contentLa.snp_makeConstraints { make in
            make.left.equalTo(self.titleLa.snp_right).offset(12)
            make.right.equalTo(self.contentView).offset(-26)
            make.top.equalTo(self.titleLa)
            make.bottom.equalTo(self.contentView).offset(-12)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.titleLa.backgroundColor = HEX_ThemeColor
            backgroundColor = HEX_COLOR(hexStr: "#9CD5EF")
        } else {
            self.titleLa.backgroundColor = HEX_COLOR(hexStr: "#CECECE")
            backgroundColor = HEX_VIEWBACKCOLOR
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: 题目标题

class JTVExaminationTitleHeader: UIView {
    
    lazy var titleLa: UILabel = {
        let nl = UILabel()
        nl.textColor = HEX_333
        nl.numberOfLines = 0
        nl.font = UIFont.systemFont(ofSize: 18)
        return nl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.top.bottom.equalTo(self)
            make.left.equalTo(self).offset(27)
            make.right.equalTo(self).offset(-27)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
