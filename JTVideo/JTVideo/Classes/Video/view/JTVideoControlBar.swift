//
//  JTVideoControlBar.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/11/2.
//

import UIKit

class JTVideoControlBar: UIImageView, CAAnimationDelegate {

    
    lazy var topMinView: UIImageView = {
        let tv = UIImageView()
        tv.isUserInteractionEnabled = true
        tv.image = UIImage.init(named: "topMask ")
        return tv
    }()
    
    lazy var topFullView: UIImageView = {
        let tv = UIImageView()
        tv.isUserInteractionEnabled = true
        tv.image = UIImage.init(named: "topMask ")
        return tv
    }()
    
    lazy var bottomMinView: UIImageView = {
        let tv = UIImageView()
        tv.isUserInteractionEnabled = true
        tv.image = UIImage.init(named: "bottomMask")
        return tv
    }()
    
    lazy var bottomFullView: UIImageView = {
        let tv = UIImageView()
        tv.isUserInteractionEnabled = true
        tv.image = UIImage.init(named: "bottomMask")
        return tv
    }()
    
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_FFF
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    lazy var playBtn: UIButton = {
        let pb = UIButton()
        pb.setImage(JTVideoBundleTool.getBundleImg(with: "playIcon"), for: .normal)
        pb.setImage(JTVideoBundleTool.getBundleImg(with: "pauseIcon"), for: .selected)
        return pb
    }()
    
    lazy var startTimeLa: UILabel = {
        let stl = UILabel()
        stl.font = UIFont.systemFont(ofSize: 10)
        stl.textColor = HEX_FFF
        stl.textAlignment = .center
        return stl
    }()
    
    lazy var endTimeLa: UILabel = {
        let etl = UILabel()
        etl.font = UIFont.systemFont(ofSize: 10)
        etl.textColor = HEX_FFF
        etl.textAlignment = .center
        return etl
    }()
    
    lazy var fullscreenBtn: UIButton = {
        let fsb = UIButton()
        fsb.setImage(JTVideoBundleTool.getBundleImg(with: "fullscreenIcon"), for: .normal)
        return fsb
    }()
    
