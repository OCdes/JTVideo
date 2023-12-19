//
//  JTVTeacherListView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/19.
//

import UIKit

class JTVTeacherListView: UICollectionView {
    var dataArr: [JTVTeacherListItemModel] = [] {
        didSet {
            reloadData()
        }
    }
    var viewModel: JTVTeacherListViewModel = JTVTeacherListViewModel()
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, viewModel vm: JTVTeacherListViewModel) {
        super.init(frame: frame, collectionViewLayout: layout)
        viewModel = vm
        backgroundColor = HEX_VIEWBACKCOLOR
        register(JTVTeacherListItem.self, forCellWithReuseIdentifier: "JTVTeacherListItem")
        delegate = self
        dataSource = self
        _ = viewModel.rx.observeWeakly([Any].self, "dataArr").subscribe(onNext: { [weak self]arr in
            if let darr = arr as? [JTVTeacherListItemModel] {
                self?.dataArr = darr
            }
        })
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JTVTeacherListView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataArr[indexPath.item]
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVTeacherListItem", for: indexPath) as! JTVTeacherListItem
        item.imgv.kf.setImage(with: URL(string: model.avatarUrl), placeholder: jtVideoPlaceHolderImage())
        item.nameLa.text = model.name
        item.followLa.text = "\(168)人订阅"
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArr[indexPath.item]
        let vc = JTVTeachInfoVC()
        vc.viewModel.model = model
        self.viewModel.navigationVC?.pushViewController(vc, animated: true)
    }
    
}

class JTVTeacherListItem: UICollectionViewCell {
    
    lazy var imgv: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var nameLa: UILabel = {
        let nl = UILabel()
        return nl
    }()
    
    lazy var followLa: UILabel = {
        let fl = UILabel()
        fl.textColor = HEX_999
        fl.font = UIFont.systemFont(ofSize: 13)
        fl.textAlignment = .left
        return fl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = HEX_FFF
        layer.cornerRadius = 8
        layer.masksToBounds = true
        contentView.addSubview(imgv)
        let f: Float = 180/194
        imgv.snp_makeConstraints { make in
            make.left.right.top.equalTo(self.contentView)
            make.height.equalTo(self.imgv.snp_width).multipliedBy(f)
        }
        
        contentView.addSubview(nameLa)
        nameLa.snp_makeConstraints { make in
            make.left.equalTo(self.contentView).offset(14)
            make.top.equalTo(self.imgv.snp_bottom)
            make.right.equalTo(self.contentView).offset(-14)
            make.height.equalTo(45)
        }
        
        contentView.addSubview(followLa)
        followLa.snp_makeConstraints { make in
            make.left.right.equalTo(self.nameLa)
            make.top.equalTo(self.nameLa.snp_bottom)
            make.bottom.equalTo(self.contentView)
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
