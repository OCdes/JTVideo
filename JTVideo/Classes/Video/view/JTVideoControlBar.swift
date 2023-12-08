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
    func requirePopVc()
    func requireStartPictureInPicture()
    func requireAirdropToTV()
}

public class JTVideoControlBar: UIImageView, CAAnimationDelegate {
    
    open weak var delegate: JTVideoControlBarDelegate?
    var isListMode: Bool = false {
        didSet {
            self.topView.isHidden = true
            self.bottomView.isHidden = true
            self.bottomSlider.isHidden = false
            self.isUserInteractionEnabled = false
        }
    }
    // MARK: 控制组件相关控制数据
    //得知缓冲就绪状态
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
    //进度条是图宽度,调整进度时以此宽度为基础
    private var progressWidth: CGFloat {
        return self.isMiniScreen ? (self.frame.size.width - 160 - 13) : (self.frame.size.width - 30)
    }
    //进度条背景视图宽度
    private var progressBgvWidth: CGFloat {
        return isMiniScreen ? self.frame.size.width - 160 : self.frame.size.width - 17
    }
    //当前动画对象
    var currentAnimationTarget: UIView = UIView()
    //当前动画目标位置
    var currentAnimationTo: CGFloat = 0
    //当前屏幕亮度
    private var brightnessStart: CGFloat {
        return UIScreen.main.brightness
    }
    //记录当次播放进度条动画终点
    var animationProgressTo: Int64 = 0
    //记录当次缓冲进度条动画终点
    var animationBufferTo: Int64 = 0
    //记录当次滑动x轴的起点
    var panBeginPositionX: Double = 0
    //记录当次滑动y轴的起点
    var panBeginPositionY: Double = 0
    private final var isMiniScreen: Bool = false
    //视频总时长
    private final var totalTime: String = ""
    //控制栏是否隐藏
    private var barHide = false
    //当视频播放时根据此属性判断是否应该使滑块跟随移动,大于0时表示正在进行拖动不可以跟随移动
    private var panLocationX: Double = 0.0
    //记录middelView左侧发生上下滑时的初始位置
    private var leftPanTransitionY: Double = 0.0
    //记录middelView右侧发生上下滑时的初始位置
    private var rightPanTransitionY: Double = 0.0
    //根据视频总时长得出的屏幕宽度所代表的滑动时可修改的总时长,
    private var progressStepinDistance: Int64 = 0
    //中部位置上当发生触摸事件时的初始点位
    private var middelStartPoint: CGPoint = CGPoint.zero
    //上下滑动时,中部的x轴是否有调整视频进度的动作
    private var middelPanXEndPosition: Int64 = 0
    //左右滑动时,中部的y轴是否有调整亮度或者音量的动作
    private var middelPanYEndPostion: Float = 0
    //middelview滑动响应的音量区域
    private var leftRect: CGRect {
        return CGRect(x: 0, y: 0, width: self.middleView.frame.width/2, height: self.middleView.frame.height)
    }
    //middelview滑动响应的亮度区域
    private var rightRect: CGRect {
        return CGRect(x: self.middleView.frame.width/2, y: 0, width: self.middleView.frame.width/2, height: self.middleView.frame.height)
    }
    // MARK: 视图懒加载
    //顶部操作区
    lazy var topView: UIImageView = {
        let tv = UIImageView()
        tv.isUserInteractionEnabled = true
        tv.image = JTVideoBundleTool.getBundleImg(with: "topMask")
        tv.addSubview(backBtn)
        backBtn.snp_makeConstraints { make in
            make.left.equalTo(tv).offset(15)
            make.bottom.equalTo(tv)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        tv.addSubview(pipBtn)
        pipBtn.snp_makeConstraints { make in
            make.right.equalTo(tv).offset(-15)
            make.centerY.size.equalTo(self.backBtn)
        }
        tv.addSubview(airdropBtn)
        airdropBtn.snp_makeConstraints { make in
            make.right.equalTo(self.pipBtn.snp_left)
            make.size.centerY.equalTo(self.pipBtn)
        }
        
        tv.addSubview(titleLa)
        titleLa.snp_remakeConstraints { make in
            make.left.equalTo(self.backBtn.snp_right).offset(15)
            make.right.equalTo(self.airdropBtn.snp_left)
            make.centerY.equalTo(self.airdropBtn)
        }
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
        return mmv
    }()
    
    lazy var middleTimeLabel: UILabel = {
        let mtl = UILabel()
        mtl.textAlignment = .center
        mtl.text = "00:00/00:00"
        mtl.isHidden = true
        mtl.backgroundColor = HEX_FFF.withAlphaComponent(0.3)
        return mtl
    }()
    
    lazy var numLa: UILabel = {
        let nl = UILabel()
        nl.textColor = HEX_FFF
        nl.font = UIFont.systemFont(ofSize: 16)
        nl.textAlignment = .center
        nl.backgroundColor = HEX_FFF.withAlphaComponent(0.3)
        nl.layer.cornerRadius = 10
        nl.layer.masksToBounds = true
        nl.isHidden = true
        return nl
    }()
    
    lazy var bottomView: UIImageView = {
        let tv = UIImageView()
        tv.isUserInteractionEnabled = true
        tv.image = JTVideoBundleTool.getBundleImg(with: "bottomMask")
        return tv
    }()
    
    lazy var backBtn: UIButton = {
        let bb = UIButton()
        bb.setTitle("back", for: .normal)
        bb.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        bb.setTitleColor(HEX_FFF, for: .normal)
        bb.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
        return bb
    }()
    
    lazy var pipBtn: UIButton = {
        let pb = UIButton()
        pb.setImage(JTVideoBundleTool.getBundleImg(with: "pipIcon"), for: .normal)
        pb.addTarget(self, action: #selector(pipBtnClicked), for: .touchUpInside)
        return pb
    }()
    
    lazy var airdropBtn: UIButton = {
        let ab = UIButton()
        ab.setImage(JTVideoBundleTool.getBundleImg(with: "airdropIcon"), for: .normal)
        ab.addTarget(self, action: #selector(airdropBtnClicked), for: .touchUpInside)
        return ab
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
        pb.extraArea(area: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        let pan = UIPanGestureRecognizer()
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
    
    lazy var bottomSlider: JTVideoProgressSliderView = {
        let bs = JTVideoProgressSliderView(frame: CGRectZero)
        bs.minimumValue = 0
        bs.maximumValue = 1
        bs.isUserInteractionEnabled = false
        bs.isHidden = true
        bs.value = 0
        return bs
    }()
    
    //获取到的系统的音量控制view
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
    
    public func updateViewWithOrientation() {
        let orientation = UIDevice.current.orientation
        if ((orientation == .landscapeLeft || orientation == .landscapeRight) && isMiniScreen) || ((orientation == .portrait || orientation == .portraitUpsideDown) && !isMiniScreen) {
            isMiniScreen = (orientation == .landscapeLeft || orientation == .landscapeRight)
            fullScreenBtnClicked()
        }
        
    }
    
    private func initView() {
        
        //在视频底部区域添加进度条
        
        addSubview(bottomSlider)
        
        //视频top区
        addSubview(topView)
        
        //视频bottom区
        addSubview(bottomView)
        bottomView.addSubview(playBtn)
        bottomView.addSubview(fullscreenBtn)
        bottomView.addSubview(startTimeLa)
        bottomView.addSubview(endTimeLa)
        bottomView.addSubview(progressBgView)
        bottomView.addSubview(progressView)
        bottomView.addSubview(progressLayer)
        bottomView.addSubview(bufferLayer)
        bottomView.addSubview(progressBtn)
        
        //视频middle区
        addSubview(middleView)
        addSubview(middleTimeLabel)
        addSubview(numLa)
    }
    
    
    
    private func updateView() {
        if isMiniScreen {
            setMinView()
        } else {
            setFullView()
        }
        if totalPostion > 0 {
            updateCurrentProgressAndBuffer()
        }
    }
    
    private func updateCurrentProgressAndBuffer() {
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
    }
    
    private func setMinView() {
        
        bottomSlider.snp_remakeConstraints { make in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(1)
        }
        
        self.startTimeLa.textAlignment = .center
        self.endTimeLa.textAlignment = .center
        topView.snp_remakeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(kNavibarHeight)
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
        
        progressView.snp_remakeConstraints { make in
            make.top.equalTo(self.progressBgView).offset(5)
            make.left.equalTo(self.progressBgView).offset(6.5)
            make.right.equalTo(self.progressBgView).offset(-6.5)
            make.height.equalTo(3)
        }
        
        progressLayer.snp_remakeConstraints { make in
            make.left.top.bottom.equalTo(self.progressView)
            make.width.equalTo(0)
        }
        
        bufferLayer.snp_remakeConstraints { make in
            make.left.top.bottom.equalTo(self.progressView)
            make.width.equalTo(0)
        }
        
        progressBtn.snp_remakeConstraints { make in
            make.centerX.equalTo(self.progressLayer.snp_right)
            make.centerY.equalTo(self.progressLayer)
            make.size.equalTo(CGSize(width: 13, height: 13))
        }
        
        middleView.snp_remakeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: kNavibarHeight, left: 0, bottom: 50, right: 0))
        }
        
        middleTimeLabel.snp_remakeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        
        loadingLabel.snp_remakeConstraints { make in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 80, height: 20))
        }
    }
    
