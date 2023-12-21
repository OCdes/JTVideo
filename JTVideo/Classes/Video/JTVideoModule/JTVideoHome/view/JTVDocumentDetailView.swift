//
//  JTVDocumentDetailView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/21.
//

import UIKit

class JTVDocumentDetailView: UITableView {
    
    
    
}

class JTVDocutmentDetialHeaderView: UIView {
    lazy var coverImgv: UIImageView = {
        let civ = UIImageView()
        civ.contentMode = .scaleAspectFill
        civ.clipsToBounds = true
        return civ
    }()
    
    lazy var currentPriceLa: UILabel = {
        let pl = UILabel()
        pl.textColor = HEX_COLOR(hexStr: "#F03B1D")
        pl.font = UIFont.systemFont(ofSize: 34)
        return pl
    }()
    
    lazy var priceLa: UILabel = {
        let pl = UILabel()
        pl.textColor = HEX_999
        pl.font = UIFont.systemFont(ofSize: 18)
        return pl
    }()
    
    lazy var typeLa: UILabel = {
        let tl = UILabel()
        tl.layer.cornerRadius = 4
        tl.layer.masksToBounds = true
        tl.textAlignment = .center
        tl.font = UIFont.systemFont(ofSize: 17)
        tl.textColor = HEX_FFF
        tl.backgroundColor = HEX_ThemeColor
        return tl
    }()
    
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_333
        tl.font = UIFont.systemFont(ofSize: 24)
        return tl
    }()
    
    lazy var subTitleLa: UILabel = {
        let stl = UILabel()
        stl.textColor = HEX_999
        stl.font = UIFont.systemFont(ofSize: 15)
        return stl
    }()
    
    lazy var textV: UITextView = {
        let tv = UITextView()
        tv.textColor = HEX_333
        tv.layer.cornerRadius = 8
        tv.layer.masksToBounds = true
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isEditable = false
        return tv
    }()
    
    lazy var totalLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_999
        tl.font = UIFont.systemFont(ofSize: 18)
        tl.textAlignment = .right
        tl.isUserInteractionEnabled = true
        return tl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = HEX_FFF
        let f: Float = 308/428
        addSubview(coverImgv)
        coverImgv.snp_makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(self.coverImgv.snp_width).multipliedBy(f)
        }
        
        addSubview(currentPriceLa)
        currentPriceLa.snp_makeConstraints { make in
            make.left.equalTo(self).offset(19)
            make.top.equalTo(self.coverImgv.snp_bottom).offset(27)
            make.height.equalTo(30)
        }
        
        addSubview(priceLa)
        priceLa.snp_makeConstraints { make in
            make.left.equalTo(self.currentPriceLa.snp_right).offset(10)
            make.bottom.equalTo(self.currentPriceLa)
            make.right.lessThanOrEqualTo(self)
        }
        
        addSubview(typeLa)
        typeLa.snp_makeConstraints { make in
            make.top.equalTo(self.priceLa.snp_bottom).offset(34)
            make.left.equalTo(self.currentPriceLa)
            make.size.equalTo(CGSize(width: 38, height: 22))
        }
        
        addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self.typeLa.snp_right).offset(10)
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(typeLa)
        }
        
        addSubview(subTitleLa)
        subTitleLa.snp_makeConstraints { make in
            make.left.equalTo(self.typeLa)
            make.top.equalTo(self.typeLa.snp_bottom).offset(29)
            make.right.equalTo(titleLa)
        }
        
        let line1 = UIView()
        line1.backgroundColor = HEX_VIEWBACKCOLOR
        addSubview(line1)
        line1.snp_makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(self.subTitleLa.snp_bottom).offset(64)
            make.height.equalTo(10)
        }
        
        let iconImgv = UIImageView()
        iconImgv.image = JTVideoBundleTool.getBundleImg(with: "jtvLibraryIcon")
        addSubview(iconImgv)
        iconImgv.snp_makeConstraints { make in
            make.left.equalTo(self).offset(24)
            make.top.equalTo(line1.snp_bottom).offset(19)
            make.size.equalTo(CGSize(width: 27, height: 22))
        }
        
        let tLa = UILabel()
        tLa.textColor = HEX_333
        tLa.text = "资料下载"
        tLa.font = UIFont.systemFont(ofSize: 18)
        addSubview(tLa)
        tLa.snp_makeConstraints { make in
            make.left.equalTo(iconImgv.snp_right).offset(8)
            make.top.bottom.equalTo(iconImgv)
            make.width.equalTo(80)
        }
        
        addSubview(totalLa)
        totalLa.snp_makeConstraints { make in
            make.left.equalTo(tLa.snp_right)
            make.right.equalTo(self).offset(-24)
            make.top.bottom.equalTo(tLa)
        }
        
        let line2 = UIView()
        line2.backgroundColor = HEX_VIEWBACKCOLOR
        addSubview(line2)
        line2.snp_makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(self.totalLa.snp_bottom).offset(19)
            make.height.equalTo(10)
        }
        
        let tLa2 = UILabel()
        tLa2.textColor = HEX_333
        tLa2.font = UIFont.systemFont(ofSize: 20)
        tLa2.attributedText = NSAttributedString(string: "详情", attributes: [.underlineStyle: 2, .underlineColor: HEX_ThemeColor, .baselineOffset: 10])
        addSubview(tLa2)
        tLa2.snp_makeConstraints { make in
            make.left.equalTo(self).offset(24)
            make.right.equalTo(self).offset(-24)
            make.top.equalTo(line2.snp_bottom)
            make.height.equalTo(60)
        }
        
        addSubview(textV)
        textV.snp_makeConstraints { make in
            make.left.right.equalTo(tLa2)
            make.top.equalTo(tLa2.snp_bottom)
            make.bottom.equalTo(self).offset(-20)
        }
        
        
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


