//
//  JTVideoPlayerVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/10/31.
//

import UIKit
import AliyunPlayer

class JTVideoPlayerVC: UIViewController, JTVideoControlBarDelegate {
    
    var ori: UIInterfaceOrientationMask = .portrait {
        didSet {
            if ori.contains(.portrait) {
                
            } else {
                UIDevice.current.setValue(UIInterfaceOrientationMask.landscapeLeft, forKey: "orientation")
            }
        }
    }
    
    var player: AliPlayer = {
        let p = AliPlayer.init()
        return p!
    }()
    
    var playBtn: UIButton = {
        let pb = UIButton()
        pb.setTitle("播放", for: .normal)
        pb.setTitle("暂停", for: .selected)
        return pb
    }()
    
    var model: ViewHomeListModel = ViewHomeListModel() {
        didSet {
            let urlSource = AVPUrlSource().url(with: "http://player.alicdn.com/video/aliyunmedia.mp4")
            self.player.setUrlSource(urlSource)
            self.player.playerView = self.playerView
            self.player.scalingMode = AVPScalingMode(1)
            self.playerView.addSubview(self.controlBar)
            self.controlBar.snp_makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets.zero)
            }
            self.player.prepare()
        }
    }
    
    var playerView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth))
        v.backgroundColor = UIColor.green
        return v
    }()
    
    lazy var controlBar: JTVideoControlBar = {
        let cb = JTVideoControlBar.init(frame: self.playerView.bounds, isMiniScreen: true, totalTime: "00:00")
        cb.delegate = self
        return cb
    }()
    
    
    var playerOrignCenter: CGPoint = CGPoint.zero
    var playerOriginSize: CGSize = CGSize.zero
    var isFullScreen: Bool = false
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return self.isFullScreen ? true : false
    }
    
    // MARK: view即将旋转时,修改playview的布局
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("当前屏幕高度:\(kScreenHeight);当前屏幕宽度:\(kScreenWidth)")
        if !isFullScreen {
            self.playerView.snp_remakeConstraints({ make in
                make.left.top.right.equalTo(self.view)
                make.height.equalTo(kScreenWidth)
            })
        } else {
            self.playerView.snp_remakeConstraints({ make in
                make.edges.equalTo(UIEdgeInsets.zero)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(playerView)
        playerView.snp_makeConstraints { make in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(kScreenWidth)
        }
        view.backgroundColor = HEX_FFF
        initPlayer()
        // Do any additional setup after loading the view.
    }
    
    func initPlayer() {
        self.player.delegate = self
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc func deviceOrientationDidChange() {
        if UIDevice.current.orientation.isPortrait {
            self.playerView.snp_remakeConstraints({ make in
                make.left.top.right.equalTo(self.view)
                make.height.equalTo(kScreenWidth)
            })
        } else {
            self.playerView.snp_remakeConstraints({ make in
                make.edges.equalTo(UIEdgeInsets.zero)
            })
        }
    }
    
    //播放控件的play按钮被点击了
    func playBtnClicked(btn: UIButton) {
        if btn.isSelected {
            self.player.start()
        } else {
            self.player.pause()
        }
    }
    
    // MARK: ControlBarDelegate
    func fullScreen(isMini: Bool) {
        isFullScreen = !isMini
        setOrientation(isFullScreen: !isMini)
    }
    
    func panSeek(to: Int64) {
        self.player.seek(toTime: to, seekMode: AVPSeekMode.init(0))
    }
    
    func playerBtnisClicked(btn: UIButton) {
        playBtnClicked(btn: btn)
    }
    // MARK: 设置屏幕旋转
    func setOrientation(isFullScreen: Bool) {
        if #available(iOS 16.0, *) {
            setNeedsUpdateOfSupportedInterfaceOrientations()
            let arr = (UIApplication.shared.connectedScenes as NSSet).allObjects
            if  let firstWindowScene = arr.first as? UIWindowScene {
                let geometryPerferenceIOS = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: isFullScreen ? .landscapeLeft : .portrait)
                firstWindowScene.requestGeometryUpdate(geometryPerferenceIOS) { error in
                    NSLog("%@", error.localizedDescription)
                }
            }
        } else {
            let orientation: UIInterfaceOrientation = isFullScreen ? .landscapeLeft : .portrait
            UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        }
    }
    
    deinit {
        player.pause()
        player.stop()
        player.playerView = nil
        player.destroy()
    }
}



extension JTVideoPlayerVC: AVPDelegate {
    /**
     @brief 错误代理回调
     @param player 播放器player指针
     @param errorModel 播放器错误描述，参考AliVcPlayerErrorModel
     */
    func onError(_ player: AliPlayer!, errorModel: AVPErrorModel!) {
        // 提示错误，及stop播放
    }
    
    /**
     @brief 播放器事件回调
     @param player 播放器player指针
     @param eventType 播放器事件类型，@see AVPEventType
     */
    func onPlayerEvent(_ player: AliPlayer!, eventType: AVPEventType) {
        switch eventType {
        case AVPEventPrepareDone:
            self.controlBar.totalPostion = self.player.duration
            self.controlBar.prepared = true
            break
        case AVPEventAutoPlayStart:
            break
        case AVPEventFirstRenderedStart:
            // 首帧显示
            break
        case AVPEventCompletion:
            // 播放完成
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
    func onCurrentPositionUpdate(_ player: AliPlayer!, position: Int64) {
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
    func onBufferedPositionUpdate(_ player: AliPlayer!, position: Int64) {
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
    func onTrackReady(_ player: AliPlayer!, info: [AVPTrackInfo]!) {
        // 获取多码率信息
        
    }
    
    /**
     @brief 字幕显示回调
     @param player 播放器player指针
     @param index 字幕显示的索引号
     @param subtitle 字幕显示的字符串
     */
    func onSubtitleShow(_ player: AliPlayer!, trackIndex: Int32, subtitleID: Int, subtitle: String!) {
        // 获取字幕进行显示
    }
    
    /**
     @brief 字幕隐藏回调
     @param player 播放器player指针
     @param index 字幕显示的索引号
     */
    func onSubtitleHide(_ player: AliPlayer!, trackIndex: Int32, subtitleID: Int) {
        // 隐藏字幕
    }
    
    /**
     @brief 获取截图回调
     @param player 播放器player指针
     @param image 图像
     */
    func onCaptureScreen(_ player: AliPlayer!, image: UIImage!) {
        // 预览，保存截图
    }
    
    /**
     @brief track切换完成回调
     @param player 播放器player指针
     @param info 切换后的信息参考AVPTrackInfo
     */
    func onTrackChanged(_ player: AliPlayer!, info: AVPTrackInfo!) {
        // 切换码率结果通知
    }
    
}
