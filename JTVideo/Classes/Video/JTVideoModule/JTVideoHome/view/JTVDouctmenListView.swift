//
//  JTVDouctmenListView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/21.
//

import UIKit

class JTVDouctmenListView: UICollectionView {
    var viewModel: JTVDocumentListViewModel = JTVDocumentListViewModel()
    var dataArr: [JTVDocumentListModel] = [] {
        didSet {
            reloadData()
        }
    }
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, viewModel vm: JTVDocumentListViewModel) {
        super.init(frame: frame, collectionViewLayout: layout)
        viewModel = vm
        backgroundColor = HEX_VIEWBACKCOLOR
        delegate = self
        dataSource = self
        register(JTVDocumentListItem.self, forCellWithReuseIdentifier: "JTVDocumentListItem")
        
        _ = viewModel.rx.observeWeakly([Any].self, "dataArr").subscribe(onNext: { [weak self]arr in
            if let darr = arr as? [JTVDocumentListModel] {
                self?.dataArr = darr
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JTVDouctmenListView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataArr[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVDocumentListItem", for: indexPath) as! JTVDocumentListItem
        cell.imgv.kf.setImage(with: URL(string: model.coverImage), placeholder: jtVideoPlaceHolderImage())
        cell.titleLa.text = model.title
        let attris: [NSAttributedString.Key:Any] = [.strikethroughStyle : 1,.baselineOffset: 1]
        let attext = NSMutableAttributedString(string: "¥\(model.price)")
        attext.addAttributes(attris, range: NSRange(location: 0, length: attext.length))
        cell.priceLa.attributedText = attext
        cell.currentPriceLa.text = "¥\(model.price)"
        cell.followNumLa.text = "\(86)次学习/下载"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArr[indexPath.item]
        let vc = JTVDocumentDetailVC()
        vc.model = model
        self.viewModel.navigationVC?.pushViewController(vc, animated: true)
    }
    
}

class JTVDocumentListItem: UICollectionViewCell {
    lazy var imgv: UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFill
        imgv.clipsToBounds = true
        return imgv
    }()
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_333
        tl.font = UIFont.systemFont(ofSize: 18)
        return tl
    }()
    lazy var currentPriceLa: UILabel = {
        let cp = UILabel()
        cp.textColor = HEX_COLOR(hexStr: "#F03B1D")
        cp.font = UIFont.systemFont(ofSize: 18)
        return cp
    }()
    lazy var priceLa: UILabel = {
        let pl = UILabel()
        pl.textColor = HEX_COLOR(hexStr: "#919191")
        pl.font = UIFont.systemFont(ofSize: 16)
        return pl
    }()
    lazy var followNumLa: UILabel = {
        let fnl = UILabel()
        fnl.textColor = HEX_COLOR(hexStr: "#919191")
        fnl.font = UIFont.systemFont(ofSize: 13)
        fnl.textAlignment = .right
        return fnl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HEX_FFF
        layer.cornerRadius = 8
        layer.masksToBounds = true
        self.contentView.addSubview(self.imgv)
        let f: Float = 150/194
        contentView.addSubview(imgv)
        imgv.snp_makeConstraints { make in
            make.left.top.right.equalTo(self.contentView)
            make.height.equalTo(self.imgv.snp_width).multipliedBy(f)
        }
        
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self.contentView).offset(13)
            make.right.equalTo(self.contentView).offset(-13)
            make.top.equalTo(self.imgv.snp_bottom).offset(13)
        }
        
        contentView.addSubview(currentPriceLa)
        currentPriceLa.snp_makeConstraints { make in
            make.left.equalTo(self.titleLa)
            make.top.equalTo(self.titleLa.snp_bottom).offset(13)
            make.width.greaterThanOrEqualTo(10)
        }
        
        contentView.addSubview(priceLa)
        priceLa.snp_makeConstraints { make in
            make.left.equalTo(self.currentPriceLa.snp_right).offset(10)
            make.top.equalTo(self.currentPriceLa)
            make.right.lessThanOrEqualTo(self.titleLa)
        }
        
        contentView.addSubview(followNumLa)
        followNumLa.snp_makeConstraints { make in
            make.left.equalTo(self.currentPriceLa)
            make.right.equalTo(self.priceLa)
            make.top.equalTo(self.priceLa.snp_bottom).offset(13)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
