//
//  JTVideoHomeListView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/10/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
class JTVideoHomeListView: UICollectionView {
    var tapSubject: PublishSubject<Any> = PublishSubject<Any>()
    var dataArr:[ViewHomeListModel] = []
    var vm: VideoHomeViewModel = VideoHomeViewModel()
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, viewModel: VideoHomeViewModel) {
        super.init(frame: frame, collectionViewLayout: layout)
        vm = viewModel
        backgroundColor = UIColor.clear
        dataSource = self
        delegate = self
        register(JTVideoHomeListItem.self, forCellWithReuseIdentifier: "JTVideoHomeListItem")
        _ = viewModel.rx.observe([Any].self, "dataArr").subscribe(onNext: { [weak self] arr in
            if let a = arr as? [ViewHomeListModel] {
                self?.dataArr = a
                self?.reloadData()
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JTVideoHomeListView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVideoHomeListItem", for: indexPath) as! JTVideoHomeListItem
        item.model = dataArr[indexPath.item];
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tapSubject.onNext(dataArr[indexPath.item])
    }
    
}

class JTVideoCateHeaderView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class JTVideoHomeListItem: UICollectionViewCell {
    
    lazy var playBtn: UIButton = {
        let pb = UIButton.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        pb.setImage(JTVideoBundleTool.getBundleImg(with: "JTVideoPlay"), for: .normal)
        return pb
    }()
    
    lazy var videoCoverView: UIImageView = {
        let vcv = UIImageView()
        vcv.layer.cornerRadius = 6
        vcv.contentMode = .scaleAspectFill
        vcv.clipsToBounds = true
        return vcv
    }()
    
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFont(ofSize: 16)
        tl.textColor = HEX_333
        tl.numberOfLines = 2
        return tl
    }()
    
    lazy var durationLa: UILabel = {
        let dl = UILabel()
        dl.textColor = HEX_666
        dl.font = UIFont.systemFont(ofSize: 12)
        return dl
    }()
    
    lazy var priceLa: UILabel = {
        let pl = UILabel()
        pl.font = UIFont.systemFont(ofSize: 14)
        pl.textColor = UIColor.orange
        pl.adjustsFontSizeToFitWidth = true
        return pl
    }()
    
    lazy var sawNumLa: UILabel = {
        let snl = UILabel()
        snl.font = UIFont.systemFont(ofSize: 12)
        snl.textColor = HEX_999
        return snl
    }()
    
    var model: ViewHomeListModel = ViewHomeListModel() {
        didSet {
            self.videoCoverView.kf.setImage(with: URL(string: model.CoverURL))
            self.titleLa.text = model.Title
            self.durationLa.text = "时长:\(model.Duration)"
            self.priceLa.text = "免费"
            self.sawNumLa.text = "\(12)人已观看"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        contentView.addSubview(self.videoCoverView)
        videoCoverView.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(15)
            make.top.equalTo(self.contentView).offset(10)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.width.equalTo(150)
        }
        
        videoCoverView.addSubview(playBtn)
        playBtn.snp_makeConstraints { make in
            make.center.equalTo(self.videoCoverView)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        
        contentView.addSubview(self.titleLa)
        titleLa.snp_makeConstraints { (make) in
            make.left.equalTo(self.videoCoverView.snp_right).offset(20)
            make.top.equalTo(self.videoCoverView)
            make.right.equalTo(self.contentView).offset(-30)
            make.height.lessThanOrEqualTo(40)
        }
        
        contentView.addSubview(self.durationLa)
        durationLa.snp_makeConstraints { make in
            make.left.equalTo(self.titleLa)
            make.top.equalTo(self.titleLa.snp_bottom).offset(5)
            make.size.equalTo(CGSize(width: 100, height: 14))
        }
        
        contentView.addSubview(self.priceLa)
        priceLa.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.videoCoverView)
            make.left.equalTo(self.titleLa)
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(30)
        }
        
        contentView.addSubview(self.sawNumLa)
        sawNumLa.snp_makeConstraints { (make) in
            make.left.equalTo(self.priceLa.snp_right).offset(10)
            make.centerY.equalTo(self.priceLa)
            make.right.equalTo(self.contentView).offset(-30)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        contentView.addSubview(lineView)
        lineView.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(5)
            make.bottom.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
