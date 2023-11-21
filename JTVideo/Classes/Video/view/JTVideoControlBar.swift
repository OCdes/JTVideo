//
//  JTVideoControlBar.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/11/2.
//

import UIKit
import MediaPlayer
public protocol JTVideoControlBarDelegate: NSObjectProtocol {
    func playerBtnisClicked(btn: UIButton)
    func panSeek(to: Int64)
    func fullScreen(isMini: Bool)
}

public class JTVideoControlBar: UIImageView, CAAnimationDelegate, UIGestureRecognizerDelegate {
    
    open weak var delegate: JTVideoControlBarDelegate?
    lazy var topView: UIImageView = {
        let tv = UIImageView()
        tv.isUserInteractionEnabled = true
        tv.image = UIImage.init(named: "topMask ")
        return tv
    }()
    
    //窗口中部,便于后续拓展的view
    lazy var middleView: UIView = {
        let mmv = UIView()
        let singleTap = UITapGestureRecognizer.init(target: self, action: #selector(tapGesture))
        mmv.addGestureRecognizer(singleTap)
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(doubleTapGesture))
        doubleTap.numberOfTapsRequired = 2
        mmv.addGestureRecognizer(doubleTap)
        singleTap.require(toFail: doubleTap)
        let progressPan = UIPanGestureRecognizer(target: self, action: #selector(middelPan(pan:)))
        mmv.addGestureRecognizer(progressPan)
        //        let panl = UIPanGestureRecognizer(target: self, action: #selector(leftAxiasYPan(pan:)))
        //        mmv.addGestureRecognizer(panl)
        //        let panr = UIPanGestureRecognizer(target: self, action: #selector(rightAxiasYPan(pan:)))
        //        mmv.addGestureRecognizer(pan)
        return mmv
    }()
    
    var leftRect: CGRect {
        return CGRect(x: 0, y: 0, width: self.middleView.frame.width/2, height: self.middleView.frame.height)
    }
    
    var rightRect: CGRect {
        return CGRect(x: self.middleView.frame.width/2, y: 0, width: self.middleView.frame.width/2, height: self.middleView.frame.height)
    }
    
    lazy var leftView: UIView = {
        let lv = UIView()
        lv.backgroundColor = UIColor.clear
        //        let pan = UIPanGestureRecognizer(target: self, action: #selector(leftAxiasYPan(pan:)))
        //        lv.addGestureRecognizer(pan)
        lv.isHidden = true
        return lv
    }()
    
    lazy var rightView: UIView = {
        let rv = UIView()
        rv.backgroundColor = UIColor.clear
        //        let pan = UIPanGestureRecognizer(target: self, action: #selector(rightAxiasYPan(pan:)))
        //        rv.addGestureRecognizer(pan)
        rv.isHidden = true
        return rv
    }()
    
    lazy var middleTimeLabel: UILabel = {
        let mtl = UILabel()
        mtl.textAlignment = .center
        mtl.text = "00:00/00:00"
        mtl.isHidden = true
        mtl.backgroundColor = HEX_FFF.withAlphaComponent(0.3)
        return mtl
    }()
    
    lazy var bottomView: UIImageView = {
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
        pb.addTarget(self, action: #selector(playerBtnClicked), for: .touchUpInside)
        return pb
    }()
    
    lazy var startTimeLa: UILabel = {
        let stl = UILabel()
        stl.font = UIFont.systemFont(ofSize: 10)
        stl.textColor = HEX_FFF
        stl.textAlignment = .left
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
        fsb.addTarget(self, action: #selector(fullScreenBtnClicked), for: .touchUpInside)
        return fsb
    }()
    
    lazy var progressBgView: UIView = {
        let pv = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height-18.5, width: self.progressBgvWidth, height: 13))
        pv.backgroundColor = UIColor.clear
        return pv
    }()
    
    lazy var progressView: UIView = {
        let pv = UIView.init(frame: CGRect(x: 6.5, y: 5, width: self.progressWidth, height: 3))
        pv.backgroundColor = HEX_FFF.withAlphaComponent(0.3)
        pv.layer.cornerRadius = 1.5
        pv.layer.masksToBounds = true
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
        let pb = UIButton.init(frame: CGRect(x: 0, y: 0, width: 13, height: 13))
        pb.setImage(JTVideoBundleTool.getBundleImg(with: "playDotIcon"), for: .normal)
        let pan = UIPanGestureRecognizer()
        pan.delegate = self
        pan.addTarget(self, action: #selector(panGesture(pan:)))
        pb.addGestureRecognizer(pan)
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
    // MARK: 得知缓冲就绪状态
    var prepared: Bool = false {
        didSet {
            if !prepared {
                
            } else {
                backgroundColor = UIColor.clear
                playBtn.isUserInteractionEnabled = true
            }
        }
    }
    //总时长 毫秒
    var totalPostion: Int64 = 0 {
        didSet {
            self.endTimeLa.text = dealmimseconds(mimsecond: totalPostion)
            self.middleTimeLabel.text = "00:\(dealmimseconds(mimsecond: totalPostion))"
            let totalSeconds = totalPostion/1000
            let hour = totalSeconds / (60 * 60)
            let min = (totalSeconds % (60 * 60)) / 60
            if hour >= 1 {
                progressStepinDistance = totalPostion/10
            } else if (min > 30) {
                progressStepinDistance = totalPostion/5
            } else if (min > 10) {
                progressStepinDistance = totalPostion/3
            } else if (min > 3) {
                progressStepinDistance = totalPostion/2
            } else {
                progressStepinDistance = totalPostion
            }
        }
    }
    private var progressWidth: CGFloat {
        return self.isMiniScreen ? (self.frame.size.width - 160 - 13) : (self.frame.size.width - 30)
    }
    private var progressBgvWidth: CGFloat {
        return isMiniScreen ? self.frame.size.width - 160 : self.frame.size.width - 17
    }
    var currentAnimationTarget: UIView = UIView()
    var currentAnimationTo: CGFloat = 0
    var currentBrightness: CGFloat {
        return UIScreen.main.brightness
    }
    var animationProgressTo: Int64 = 0
    var animationBufferTo: Int64 = 0
    var panBeginPositionX: Double = 0
    var panBeginPositionY: Double = 0
    private final var isMiniScreen: Bool = false
    private final var totalTime: String = ""
    private var barHide = false
    private var panTransitionX: Double = 0.0
    private var leftPanTransitionY: Double = 0.0
    private var rightPanTransitionY: Double = 0.0
    private var panTransitionY: Double = 0.0
    private var aixasYDistance: CGFloat = 0
    private var progressStepinDistance: Int64 = 0
    private var middelStartPoint: CGPoint = CGPoint.zero
    private var middelPanXEndPosition: Int64 = 0
    private var middelPanYEndPostion: Float = 0
    private var brightnessStart: CGFloat {
        return UIScreen.main.brightness
    }
    private var volumeView: UISlider?
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
        initView()
        if isMiniScreen {
            setMinView()
        } else {
            setFullView()
        }
        dealVolumViewAndAirDrop()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
    }
    
    func initView() {
        addSubview(topView)
        topView.snp_makeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(64)
        }
        
        topView.addSubview(titleLa)
        titleLa.snp_makeConstraints { make in
            make.left.equalTo(self.topView).offset(15)
            make.top.bottom.equalTo(self.topView)
            make.right.equalTo(self.topView).offset(-15)
        }
        
        addSubview(bottomView)
        bottomView.snp_makeConstraints { make in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(50)
        }
        
        bottomView.addSubview(playBtn)
        playBtn.snp_makeConstraints { make in
            make.left.equalTo(self.bottomView).offset(10)
            make.centerY.equalTo(self.bottomView)
            make.size.equalTo(CGSize(width: 25, height: 30))
        }
        
        bottomView.addSubview(fullscreenBtn)
        fullscreenBtn.snp_makeConstraints { make in
            make.right.equalTo(bottomView).offset(-10)
            make.centerY.equalTo(self.playBtn)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        
        bottomView.addSubview(startTimeLa)
        startTimeLa.snp_makeConstraints { make in
            make.left.equalTo(self.playBtn.snp_right)
            make.centerY.equalTo(self.playBtn)
            make.width.equalTo(45)
        }
        
        bottomView.addSubview(endTimeLa)
        endTimeLa.snp_makeConstraints { make in
            make.right.equalTo(self.fullscreenBtn.snp_left)
            make.centerY.equalTo(self.fullscreenBtn)
            make.size.equalTo(CGSize(width: 45, height: 12))
        }
        
        bottomView.addSubview(progressBgView)
        progressBgView.snp_makeConstraints { make in
            make.left.equalTo(self.startTimeLa.snp_right)
            make.right.equalTo(self.endTimeLa.snp_left)
            make.centerY.equalTo(self.playBtn)
            make.height.equalTo(13)
        }
        
        progressBgView.addSubview(self.progressView)
        self.progressView.snp_makeConstraints { make in
            make.top.equalTo(self.progressBgView).offset(5)
            make.left.equalTo(self.progressBgView).offset(6.5)
            make.size.equalTo(CGSize(width: self.progressWidth, height: 3))
        }
        
        progressView.addSubview(self.progressLayer)
        self.progressLayer.snp_makeConstraints { make in
            make.left.top.bottom.equalTo(self.progressView)
            make.width.equalTo(0)
        }
        
        progressView.addSubview(self.bufferLayer)
        self.bufferLayer.snp_makeConstraints { make in
            make.left.top.bottom.equalTo(self.progressView)
            make.width.equalTo(0)
        }
        
        progressBgView.addSubview(self.progressBtn)
        self.progressBtn.snp_makeConstraints { make in
            make.left.top.equalTo(self.progressBgView)
            make.size.equalTo(CGSize(width: 13, height: 13))
        }
        
        addSubview(middleView)
        middleView.snp_makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(self.topView.snp_bottom)
            make.bottom.equalTo(self.bottomView.snp_top)
        }
        
        middleView.addSubview(leftView)
        leftView.snp_makeConstraints { make in
            make.left.top.bottom.equalTo(self.middleView)
            make.width.equalTo(self.middleView.snp_width).multipliedBy(0.5)
        }
        
        middleView.addSubview(rightView)
        rightView.snp_makeConstraints { make in
            make.right.top.bottom.equalTo(self.middleView)
            make.width.equalTo(self.middleView.snp_width).multipliedBy(0.5)
        }
        
        middleView.addSubview(middleTimeLabel)
        middleTimeLabel.snp_makeConstraints { make in
            make.left.right.top.bottom.equalTo(self.middleView)
        }
        
        if !isMiniScreen {
            updateView()
        }
    }
    
    
    func updateView() {
        if isMiniScreen {
            setMinView()
        } else {
            setFullView()
        }
        updateCurrentProgressAndBuffer()
    }
    
    func updateCurrentProgressAndBuffer() {
        //横竖转换后
        //更新buffer条宽度
        let toBufferFloat: CGFloat = CGFloat(CGFloat(self.animationBufferTo)/CGFloat(self.totalPostion))*(progressWidth)
        self.bufferLayer.snp_updateConstraints { make in
            make.width.equalTo(toBufferFloat)
        }
        //更新进度条宽度
        let toProgressFloat: CGFloat = CGFloat(CGFloat(self.animationProgressTo)/CGFloat(self.totalPostion))*(progressWidth)
        self.progressLayer.snp_updateConstraints { make in
            make.width.equalTo(toProgressFloat)
        }
        
        //更新进度按钮位置
        var position = self.progressBtn.layer.position
        position.x = 6.5 + toProgressFloat
        progressXAnimation(to: position, target: self.progressBtn)
    }
    
    func setMinView() {
        self.startTimeLa.textAlignment = .center
        self.endTimeLa.textAlignment = .center
        topView.snp_remakeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(64)
        }
        
        titleLa.snp_remakeConstraints { make in
            make.left.equalTo(self.topView).offset(15)
            make.top.bottom.equalTo(self.topView)
            make.right.equalTo(self.topView).offset(-15)
        }
        
        bottomView.snp_remakeConstraints { make in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(50)
        }
        
        playBtn.snp_remakeConstraints { make in
            make.left.equalTo(self.bottomView).offset(10)
            make.centerY.equalTo(self.bottomView)
            make.size.equalTo(CGSize(width: 25, height: 30))
        }
        
        fullscreenBtn.snp_remakeConstraints { make in
            make.right.equalTo(bottomView).offset(-10)
            make.centerY.equalTo(self.playBtn)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        
        startTimeLa.snp_remakeConstraints { make in
            make.left.equalTo(self.playBtn.snp_right)
            make.centerY.equalTo(self.playBtn)
            make.width.equalTo(45)
        }
        
        endTimeLa.snp_remakeConstraints { make in
            make.right.equalTo(self.fullscreenBtn.snp_left)
            make.centerY.equalTo(self.fullscreenBtn)
            make.size.equalTo(CGSize(width: 45, height: 12))
        }
        
        progressBgView.snp_remakeConstraints { make in
            make.left.equalTo(self.startTimeLa.snp_right)
            make.right.equalTo(self.endTimeLa.snp_left)
            make.centerY.equalTo(self.playBtn)
            make.height.equalTo(13)
        }
        
        self.progressView.snp_remakeConstraints { make in
            make.top.equalTo(self.progressBgView).offset(5)
            make.left.equalTo(self.progressBgView).offset(6.5)
            make.size.equalTo(CGSize(width: self.progressWidth, height: 3))
        }
        
        self.progressLayer.snp_remakeConstraints { make in
            make.left.top.bottom.equalTo(self.progressView)
            make.width.equalTo(0)
        }
        
        self.bufferLayer.snp_remakeConstraints { make in
            make.left.top.bottom.equalTo(self.progressView)
            make.width.equalTo(0)
        }
        
        self.progressBtn.snp_remakeConstraints { make in
            make.left.top.equalTo(self.progressBgView)
            make.size.equalTo(CGSize(width: 13, height: 13))
        }
        
        middleView.snp_remakeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(self.topView.snp_bottom)
            make.bottom.equalTo(self.bottomView.snp_top)
        }
        
        leftView.snp_remakeConstraints { make in
            make.left.top.bottom.equalTo(self.middleView)
            make.width.equalTo(self.middleView.snp_width).multipliedBy(0.5)
        }
        
        rightView.snp_remakeConstraints { make in
            make.right.top.bottom.equalTo(self.middleView)
            make.width.equalTo(self.middleView.snp_width).multipliedBy(0.5)
        }
        
        middleTimeLabel.snp_remakeConstraints { make in
            make.left.right.top.bottom.equalTo(self.middleView)
        }
    }
    
