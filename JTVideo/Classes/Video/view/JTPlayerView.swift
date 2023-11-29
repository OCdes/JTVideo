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
    func requirePopVC()
}


open class JTPlayerView: UIView {
    weak var delegate: JTPlayerViewDelegate?
    var isFullScreen: Bool = false
    private var isPipPaused: Bool = false
    private var currentPlayerStatus: AVPStatus = AVPStatus(0)
    private weak var pipController: AVPictureInPictureController?
    private var currentPosition: Int64 = 0
    private var originCenter: CGPoint = CGPoint.zero
    
    //播放地址
    var urlSource: String = "" {
        didSet {
            let urlSource = AVPUrlSource()
            urlSource.url(with: "http://player.alicdn.com/video/aliyunmedia.mp4")
            urlSource.definitions = "AUTO"
            self.player.setUrlSource(urlSource)
            self.player.prepare()
        }
    }
    
    lazy var player: AliPlayer = {
        let p = AliPlayer.init()
        p!.scalingMode = AVPScalingMode(rawValue: 1)
        return p!
        
    }()
    
    var playerSurface: UIView = {
        let ps = UIView()
        return ps
    }()
    
    lazy var controlBar: JTVideoControlBar = {
        let cb = JTVideoControlBar.init(frame: CGRectZero, isMiniScreen: true, totalTime: "00:00")
        cb.delegate = self
        return cb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.cyan
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
        NotificationCenter.default.addObserver(self, selector: #selector(updateControlBar), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc func updateControlBar() {
        self.controlBar.updateViewWithOrientation()
    }
    
    
    //播放控件的play按钮被点击了
    func playBtnClicked(btn: UIButton) {
        if btn.isSelected {
            self.player.start()
        } else {
            self.player.pause()
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
    
    deinit {
        
    }
    
}

extension JTPlayerView: AVPDelegate, AliPlayerPictureInPictureDelegate {
    //MARK: 播放器回调
    /**
     @brief 错误代理回调
     @param player 播放器player指针
     @param errorModel 播放器错误描述，参考AliVcPlayerErrorModel
     */
    private func onError(_ player: AliPlayer!, errorModel: AVPErrorModel!) {
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
                    pipController!.invalidatePlaybackState()
                } else {
                    // Fallback on earlier versions
                }
            }
            self.player.seek(toTime: 0, seekMode: AVPSeekMode.init(0))
            self.controlBar.playBtn.isSelected = false
            break
        case AVPEventLoadingStart:
            // 缓冲开始
            break
        case AVPEventLoadingEnd:
            // 缓冲完成
            break
        case AVPEventSeekEnd:
            // 跳转完成
            if pipController != nil {
                if #available(iOS 15.0, *) {
                    pipController!.invalidatePlaybackState()
                } else {
                    // Fallback on earlier versions
                }
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
        if newStatus == AVPStatus(rawValue: 3) {
            if #available(iOS 15, *) {
                self.player.setPictureInPictureEnable(true)
            }
        }
        if newStatus == AVPStatus(rawValue: 4) || newStatus == AVPStatus(rawValue: 5) || newStatus == AVPStatus(rawValue: 6) {
            if #available(iOS 15, *) {
                self.player.setPictureInPictureEnable(false)
            }
        } 
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
    }
    /**
     @brief 画中画准备停止
     @param pictureInPictureController 画中画控制器
     */
    public func pictureInPictureControllerWillStopPicture(inPicture pictureInPictureController: AVPictureInPictureController?) {
        self.isPipPaused = false
        pausePlayer()
         if #available(iOS 15.0, *) {
            pictureInPictureController?.invalidatePlaybackState()
        } else {
            // Fallback on earlier versions
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
    
    /**
     @brief 画中画打开失败
     @param pictureInPictureController 画中画控制器
     */
    public func picture(_ pictureInPictureController: AVPictureInPictureController?, failedToStartPictureInPictureWithError error: Error?) {
        
    }
    
    public func picture(inPictureControllerIsPlaybackPaused pictureInPictureController: AVPictureInPictureController) -> Bool {
        return self.isPipPaused
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
                
                if let de = delegate {
                    de.requirePopVC()
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
        if let de = self.delegate {
            de.requireFullScreen(fullScreen: isFullScreen)
        }
    }
    
    
}
