//
//  JTVMineListView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/13.
//

import UIKit

class JTVMineListView: UICollectionView {
    let courseInterSapce: CGFloat = 22
    let menuInterSpace: CGFloat = 0
    var viewModel: JTVMineViewModel = JTVMineViewModel()
    var dataArr: [JTVMineSectionModel] = [] {
        didSet {
            reloadData()
        }
    }
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, viewModel vm: JTVMineViewModel) {
        super.init(frame: frame, collectionViewLayout: layout)
        viewModel = vm
        backgroundColor = HEX_VIEWBACKCOLOR
        delegate = self
        dataSource = self
        register(JTVMineHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JTVMineHeaderView")
        register(JTVMineClassCell.self, forCellWithReuseIdentifier: "JTVMineClassCell")
        register(JTVMineMenuCell.self, forCellWithReuseIdentifier: "JTVMineMenuCell")
        _ = viewModel.rx.observeWeakly([Any].self, "dataArr").subscribe(onNext: { [weak self] arr in
            if let darr = arr as? [JTVMineSectionModel] {
                self?.dataArr = darr
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JTVMineListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr[section].sectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionModel = dataArr[indexPath.section]
        let sectionItem = sectionModel.sectionItems[indexPath.item]
        if sectionModel.sectionType == .course {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVMineClassCell", for: indexPath) as! JTVMineClassCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVMineMenuCell", for: indexPath) as! JTVMineMenuCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JTVMineHeaderView", for: indexPath) as! JTVMineHeaderView
            return v
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: kScreenWidth, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionModel = dataArr[indexPath.section]
        if sectionModel.sectionType == .course {
            let width = (kScreenWidth - 48 - 50)/3
            let height = width*89/111
            return CGSize(width: width, height: height)
        } else {
            let width = kScreenWidth/5
            return CGSize(width: width, height: 91)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionModel = dataArr[section]
        if sectionModel.sectionType == .course {
            
            return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        } else {
            return UIEdgeInsets.zero
        }
    }
}

class JTVMineHeaderView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class JTVMineClassCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class JTVMineMenuCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
