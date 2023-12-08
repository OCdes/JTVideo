//
//  JTPlayerView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/11/9.
//

import UIKit
import AliyunPlayer


protocol JTPlayerViewDelegate: NSObjectProtocol {
    func requireFullScreen(fullScreen: Bool)
    func playerWillEnterPictureInPicture()
    func playerWillStopPictureInPicture(completionHandler: ((Bool) -> Void)?)
    func requirePopVC()
}

@objc
open class JTPlayerView: UIView {
    weak var delegate: JTPlayerViewDelegate?
    var isFullScreen: Bool = false
    private var isPipPaused: Bool = false
    private var currentPlayerStatus: AVPStatus = AVPStatus(0)
    private weak var pipController: AVPictureInPictureController?
    private var fullVC: UIViewController?
    private var currentPosition: Int64 = 0
    private lazy var hwscaleSize: CGSize = {
        let hwscale = CGFloat(player.height)/CGFloat(player.width)
        if hwscale >= 1 {
            let size = CGSize(width: self.frame.height/hwscale, height: self.frame.height)
            return size
        } else {
            let size = CGSize(width: self.frame.width, height: self.frame.width*hwscale)
            return size
        }
    }()
    private var isForeground: Bool = true
    //播放地址
    var urlSource: String = "" {
        didSet {
            let urlS = AVPUrlSource()
            urlS.url(with: urlSource)
            urlS.definitions = "AUTO"
            self.player.setUrlSource(urlS)
            self.player.prepare()
        }
    }
    
    lazy var player: AliPlayer = {
        let p = AliPlayer.init()
        return p!
        
    }()
    