    private func setFullView() {
        
        bottomSlider.snp_remakeConstraints { make in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(1)
        }
        
        self.startTimeLa.textAlignment = .left
        self.endTimeLa.textAlignment = .right
        topView.snp_remakeConstraints { make in
            make.left.top.right.equalTo(self)
            make.height.equalTo(kNavibarHeight)
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
        
        progressView.snp_remakeConstraints { make in
            make.top.equalTo(self.progressBgView).offset(5)
            make.left.equalTo(self.progressBgView).offset(6.5)
            make.right.equalTo(self.progressBgView).offset(-6.5)
            make.height.equalTo(3)
        }
        
        progressLayer.snp_remakeConstraints { make in
            make.left.top.bottom.equalTo(self.progressView)
            make.width.equalTo(0)
        }
        
        bufferLayer.snp_remakeConstraints { make in
            make.left.top.bottom.equalTo(self.progressView)
            make.width.equalTo(0)
        }
        
        progressBtn.snp_remakeConstraints { make in
            make.centerX.equalTo(self.progressLayer.snp_right)
            make.centerY.equalTo(self.progressLayer)
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
            make.edges.equalTo(UIEdgeInsets(top: kNavibarHeight, left: 0, bottom: 123, right: 0))
        }
        
        middleTimeLabel.snp_remakeConstraints { make in
            make.left.right.top.bottom.equalTo(self)
        }
        
        loadingLabel.snp_remakeConstraints { make in
            make.center.equalTo(self)
            make.size.equalTo(CGSize(width: 80, height: 20))
        }
    }
    
    //获取系统音量控制组件
    private func dealVolumViewAndAirDrop() {
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
    func progressAnimate(targetLayer: UIView, to: Int64) {
        if to > self.totalPostion {
            return
        }
        self.loadingLabel.isHidden = self.animationBufferTo >= self.animationProgressTo
        
        let toFloat: CGFloat = CGFloat(CGFloat(to)/CGFloat(self.totalPostion))*(progressWidth)
        if targetLayer == self.bufferLayer {
            self.animationBufferTo = to
        } else {
            self.startTimeLa.text = dealmimseconds(mimsecond: to)
            self.animationProgressTo = to
            bottomSlider.value = Float(to)/Float(self.totalPostion)
        }
        progressWidthAnimation(to: toFloat, target: targetLayer)
    }
    //x位置改变动画
    private func progressXAnimation(to: CGPoint, target: UIView) {
        let animationx = CABasicAnimation.init(keyPath: "position")
        animationx.fromValue = NSValue(cgPoint: to)
        animationx.toValue = NSValue(cgPoint: to)
        animationx.duration = 0.3
        animationx.isRemovedOnCompletion = true
        animationx.fillMode = CAMediaTimingFillMode.forwards
        target.layer.add(animationx, forKey: nil)
    }
    //宽度改变动画
    private func progressWidthAnimation(to: CGFloat, target: UIView) {
        UIView.animate(withDuration: 0.3) {
            target.snp_updateConstraints { make in
                make.width.equalTo(to)
            }
        }
    }
    
    private func dealmimseconds (mimsecond: Int64) -> String {
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
    
    @objc func backBtnClicked() {
        if let de = delegate {
            de.requirePopVc()
        }
    }
    
    @objc func pipBtnClicked() {
        if let de = delegate {
            de.requireStartPictureInPicture()
        }
    }
    
    @objc func airdropBtnClicked() {
        if let de = delegate {
            de.requireAirdropToTV()
        }
    }
    
    
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
        self.pipBtn.isHidden = !isMiniScreen
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
        if isListMode {
            return
        }
        if isMiniScreen {
            UIView.animate(withDuration: 0.3) {
                self.topView.snp_updateConstraints { make in
                    make.top.equalTo(self).offset(self.barHide ? -kNavibarHeight : 0)
                }
                
                self.bottomView.snp_updateConstraints { make in
                    make.bottom.equalTo(self).offset(self.barHide ? 50 : 0)
                }
                self.topView.isHidden = self.barHide
                self.bottomView.isHidden = self.barHide
                self.bottomSlider.isHidden = !self.barHide
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.topView.snp_updateConstraints { make in
                    make.top.equalTo(self).offset(self.barHide ? -kNavibarHeight : 0)
                }
                
                self.bottomView.snp_updateConstraints { make in
                    make.bottom.equalTo(self).offset(self.barHide ? 123 : 0)
                }
                self.topView.isHidden = self.barHide
                self.bottomView.isHidden = self.barHide
                self.bottomSlider.isHidden = !self.barHide
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
    //MARK: 进度条滑块拖动事件
    @objc func panGesture(pan: UIPanGestureRecognizer) {
        let state = pan.state
        switch state {
        case .began:
            let positionX = pan.location(in: pan.view?.superview).x
            if let v = pan.view, v == self.progressBtn {
                panBeginPositionX = self.progressBtn.layer.position.x
                setTimeViewHide(b: false)
                panLocationX = positionX
            }
            break
        case .changed:
            let transtionX = pan.translation(in: pan.view).x
            let positionX = pan.location(in: pan.view?.superview).x
            NSLog("向%@滑动了,滑动距离:%f;中心点水:%f", (transtionX < 0) ? "左" : "右", transtionX,positionX)
            if let v = pan.view, v == self.progressBtn {
                let offsetx = positionX - panLocationX
                let totalProgress = self.progressLayer.frame.width + offsetx
                if totalProgress < 0 || totalProgress > progressWidth{
                    
                } else {
                    var position = self.progressBtn.layer.position
                    position.x += offsetx
                    progressXAnimation(to: position, target: self.progressBtn)
                    let toTime = Int64(Float(totalProgress/progressWidth)*Float(totalPostion))
                    self.middleTimeLabel.text = "\(dealmimseconds(mimsecond: toTime)):\(dealmimseconds(mimsecond: totalPostion))"
                }
                
            }
            break
        case .ended:
            let positionX = pan.location(in: pan.view?.superview).x
            if let v = pan.view, v == self.progressBtn {
                let offsetx = positionX - panLocationX
                let totalProgress = self.progressLayer.frame.width + offsetx
                if totalProgress < 0 || totalProgress > progressWidth{
                    
                } else {
                    let seekTo = CGFloat(self.totalPostion)*CGFloat(totalProgress)/self.progressWidth
                    if let de = self.delegate {
                        de.panSeek(to: Int64(seekTo))
                    }
                }
            }
            panBeginPositionX = 0
            panLocationX = 0
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
            }
            if rightRect.contains(point) {
                rightPanTransitionY = point.y
            }
            
            let location = pan.location(in: pan.view)
            panLocationX = location.x
            
            break
            
        case .changed:
            let transitionPoint = pan.location(in: pan.view)
            let width = transitionPoint.x - middelStartPoint.x
            let height = transitionPoint.y - middelStartPoint.y
            let isUpdownPan = abs(height/width) > 1
            if isUpdownPan && middelPanXEndPosition == 0 {
                //音量
                if  leftPanTransitionY > 0 {
                    if leftRect.contains(transitionPoint) {
                        let stepY = transitionPoint.y-leftPanTransitionY
                        let stepDistance = -Float(stepY/(self.middleView.frame.height))
                        if let vv = volumeView {
                            numLa.isHidden = false
                            let value = (vv.value + stepDistance) > 1 ? 1 : ((vv.value + stepDistance) < 0 ? 0 : (vv.value + stepDistance))
                            middelPanYEndPostion = (vv.value + stepDistance)
                            let totalValue = abs(value) > 1 ? 1 : (value)
                            vv.setValue(totalValue, animated: true)
                            numLa.text = String(format: "音量:%d%", Int(totalValue*100))
                        }
                    }
                    break
                }
                //亮度
                if rightPanTransitionY > 0 {
                    if rightRect.contains(transitionPoint) {
                        numLa.isHidden = false
                        let stepY = transitionPoint.y-rightPanTransitionY
                        let stepDistance = -stepY/self.middleView.frame.height
                        let totalValue = (brightnessStart + stepDistance) > 1 ? 1 : (brightnessStart + stepDistance)
                        middelPanYEndPostion = Float(totalValue)
                        UIScreen.main.brightness = totalValue
                        numLa.text = String(format: "亮度:%d%", Int(totalValue*100))
                    }
                }
                break
            }
            if middelPanYEndPostion == 0 {
                setTimeViewHide(b: false)
                if middleView.point(inside: transitionPoint, with: nil) {
                    let xstepDistance = (transitionPoint.x - panLocationX)*Double(progressStepinDistance)/kScreenWidth
                    let xstepCGfloat = xstepDistance*self.progressWidth/CGFloat(totalPostion)
                    let toMimsecond = Int64(xstepDistance)+animationProgressTo
                    if toMimsecond > totalPostion || toMimsecond < 0 {} else {
                        middelPanXEndPosition = toMimsecond
                        var position = self.progressBtn.layer.position
                        position.x += xstepCGfloat
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
            panLocationX = 0
            numLa.isHidden = true
            break
        default:
            break
        }
    }
    
    //MARK: 设置事件拖动时middelview的事件显示
    private func setTimeViewHide(b: Bool) {
        self.middleTimeLabel.isHidden = b
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