    func setFullView() {
        self.startTimeLa.textAlignment = .left
        self.endTimeLa.textAlignment = .right
        topView.snp_remakeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(64)
        }
        
        titleLa.snp_remakeConstraints { make in
            make.left.equalTo(self.topView).offset(45)
            make.top.bottom.equalTo(self.topView)
            make.right.equalTo(self.topView).offset(-15)
        }
        
        bottomView.snp_remakeConstraints { make in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(95)
        }
        
        startTimeLa.snp_remakeConstraints { make in
            make.left.equalTo(self.bottomView).offset(15)
            make.top.equalTo(self.bottomView).offset(20)
            make.size.equalTo(CGSize(width: 130, height: 20))
        }
        
        endTimeLa.snp_remakeConstraints { make in
            make.right.equalTo(self.bottomView).offset(-15)
            make.size.centerY.equalTo(self.startTimeLa)
        }
        
        progressBgView.snp_remakeConstraints { make in
            make.left.equalTo(self.bottomView).offset(8.5)
            make.top.equalTo(self.startTimeLa.snp_bottom)
            make.right.equalTo(self.bottomView).offset(-8.5)
            make.height.equalTo(13)
        }
        
        self.progressView.snp_remakeConstraints { make in
            make.top.equalTo(self.progressBgView).offset(5)
            make.left.equalTo(self.progressBgView).offset(6.5)
            make.width.equalTo(self.progressWidth)
            make.height.equalTo(3)
        }
        