    lazy var progressView: UIView = {
        let pv = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height-23.5, width: self.frame.size.width - 200, height: 3))
        pv.backgroundColor = HEX_FFF.withAlphaComponent(0.3)
        pv.layer.cornerRadius = 1.5
        pv.layer.masksToBounds = true
        pv.addSubview(self.progressLayer)
        pv.addSubview(self.bufferLayer)
        return pv
    }()
    
    lazy var bufferLayer: UIView = {
        let pl = UIView()
        pl.frame = CGRect(x: 0, y: 0, width: 0, height: 3)
        pl.backgroundColor = HEX_FFF.withAlphaComponent(0.4)
        pl.layer.cornerRadius = 1.5
        pl.layer.masksToBounds = true
        return pl
    }()
    
    lazy var progressLayer: UIView = {
        let pl = UIView()
        pl.frame = CGRect(x: 0, y: 0, width: 0, height: 3)
        pl.backgroundColor = HEX_FFF
        pl.layer.cornerRadius = 1.5
        pl.layer.masksToBounds = true
        return pl
    }()
    
    lazy var progressBtn: UIButton = {
        let pb = UIButton.init(frame: CGRect(x: 0, y: 0, width: 6, height: 6))
        pb.setImage(JTVideoBundleTool.getBundleImg(with: "playDotIcon"), for: .normal)
        pb.extraArea(area: UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6))
        return pb
    }()
    
    lazy var loadingLabel: UILabel = {
        let ll = UILabel.init(frame: CGRect(x:0, y:0, width: 80, height: 20))
        ll.center = self.center
        ll.text = "正在缓冲..."
        ll.font = UIFont.systemFont(ofSize: 14)
        ll.layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
        ll.layer.shadowRadius = 10
        ll.layer.shadowOpacity = 1
        
        ll.textColor = HEX_FFF
        return ll
    }()
    
    var prepared: Bool = false {
        didSet {
            if !prepared {
                
            } else {
                backgroundColor = UIColor.clear
                playBtn.isUserInteractionEnabled = true
            }
        }
    }
    var currentAnimationTarget: UIView = UIView()
    var currentAnimationTo: CGFloat = 0
    var totalPostion: Int64 = 0 {
        didSet {
            self.endTimeLa.text = dealmimseconds(mimsecond: totalPostion)
        }
    }
    private final var isMiniScreen: Bool = false
    private final var totalTime: String = ""
    var animationProgressTo: Int64 = 0
    var animationBufferTo: Int64 = 0
    private var progressWidth: CGFloat = 0
    
    init(frame: CGRect, isMiniScreen: Bool, totalTime: String) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        self.isMiniScreen = isMiniScreen
        self.totalTime = totalTime
        self.endTimeLa.text = totalTime
        self.startTimeLa.text = "00:00"
        backgroundColor = HEX_333
        addSubview(self.loadingLabel)
        playBtn.isUserInteractionEnabled = false
        if isMiniScreen {
            setTopMinView()
            setBottomMinView()
        } else {
            setTopFullView()
            setBottomFullView()
        }
    }
    
    func setTopMinView() {
        addSubview(topMinView)
        topMinView.snp_makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(64)
        }
        
        topMinView.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self.topMinView).offset(15)
            make.top.bottom.equalTo(self.topMinView)
            make.right.equalTo(self.topMinView).offset(-15)
        }
    }
    
    func setBottomMinView() {
        
        let totalTimeWidth = CGFloat(45)
        
        addSubview(bottomMinView)
        bottomMinView.snp_makeConstraints { make in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(50)
        }
        
        bottomMinView.addSubview(playBtn)
        playBtn.snp_makeConstraints { make in
            make.left.equalTo(self.bottomMinView).offset(10)
            make.centerY.equalTo(self.bottomMinView)
            make.size.equalTo(CGSize(width: 25, height: 30))
        }
        
        bottomMinView.addSubview(fullscreenBtn)
        fullscreenBtn.snp_makeConstraints { make in
            make.right.equalTo(bottomMinView).offset(-10)
            make.centerY.equalTo(self.playBtn)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        
        bottomMinView.addSubview(startTimeLa)
        startTimeLa.snp_makeConstraints { make in
            make.left.equalTo(self.playBtn.snp_right)
            make.centerY.equalTo(self.playBtn)
            make.width.equalTo(totalTimeWidth)
        }
        
        bottomMinView.addSubview(endTimeLa)
        endTimeLa.snp_makeConstraints { make in
            make.right.equalTo(self.fullscreenBtn.snp_left)
            make.centerY.equalTo(self.fullscreenBtn)
            make.size.equalTo(CGSize(width: totalTimeWidth, height: 12))
        }
        
        bottomMinView.addSubview(progressView)
        progressView.snp_makeConstraints { make in
            make.left.equalTo(self.startTimeLa.snp_right).offset(10)
            make.right.equalTo(self.endTimeLa.snp_left).offset(-10)
            make.centerY.equalTo(self.playBtn)
            make.height.equalTo(3)
        }
        
        progressView.addSubview(self.progressBtn)
        progressBtn.snp_makeConstraints { make in
            make.centerX.equalTo(self.progressView.snp_left)
            make.centerY.equalTo(self.progressView)
            make.size.equalTo(CGSize(width: 6, height: 6))
        }
    }
    
    func setTopFullView() {
        addSubview(topFullView)
        topFullView.snp_makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(64)
        }
        
        topFullView.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self.topFullView).offset(15)
            make.top.bottom.equalTo(self.topFullView)
            make.right.equalTo(self.topFullView).offset(-15)
        }
    }
    
    func setBottomFullView() {
        addSubview(bottomMinView)
        bottomMinView.snp_makeConstraints { make in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(50)
        }
        
        bottomMinView.addSubview(playBtn)
        playBtn.snp_makeConstraints { make in
            make.left.equalTo(self.bottomMinView).offset(15)
            make.centerY.equalTo(self.bottomMinView)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
    }
    
    func progressAnimate(targetLayer: UIView, to: Int64) {
        if to >= self.totalPostion {
            return
        }
        
        let toFloat: CGFloat = CGFloat(CGFloat(to)/CGFloat(self.totalPostion))*(self.frame.size.width - 200)
        if targetLayer == self.bufferLayer {
            self.animationBufferTo = to
        } else {
            
            self.startTimeLa.text = dealmimseconds(mimsecond: to)
            self.animationProgressTo = to
        }
        self.loadingLabel.isHidden = self.animationBufferTo > self.animationProgressTo
        var rect = targetLayer.frame
        rect.size.width = toFloat
        targetLayer.frame = rect
        
        NSLog("步进距离=========\(toFloat)")
        let animation = CABasicAnimation.init(keyPath: "bounds.size.width")
        animation.fromValue = targetLayer.frame.size.width
        animation.toValue = toFloat
        animation.duration = 0.3
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        targetLayer.layer.add(animation, forKey: "bounds.size.width")
        animation.delegate = self
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        
    }
    
    func dealmimseconds (mimsecond: Int64) -> String {
        let totalSeconds = mimsecond/1000
        let hour = totalSeconds / (60 * 60)
        let min = (totalSeconds % (60 * 60)) / 60
        let sec = (totalSeconds % (60 * 60)) % 60
        if hour > 0 {
            return "\(hour < 10 ? "0" : "")\(hour):\(min < 10 ? "0" : "")\(min):\(sec < 10 ? "0" : "")\(sec)"
        } else {
            if min > 0 {
                return "\(min < 10 ? "0" : "")\(min):\(sec < 10 ? "0" : "")\(sec)"
            } else {
                if sec > 0 {
                    return "00:\(sec < 10 ? "0" : "")\(sec)"
                }
            }
        }
        return ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
