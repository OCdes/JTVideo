//
//  JTVideoListPlayerControlBar.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/11/22.
//

import UIKit

class JTVideoListPlayerControlBar: UIView {

    lazy var bottomView: UIView = {
        let bv = UIView()
        bv.backgroundColor = UIColor.cyan
        return bv
    }()
    
    lazy var rightView: UIView = {
        let rv = UIView()
        rv.backgroundColor = UIColor.green
        return rv
    }()
    
    lazy var bottomTimeLa: UILabel = {
        let bt = UILabel()
        bt.font = UIFont.systemFont(ofSize: 20)
        bt.textAlignment = .center
        bt.textColor = HEX_FFF
        bt.layer.shadowColor = HEX_333.withAlphaComponent(0.3).cgColor
        bt.layer.shadowOpacity = 1
        bt.alpha = 0
        return bt
    }()
    
    lazy var bottomSlider: JTVideoProgressSliderView = {
        let bs = JTVideoProgressSliderView(frame: CGRectZero)
        bs.minimumValue = 0
        bs.maximumValue = 1
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(pan:)))
        bs.addGestureRecognizer(pan)
        return bs
    }()
    
    var totalPosition: Int64 = 0 {
        didSet {
            self.bottomSlider.maximumValue = Float(totalPosition)
        }
    }
    
    var toPosition: Int64 = 0 {
        didSet {
            self.bottomSlider.value = Float(toPosition)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bottomSlider)
        bottomSlider.snp_makeConstraints { make in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(1)
        }
        
        addSubview(bottomTimeLa)
        bottomTimeLa.snp_makeConstraints { make in
            make.left.right.equalTo(self)
            make.bottom.equalTo(bottomSlider.snp_top).offset(-bottomSlider.extranHeight)
            make.height.equalTo(30)
        }
        
        addSubview(rightView)
        rightView.snp_makeConstraints { make in
            make.right.bottom.equalTo(self)
            make.width.equalTo(100)
            make.height.equalTo(kScreenHeight/2)
        }
        
        addSubview(bottomView)
        bottomView.snp_makeConstraints { make in
            make.left.equalTo(self)
            make.right.equalTo(self.rightView.snp_left).offset(-30)
            make.bottom.equalTo(self.bottomSlider.snp_top).offset(-20)
            make.height.lessThanOrEqualTo(kScreenHeight/2)
        }
        
        
    }
    
    @objc func pan(pan:UIPanGestureRecognizer) {
        let state = pan.state
        switch state {
        case .changed:
            let location = pan.location(in: bottomSlider)
            self.bottomSlider.value = Float((location.x/self.bottomSlider.frame.width)*CGFloat(totalPosition))
            UIView.animate(withDuration: 0.3) {
                self.bottomSlider.snp_updateConstraints { make in
                    make.height.equalTo(10)
                }
                self.bottomView.alpha = 0.01
                self.rightView.alpha = 0.01
                self.bottomTimeLa.alpha = 1
            }
            break
        case .ended:
            UIView.animate(withDuration: 0.3) {
                self.bottomSlider.snp_updateConstraints { make in
                    make.height.equalTo(1)
                }
                self.bottomView.alpha = 1
                self.rightView.alpha = 1
                self.bottomTimeLa.alpha = 0.01
            }
            
            break
        default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