        self.progressLayer.snp_remakeConstraints { make in
            make.left.top.bottom.equalTo(self.progressView)
            make.width.equalTo(0)
        }
        
        self.bufferLayer.snp_remakeConstraints { make in
            make.left.top.bottom.equalTo(self.progressView)
            make.width.equalTo(0)
        }
        
        progressBgView.addSubview(self.progressBtn)
        self.progressBtn.snp_remakeConstraints { make in
            make.left.top.equalTo(self.progressBgView)
            make.size.equalTo(CGSize(width: 13, height: 13))
        }
        
        playBtn.snp_remakeConstraints { make in
            make.left.equalTo(self.startTimeLa)
            make.top.equalTo(self.progressBgView.snp_bottom)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        fullscreenBtn.snp_remakeConstraints { make in
            make.right.equalTo(bottomView).offset(-15)
            make.centerY.equalTo(self.playBtn)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        middleView.snp_remakeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(self.topView.snp_bottom)
            make.bottom.equalTo(self.bottomView.snp_top)
        }
        
        leftView.snp_remakeConstraints { make in
            make.left.top.bottom.equalTo(self.middleView)
            make.width.equalTo(self.middleView.snp_width).multipliedBy(0.5)
        }
        
        rightView.snp_remakeConstraints { make in
            make.right.top.bottom.equalTo(self.middleView)
            make.width.equalTo(self.middleView.snp_width).multipliedBy(0.5)
        }
        
        middleTimeLabel.snp_remakeConstraints { make in
            make.left.right.top.bottom.equalTo(self.middleView)
        }
    }
    
