//
//  JTVAnswerCarView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2024/1/3.
//

import UIKit

class JTVAnswerCardView: UICollectionView {

    var viewModel: JTVAnswerCardViewModel = JTVAnswerCardViewModel()
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, viewModel vm: JTVAnswerCardViewModel) {
        let flowlayout = UICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: flowlayout)
        viewModel = vm
        delegate = self
        dataSource = self
        register(JTVAnswerCardItem.self, forCellWithReuseIdentifier: "JTVAnswerCardItem")
        register(JTVScoreHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "JTVScoreHeaderView")
        reloadData()
        
        _ = viewModel.rx.observeWeakly(Bool.self, "isSubmitted").subscribe(onNext: { b in
            self.reloadData()
        })
        
        _ = viewModel.rx.observeWeakly(Bool.self, "isResult").subscribe(onNext: { b in
            self.reloadData()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JTVAnswerCardView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JTVAnswerCardItem", for: indexPath) as! JTVAnswerCardItem
        cell.model = viewModel.dataArr[indexPath.item]
        cell.noLa.text = "\(indexPath.item+1)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kScreenWidth-35)/6, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.viewModel.isSubmitted {
            let height = kScreenWidth * 150/428 + 150
            return CGSize(width: kScreenWidth, height: height)
        } else {
            return CGSizeZero
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if self.viewModel.isSubmitted {
                let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JTVScoreHeaderView", for: indexPath) as! JTVScoreHeaderView
                v.scoreLa.text = self.viewModel.score
                v.noteLa.text = self.viewModel.note
                return v
            } else {
                return UICollectionReusableView()
            }
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

class JTVScoreHeaderView: UICollectionReusableView {
    lazy var scoreLa: UILabel = {
        let scoreF: Float = 150/428
        let scoreHeight = CGFloat(scoreF)*kScreenWidth
        let sl = UILabel()
        sl.font = UIFont.systemFont(ofSize: 58)
        sl.textColor = HEX_COLOR(hexStr: "#F6F6F6")
        sl.textAlignment = .center
        sl.layer.cornerRadius = scoreHeight/2
        sl.layer.masksToBounds = true
        sl.backgroundColor = HEX_ThemeColor
        return sl
    }()
    
    lazy var noteLa: UILabel = {
        let nl = UILabel()
        nl.font = UIFont.systemFont(ofSize: 18)
        nl.textAlignment = .center
        return nl
    }()
    
    override init(frame: CGRect) {
        let nframe = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth*263/428)
        super.init(frame: nframe)
        
        let scoreF: Float = 150/428
        let scoreHeight = CGFloat(scoreF)*kScreenWidth
        
        addSubview(scoreLa)
        scoreLa.snp_makeConstraints { make in
            make.centerY.equalTo(self).offset(-30)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize(width: scoreHeight, height: scoreHeight))
        }
        
        addSubview(noteLa)
        noteLa.snp_makeConstraints { make in
            make.top.equalTo(self.scoreLa.snp_bottom).offset(39)
            make.right.left.equalTo(self)
            make.height.equalTo(20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class JTVAnswerCardItem : UICollectionViewCell {
    
    var model: JTVExaminationPaperModel = JTVExaminationPaperModel() {
        didSet {
            if model.isAnswered {
                if let isCorrect = model.isCorrect {
                    if isCorrect == true {
                        self.noLa.backgroundColor = HEX_ThemeColor
                    } else {
                        self.noLa.backgroundColor = HEX_COLOR(hexStr: "#EF5151")
                    }
                    
                } else {
                    self.noLa.backgroundColor = HEX_ThemeColor
                }
            } else {
                self.noLa.backgroundColor = HEX_999
            }
        }
    }
    
    lazy var noLa: UILabel = {
        let nl = UILabel()
        nl.textColor = HEX_FFF
        nl.font = UIFont.systemFont(ofSize: 22)
        nl.textAlignment = .center
        nl.layer.cornerRadius = 17.5
        nl.layer.masksToBounds = true
        return nl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(noLa)
        noLa.snp_makeConstraints { make in
            make.center.equalTo(self.contentView)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