    var showLayer: UIView = UIView() {
        didSet {
            showLayer.addSubview(self)
            self.snp_makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
    }
    
    var playerSurface: UIView = {
        let ps = UIView()
        return ps
    }()
    
    lazy var controlBar: JTVideoControlBar = {
        let cb = JTVideoControlBar.init(frame: CGRectZero, isMiniScreen: true, totalTime: "00:00")
        cb.delegate = self
        cb.backBtn.isHidden = true
        cb.airdropBtn.isHidden = true
        //        cb.pipBtn.isHidden = true
        return cb
    }()
    
    @objc override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
        addSubview(playerSurface)
        playerSurface.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        player.delegate = self
        player.playerView = self.playerSurface
        player.setPictureinPictureDelegate(self)
        addSubview(controlBar)
        controlBar.snp_makeConstraints { make in
            make.top.left.bottom.right.equalTo(self)
        }
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(appenterBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appenterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appenterBackground() {
        isForeground = false
        if !isFullScreen {
            playerSurface.snp_remakeConstraints { make in
                make.center.equalTo(self)
                make.size.equalTo(self.hwscaleSize)
            }
        } 
        if pipController == nil && currentPlayerStatus == AVPStatus(3) {
            player.pause()
        }
    }
    @objc func appenterForeground() {
        isForeground = true
        if !isFullScreen {
            playerSurface.snp_remakeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
        }
        
        if pipController == nil && currentPlayerStatus == AVPStatus(4) {
            player.start()
        }
    }
    
    @objc func updateControlBar() {
        
    }
    
    func stopPip() {
        if pipController != nil {
            pipController?.stopPictureInPicture()
        }
    }
    
    
    //播放控件的play按钮被点击了
    func playBtnClicked(btn: UIButton) {
        if btn.isSelected {
            self.player.start()
            if #available(iOS 15, *) {
                self.player.setPictureInPictureEnable(true)
            }
        } else {
            self.player.pause()
            if self.pipController != nil {
                if #available(iOS 15, *) {
                    self.player.setPictureInPictureEnable(false)
                }
            }
            
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func destroyPlayerView() {
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        player.pause()
        player.stop()
        player.playerView = nil
        player.destroy()
    }
    
    func pausePlayer() {
        self.controlBar.playerBtnClicked()
    }
    
    
    
}

extension JTPlayerView: AVPDelegate, AliPlayerPictureInPictureDelegate {
    //MARK: 播放器回调
    /**
     @brief 错误代理回调
     @param player 播放器player指针
     @param errorModel 播放器错误描述，参考AliVcPlayerErrorModel
     */
    public func onError(_ player: AliPlayer!, errorModel: AVPErrorModel!) {
        // 提示错误，及stop播放
    }
    
    /**
     @brief 播放器事件回调
     @param player 播放器player指针
     @param eventType 播放器事件类型，@see AVPEventType
     */
    public func onPlayerEvent(_ player: AliPlayer!, eventType: AVPEventType) {
        switch eventType {
        case AVPEventPrepareDone:
            self.controlBar.totalPostion = self.player.duration
            self.controlBar.prepared = true
            self.player.seek(toTime: 0, seekMode: AVPSeekMode.init(0))
            break
        case AVPEventAutoPlayStart:
            break
        case AVPEventFirstRenderedStart:
            // 首帧显示
            break
        case AVPEventCompletion:
            // 播放完成
            if pipController != nil {
                isPipPaused = true
                if #available(iOS 15.0, *) {
                    pipController?.invalidatePlaybackState()
                } else {
                    // Fallback on earlier versions
                }
            }
            self.player.seek(toTime: 0, seekMode: AVPSeekMode.init(0))
            self.controlBar.playerBtnClicked()
            if #available(iOS 15.0, *) {
                self.pipController?.invalidatePlaybackState()
            } else {
                // Fallback on earlier versions
            }
            break
        case AVPEventLoadingStart:
            // 缓冲开始
            break
        case AVPEventLoadingEnd:
            // 缓冲完成
            break
        case AVPEventSeekEnd:
            // 跳转完成
            if #available(iOS 15.0, *) {
                self.pipController?.invalidatePlaybackState()
            } else {
                // Fallback on earlier versions
            }
            break
        case AVPEventLoopingStart:
            // 循环播放开始
            break
        default:
            break
        }
    }
    /**
     @brief 视频当前播放位置回调
     @param player 播放器player指针
     @param position 视频当前播放位置
     */
    public func onCurrentPositionUpdate(_ player: AliPlayer!, position: Int64) {
        currentPosition = position
        // 更新进度条
        if position != self.controlBar.animationProgressTo {
            self.controlBar.progressAnimate(targetLayer: self.controlBar.progressLayer, to: position)
        }
        
    }
    
    /**
     @brief 视频缓存位置回调
     @param player 播放器player指针
     @param position 视频当前缓存位置
     */
    public func onBufferedPositionUpdate(_ player: AliPlayer!, position: Int64) {
        // 更新缓冲进度
        if (position > self.controlBar.animationBufferTo) {
            self.controlBar.progressAnimate(targetLayer: self.controlBar.bufferLayer, to: position)
        }
    }
    
    /**
     @brief 获取track信息回调
     @param player 播放器player指针
     @param info track流信息数组参考AVPTrackInfo
     */
    public func onTrackReady(_ player: AliPlayer!, info: [AVPTrackInfo]!) {
        // 获取多码率信息
        
    }
    
    /**
     @brief 字幕显示回调
     @param player 播放器player指针
     @param index 字幕显示的索引号
     @param subtitle 字幕显示的字符串
     */
    public func onSubtitleShow(_ player: AliPlayer!, trackIndex: Int32, subtitleID: Int, subtitle: String!) {
        // 获取字幕进行显示
    }
    
    /**
     @brief 字幕隐藏回调
     @param player 播放器player指针
     @param index 字幕显示的索引号
     */
    public func onSubtitleHide(_ player: AliPlayer!, trackIndex: Int32, subtitleID: Int) {
        // 隐藏字幕
    }
    
    /**
     @brief 获取截图回调
     @param player 播放器player指针
     @param image 图像
     */
    public func onCaptureScreen(_ player: AliPlayer!, image: UIImage!) {
        // 预览，保存截图
    }
    
    /**
     @brief track切换完成回调
     @param player 播放器player指针
     @param info 切换后的信息参考AVPTrackInfo
     */
    public func onTrackChanged(_ player: AliPlayer!, info: AVPTrackInfo!) {
        // 切换码率结果通知
    }
    //MARK: 画中画代理
    
    
    public func onPlayerStatusChanged(_ player: AliPlayer!, oldStatus: AVPStatus, newStatus: AVPStatus) {
        self.currentPlayerStatus = newStatus
        if pipController != nil {
            if #available(iOS 15.0, *) {
                pipController?.invalidatePlaybackState()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    /*
     @brief 画中画将要启动
     @param pictureInPictureController 画中画控制器
     */
    public func pictureInPictureControllerWillStartPicture(inPicture pictureInPictureController: AVPictureInPictureController?) {
        if pipController == nil {
            pipController = pictureInPictureController
        }
        self.isPipPaused = currentPlayerStatus != AVPStatus(3)
        if #available(iOS 15.0, *) {
            pictureInPictureController?.invalidatePlaybackState()
        } else {
            // Fallback on earlier versions
        }
        if let de = delegate, isForeground == true {
            de.playerWillEnterPictureInPicture()
        }
    }
    /**
     @brief 画中画准备停止
     @param pictureInPictureController 画中画控制器
     */
    public func pictureInPictureControllerWillStopPicture(inPicture pictureInPictureController: AVPictureInPictureController?) {
        self.isPipPaused = false
        if #available(iOS 15.0, *) {
            pictureInPictureController?.invalidatePlaybackState()
        } else {
            // Fallback on earlier versions
        }
    }
    //画中画已经关闭
    public func pictureInPictureControllerDidStopPicture(inPicture pictureInPictureController: AVPictureInPictureController?) {
        if isForeground == true {
            if !isFullScreen {
                playerSurface.snp_remakeConstraints { make in
                    make.edges.equalTo(UIEdgeInsets.zero)
                }
            }
            if #available(iOS 15.0, *) {
                pictureInPictureController?.invalidatePlaybackState()
            } else {
                // Fallback on earlier versions
            }
            
        }
        
    }
    
    //在画中画即将停止前,通知恢复用户交互接口,这里恢复playerview的布局
    public func picture(_ pictureInPictureController: AVPictureInPictureController?, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: ((Bool) -> Void)? = nil) {
        if let de = delegate, isForeground == true {
            if !isFullScreen {
                playerSurface.snp_remakeConstraints { make in
                    make.edges.equalTo(UIEdgeInsets.zero)
                }
            }
            de.playerWillStopPictureInPicture(completionHandler: completionHandler)
        }
    }
    
    /**
     @brief 在画中画停止前告诉代理恢复用户接口
     @param pictureInPictureController 画中画控制器
     @param completionHandler 调用并传值YES以允许系统结束恢复播放器用户接口
     */
    public func picture(_ pictureInPictureController: AVPictureInPictureController?, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void?) {
        if pipController != nil {
            pipController = nil
        }
        completionHandler(true)
    }
    //画中画可调整时间范围
    public func pictureInPictureControllerTimeRange(forPlayback pictureInPictureController: AVPictureInPictureController, layerTime: CMTime) -> CMTimeRange {
        let current64 = CMTimeGetSeconds(layerTime)
        var start: Float64 = 0
        var end: Float64 = 0
        
        if currentPosition <= self.player.duration {
            let curPostion = currentPosition/1000
            let durantion = self.player.duration/1000
            let interval = durantion - curPostion
            start = current64 - Float64(curPostion)
            end = current64 + Float64(interval)
            
            let startTm = CMTimeMakeWithSeconds(start, preferredTimescale: layerTime.timescale)
            let endTm = CMTimeMakeWithSeconds(end, preferredTimescale: layerTime.timescale)
            
            return CMTimeRange(start: startTm, end: endTm)
        } else {
            return CMTimeRange(start: CMTime.negativeInfinity, end: CMTime.positiveInfinity)
        }
    }
    
    public func picture(inPictureControllerIsPlaybackPaused pictureInPictureController: AVPictureInPictureController) -> Bool {
        if pipController == nil {
            pipController = pictureInPictureController
        }
        return self.isPipPaused
    }
    //画中画快进十秒或者快退十秒的回调
    public func picture(_ pictureInPictureController: AVPictureInPictureController, skipByInterval skipInterval: CMTime, completionHandler: @escaping () -> Void) {
        let skipTime: Int64 = skipInterval.value/Int64(skipInterval.timescale)
        var skipPosition = currentPosition + skipTime*1000
        if skipPosition < 0 {
            skipPosition = 0
        }
        if skipPosition > self.player.duration {
            skipPosition = self.player.duration
        }
        self.player.seek(toTime: skipPosition, seekMode: AVPSeekMode(rawValue: 0))
        if #available(iOS 15.0, *) {
            pictureInPictureController.invalidatePlaybackState()
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    public func picture(_ pictureInPictureController: AVPictureInPictureController, setPlaying playing: Bool) {
        if !playing {
            self.player.pause()
            self.controlBar.playBtn.isSelected = false
            self.isPipPaused = true
        } else {
            if currentPlayerStatus == AVPStatus(6) {
                self.player.seek(toTime: 0, seekMode: AVPSeekMode(0))
            }
            self.player.start()
            self.controlBar.playBtn.isSelected = true
            self.isPipPaused = false
        }
        if #available(iOS 15.0, *) {
            pictureInPictureController.invalidatePlaybackState()
        } else {
            // Fallback on earlier versions
        }
    }
    
}