    func dealVolumViewAndAirDrop() {
        let mpVolumeView = MPVolumeView()
        for v in mpVolumeView.subviews {
            if v.isKind(of: UISlider.self) {
                if let vv = v as? UISlider {
                    volumeView = vv
                }
            }
        }
    }
    
    // MARK: -控制条控制-
    open func progressAnimate(targetLayer: UIView, to: Int64) {
        if to > self.totalPostion {
            return
        }
        self.loadingLabel.isHidden = self.animationBufferTo > self.animationProgressTo
        
        let toFloat: CGFloat = CGFloat(CGFloat(to)/CGFloat(self.totalPostion))*(progressWidth)
        if targetLayer == self.bufferLayer {
            self.animationBufferTo = to
        } else {
            self.startTimeLa.text = dealmimseconds(mimsecond: to)
            self.animationProgressTo = to
            
            if panTransitionX == 0 {
                var position = self.progressBtn.layer.position
                position.x = 6.5 + toFloat
                progressXAnimation(to: position, target: self.progressBtn)
            }
        }
        progressWidthAnimation(to: toFloat, target: targetLayer)
    }
    //x位置改变动画
    func progressXAnimation(to: CGPoint, target: UIView) {
        target.layer.position = to
        let animationx = CABasicAnimation.init(keyPath: "position")
        animationx.fromValue = NSValue(cgPoint: target.layer.position)
        animationx.toValue = NSValue(cgPoint: to)
        animationx.duration = 0.3
        animationx.isRemovedOnCompletion = false
        animationx.fillMode = kCAFillModeForwards
        target.layer.add(animationx, forKey: nil)
    }
    //宽度改变动画
    func progressWidthAnimation(to: CGFloat, target: UIView) {
        UIView.animate(withDuration: 0.3) {
            target.snp_updateConstraints { make in
                make.width.equalTo(to)
            }
        }
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
        return "00:00"
    }
    
