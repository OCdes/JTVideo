//
//  JTVTeacherInfoListView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/19.
//

import UIKit

class JTVTeacherInfoListView: UICollectionView {
    var dataArr: [JTVHomeSectionItemModel] = [] {
        didSet {
            reloadData()
        }
    }
    var viewModel: JTVTeacherInfoViewModel = JTVTeacherInfoViewModel()
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, viewModel vm: JTVTeacherInfoViewModel) {
        super.init(frame: frame, collectionViewLayout: layout)
        viewModel = vm
        backgroundColor = HEX_VIEWBACKCOLOR
        delegate = self
        dataSource = self
        register(JTVRecommandVideoItem.self, forCellWithReuseIdentifier: "JTVRecommandVideoItem")
        register(JTVTeacherInfoHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JTVTeacherInfoHeaderView")
        
        _ = viewModel.rx.observeWeakly([Any].self, "dataArr").subscribe(onNext: { [weak self]arr in
            if let darr = arr as? [JTVHomeSectionItemModel] {
                self?.dataArr = darr
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension JTVTeacherInfoListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVRecommandVideoItem", for: indexPath) as! JTVRecommandVideoItem
        cell.imgv.kf.setImage(with: URL(string: item.coverImage), placeholder: jtVideoPlaceHolderImage())
        cell.titleLa.text = item.name
        let attris: [NSAttributedString.Key:Any] = [.strikethroughStyle : 1,.baselineOffset: 1]
        let attext = NSMutableAttributedString(string: "¥\(item.price)")
        attext.addAttributes(attris, range: NSRange(location: 0, length: attext.length))
        cell.priceLa.attributedText = attext
        cell.currentPriceLa.text = "¥\(item.price)"
        cell.followNumLa.text = "\(86)人订阅"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JTVTeacherInfoHeaderView", for: indexPath) as! JTVTeacherInfoHeaderView
            v.imgv.kf.setImage(with: URL(string: self.viewModel.model.avatarUrl), placeholder: jtVideoPlaceHolderImage())
            v.nameLa.text = self.viewModel.model.name
            v.descriptionLa.text = self.viewModel.model.description
            v.moreBtn.addTarget(self, action: #selector(moreBtnClicked(btn:)), for: .touchUpInside)
            return v
        } else {
            return UICollectionReusableView()
        }
    }
    
    @objc func moreBtnClicked(btn: UIButton) {
        let vc = JTVRecommandVideListVC()
        vc.viewModel.teacherID = self.viewModel.model.id
        self.viewModel.navigationVC?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height = UIScreen.main.bounds.width*308/428 + 79 + 77
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataArr[indexPath.item]
        let vc = JTVClassDetailVC()
        vc.viewModel.collectionID = item.id
        self.viewModel.navigationVC?.pushViewController(vc, animated: true)
    }
}

class JTVTeacherInfoHeaderView: UICollectionReusableView {
    
    lazy var imgv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var nameLa: UILabel = {
        let nl = UILabel()
        nl.textColor = HEX_333
        nl.font = UIFont.systemFont(ofSize: 24)
        return nl
    }()
    
    lazy var descriptionLa: UILabel = {
        let dl = UILabel()
        dl.textColor = HEX_999
        dl.font = UIFont.systemFont(ofSize: 16)
        return dl
    }()
    
    lazy var moreBtn: UIButton = {
        let mb = UIButton()
        mb.setTitle("查看更多", for: .normal)
        mb.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        mb.setTitleColor(HEX_999, for: .normal)
        return mb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HEX_VIEWBACKCOLOR
        let f: Float = 308/428
        addSubview(imgv)
        imgv.snp_makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(self.imgv.snp_width).multipliedBy(f)
        }
        
        let bgv = UIView()
        bgv.backgroundColor = HEX_FFF
        bgv.layer.cornerRadius = 8
        bgv.layer.masksToBounds = true
        addSubview(bgv)
        bgv.snp_makeConstraints { make in
            make.centerY.equalTo(self.imgv.snp_bottom)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(158)
        }
        
        bgv.addSubview(nameLa)
        nameLa.snp_makeConstraints { make in
            make.top.equalTo(bgv).offset(17)
            make.left.equalTo(bgv).offset(18)
            make.right.equalTo(bgv).offset(-18)
            make.height.equalTo(57)
        }
        
        bgv.addSubview(descriptionLa)
        descriptionLa.snp_makeConstraints { make in
            make.left.right.equalTo(self.nameLa)
            make.top.equalTo(self.nameLa.snp_bottom).offset(5)
            make.bottom.lessThanOrEqualTo(bgv)
        }
        
        let titleLa = UILabel()
        titleLa.text = "课程"
        titleLa.textColor = HEX_333
        titleLa.font = UIFont.systemFont(ofSize: 26)
        addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(bgv).offset(8)
            make.top.equalTo(bgv.snp_bottom).offset(29)
        }
        
        addSubview(moreBtn)
        moreBtn.snp_makeConstraints { make in
            make.right.equalTo(self).offset(-35)
            make.centerY.equalTo(titleLa)
            make.size.equalTo(CGSize(width: 75, height: 20))
        }
        
        let imgv = UIImageView()
        imgv.image = JTVideoBundleTool.getBundleImg(with: "seeMore")
        addSubview(imgv)
        imgv.snp_makeConstraints { make in
            make.left.equalTo(moreBtn.snp_right).offset(5)
            make.centerY.equalTo(moreBtn)
            make.size.equalTo(CGSize(width: 9, height: 12))
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
