//
//  JTVideoPlayerVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/10/31.
//

import UIKit
import AliyunPlayer

class JTVideoPlayerVC: UIViewController {
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
            let urlSource = AVPUrlSource().url(with: "http://video.hzjtyh.com/sv/5303158b-18b8f0b9811/5303158b-18b8f0b9811.mp4?auth_key=1699016793-9086088771a24109ae5335e9f4308440-1111-dfd512dda8a863d0c59123eef1a55be5")
            self.player.setUrlSource(urlSource)
            self.player.playerView = self.playerView
            self.playerView.addSubview(self.controlBar)
            self.player.prepare()
//            let vipSource = AVPVidAuthSource()
//            vipSource.vid = "23bf6b3074a471ee800a6632b68f0102"
//            vipSource.playAuth = "1698948179-064887918b5247dc9292ff9e9694c89b-1111-a754c062004615d56d33351324e2b28a"
//            vipSource.region = "cn-shanghai"
//            self.player.setAuthSource(vipSource)
//            self.player.prepare()
        }
    }
    var playerView: UIView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth))
        v.backgroundColor = HEX_333
        return v
    }()
    
    lazy var controlBar: JTVideoControlBar = {
        let cb = JTVideoControlBar.init(frame: self.playerView.bounds, isMiniScreen: true, totalTime: "00:00")
        cb.playBtn.addTarget(self, action: #selector(playBtnClicked(btn:)), for: .touchUpInside)
        return cb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(playerView)
        view.backgroundColor = HEX_FFF
        initPlayer()
        // Do any additional setup after loading the view.
    }
    
    func initPlayer() {
        self.player.delegate = self
    }
    
    @objc func playBtnClicked(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            self.player.seek(toTime: 0, seekMode: AVPSeekMode.init(0))
            self.player.start()
        } else {
            self.player.pause()
        }
        
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
            playBtnClicked(btn: self.controlBar.playBtn)
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
        if (position != self.controlBar.animationBufferTo) {
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