    // MARK: -点击事件-
    //点击播放按钮
    @objc func playerBtnClicked() {
        self.playBtn.isSelected = !self.playBtn.isSelected
        if let dele = self.delegate {
            dele.playerBtnisClicked(btn: self.playBtn)
        }
    }
    //点击全屏/小屏
    @objc func fullScreenBtnClicked() {
        isMiniScreen = !isMiniScreen
        self.topView.isHidden = true
        self.bottomView.isHidden = true
        self.barHide = true
        if let de = delegate {
            de.fullScreen(isMini: isMiniScreen)
        }
    }
    //MARK: 中部区域单机,双击,上下滑,左右滑手势相关方法
    //单击事件
    @objc func tapGesture() {
        barHide = !barHide
        if isMiniScreen {
            UIView.animate(withDuration: 0.3) {
                self.topView.snp_updateConstraints { make in
                    make.top.equalTo(self).offset(self.barHide ? -64 : 0)
                }
                
                self.bottomView.snp_updateConstraints { make in
                    make.bottom.equalTo(self).offset(self.barHide ? 50 : 0)
                }
                self.topView.isHidden = self.barHide
                self.bottomView.isHidden = self.barHide
            }
        } else {
            if (self.topView.superview == nil) {
                updateView()
            }
            UIView.animate(withDuration: 0.3) {
                self.topView.snp_updateConstraints { make in
                    make.top.equalTo(self).offset(self.barHide ? -64 : 0)
                }
                
                self.bottomView.snp_updateConstraints { make in
                    make.bottom.equalTo(self).offset(self.barHide ? 123 : 0)
                }
                self.topView.isHidden = self.barHide
                self.bottomView.isHidden = self.barHide
            }
        }
        updateView()
    }
    //双击事件
    @objc func doubleTapGesture() {
        if (isMiniScreen && self.bottomView.isHidden) || (!isMiniScreen && self.bottomView.isHidden) {
            barHide = true
            tapGesture()
        }
        playerBtnClicked()
    }
    //x拖动事件
    @objc func panGesture(pan: UIPanGestureRecognizer) {
        let transtionX = pan.translation(in: pan.view).x
        let positionX = pan.location(in: pan.view).x
        let state = pan.state
        switch state {
        case .began:
            if let v = pan.view, v == self.progressBtn {
                panBeginPositionX = self.progressBtn.layer.position.x
                setTimeViewHide(b: false)
            }
            break
        case .changed:
            NSLog("向%@滑动了,滑动距离:%f;中心点水:%f", (transtionX < 0) ? "左" : "右", transtionX,positionX)
            if let v = pan.view, v == self.progressBtn {
                var position = self.progressBtn.layer.position
                let offsetx = panBeginPositionX - 6.5 + transtionX
                
                if offsetx >= 0 && offsetx <= progressWidth{
                    position.x = panBeginPositionX + transtionX
                    NSLog("中心点位置:%f", position.x)
                    progressXAnimation(to: position, target: self.progressBtn)
                    let toTime = Int64(Float(offsetx/progressWidth)*Float(totalPostion))
                    self.middleTimeLabel.text = "\(dealmimseconds(mimsecond: toTime)):\(dealmimseconds(mimsecond: totalPostion))"
                }
            }
            
            break
        case .ended:
            if let v = pan.view, v == self.progressBtn {
                let offsetx = panBeginPositionX + transtionX - 6.5
                if offsetx >= 0 && offsetx <= progressWidth{
                    let seekTo = CGFloat(self.totalPostion)*CGFloat(offsetx)/self.progressWidth
                    if let de = self.delegate {
                        de.panSeek(to: Int64(seekTo))
                    }
                }
            }
            panBeginPositionX = 0
            panTransitionX = 0
            setTimeViewHide(b: true)
            break
        default:
            break
        }
    }
    
