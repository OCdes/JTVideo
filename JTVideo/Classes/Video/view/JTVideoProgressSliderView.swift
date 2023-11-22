//
//  JTVideoProgressSliderView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/11/22.
//

import UIKit

class JTVideoProgressSliderView: UIView {

    lazy var progressView: UIView = {
        let pv = UIView()
        pv.backgroundColor = HEX_FFF
        return pv
    }()
    
    var minimumValue: Float = 0
    var maximumValue: Float = 1
    var value: Float = 0 {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.progressView.snp_updateConstraints { make in
                    make.width.equalTo(CGFloat(self.value/self.maximumValue)*self.bounds.width)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        layer.cornerRadius = self.bounds.height/2
        layer.masksToBounds = true
    }
    
    var extranHeight: CGFloat = 50
    
    func setUI() {
        backgroundColor = HEX_FFF.withAlphaComponent(0.4)
        addSubview(progressView)
        progressView.snp_makeConstraints { make in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(0)
        }
    }
    
    
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let sRect = self.bounds
        let rect = CGRect(x: 0, y: sRect.origin.y - extranHeight, width: sRect.width, height: sRect.height + extranHeight)
        return rect.contains(point)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