extension JTPlayerView:JTVideoControlBarDelegate {
    public func requirePopVc() {
        if let de = delegate {
            de.requirePopVC()
        }
    }
    
    public func requireStartPictureInPicture() {
        if self.controlBar.prepared {
            if #available(iOS 15, *) {
                if let pip = self.pipController {
                    if !isFullScreen {
                        playerSurface.snp_remakeConstraints { make in
                            make.center.equalTo(self)
                            make.size.equalTo(self.hwscaleSize)
                        }
                    }
                    pip.startPictureInPicture()
                }
                
            }
        }
    }
    
    public func requireAirdropToTV() {
        
    }
    
    public func playerBtnisClicked(btn: UIButton) {
        playBtnClicked(btn: btn)
    }
    
    public func panSeek(to: Int64) {
        self.player.seek(toTime: to, seekMode: AVPSeekMode.init(0))
    }
    
    public func fullScreen(isMini: Bool) {
        isFullScreen = !isMini
        if fullVC != nil {
            fullVC?.dismiss(animated: true)
            fullVC = nil
        } else {
            if let vc = APPWINDOW.rootViewController {
                if let nav = vc as? UINavigationController {
                    if let nowVC = nav.viewControllers.last {
                        let enterFullVC = JTPlayerFullVC()
                        enterFullVC.playerSurface = self
                        enterFullVC.modalPresentationStyle = .fullScreen
                        enterFullVC.transitioningDelegate = self
                        fullVC = enterFullVC
                        nowVC.present(enterFullVC, animated: true)
                    }
                } else {
                    let enterFullVC = JTPlayerFullVC()
                    enterFullVC.playerSurface = self
                    enterFullVC.modalPresentationStyle = .fullScreen
                    enterFullVC.transitioningDelegate = self
                    fullVC = enterFullVC
                    vc.present(enterFullVC, animated: true)
                }
            }
        }
    }
}

extension JTPlayerView: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JTEnterPlayerFullTransition(playerView: self)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JTExitPlayerFullTransition(playerView: self)
    }
}