    @objc func middelPan(pan: UIPanGestureRecognizer) {
        let state = pan.state
        switch state {
        case .began:
            let point = pan.location(in: pan.view)
            middelStartPoint = point
            if leftRect.contains(point) {
                leftPanTransitionY = point.y
                let rect = self.leftView.frame
                aixasYDistance = rect.height
            }
            if rightRect.contains(point) {
                rightPanTransitionY = point.y
                let rect = self.leftView.frame
                aixasYDistance = rect.height
            }
            
            let location = pan.location(in: pan.view)
            panTransitionX = location.x
            
            break
            
        case .changed:
            let transitionPoint = pan.location(in: pan.view)
            let width = transitionPoint.x - middelStartPoint.x
            let height = transitionPoint.y - middelStartPoint.y
            let isUpdownPan = fabs(height/width) > 1
            if isUpdownPan && middelPanXEndPosition == 0 {
                //音量
                if  leftPanTransitionY > 0 {
                    if leftRect.contains(transitionPoint) {
                        let stepY = transitionPoint.y-leftPanTransitionY
                        let stepDistance = -Float(stepY/(aixasYDistance))
                        if let vv = volumeView {
                            let totalValue = vv.value + stepDistance
                            middelPanYEndPostion = totalValue
                            vv.setValue(totalValue > 1 ? 1 : totalValue, animated: true)
                        }
                    }
                    break
                }
                //亮度
                if rightPanTransitionY > 0 {
                    if rightRect.contains(transitionPoint) {
                        let stepY = transitionPoint.y-rightPanTransitionY
                        let stepDistance = -stepY/aixasYDistance
                        let totalValue = brightnessStart + stepDistance
                        middelPanYEndPostion = Float(totalValue)
                        print("本次调节亮度值:\(middelPanYEndPostion)")
                        UIScreen.main.brightness = totalValue > 1 ? 1 : totalValue
                    }
                    
                }
                break
            }
            if middelPanYEndPostion == 0 {
                setTimeViewHide(b: false)
                if middleView.point(inside: transitionPoint, with: nil) {
                    let xstepDistance = (transitionPoint.x - panTransitionX)*Double(progressStepinDistance)/kScreenWidth
                    let toMimsecond = Int64(xstepDistance)+animationProgressTo
                    if toMimsecond <= totalPostion, toMimsecond >= 0 {
                        middelPanXEndPosition = toMimsecond
                        let toFloat: CGFloat = CGFloat(CGFloat(toMimsecond)/CGFloat(self.totalPostion))*(progressWidth)
                        var position = self.progressBtn.layer.position
                        position.x = 6.5 + toFloat
                        progressXAnimation(to: position, target: self.progressBtn)
                        self.middleTimeLabel.text = "\(dealmimseconds(mimsecond: toMimsecond)):\(dealmimseconds(mimsecond: totalPostion))"
                    }
                }
            }
            
            break
        case .ended:
            if middelPanYEndPostion == 0 {
                if let de = delegate {
                    de.panSeek(to: middelPanXEndPosition)
                    setTimeViewHide(b: true)
                }
            }
            middelPanXEndPosition = 0
            middelPanYEndPostion = 0
            leftPanTransitionY = 0
            rightPanTransitionY = 0
            panTransitionX = 0
            break
        default:
            break
        }
    }
    
    //MARK: 设置事件拖动时middelview的事件显示
    func setTimeViewHide(b: Bool) {
        self.middleTimeLabel.isHidden = b
    }
    
    
    //MARK: -pan代理-
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panges = gestureRecognizer as? UIPanGestureRecognizer {
            let transitionPoint = panges.translation(in: panges.view)
            panTransitionX = transitionPoint.x
            panTransitionY = transitionPoint.y
        }
        return true
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
