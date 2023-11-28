//
//  JTListVideoPlayerView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/11/22.
//

import UIKit
import AliyunPlayer
@objc

protocol JTListVideoPlayerViewDelegate: NSObjectProtocol {
    func needLoadMoreVideoList(listView: UIScrollView)
    func needRefreshVideoList(listView: UIScrollView)
}
//短视频播放组件
open class JTListVideoPlayerView: UIView {
    weak var delegate: JTListVideoPlayerViewDelegate?
    private var dataArr: [String] = []
    private var currentIndex: Int = 0
    
    lazy var player: AliListPlayer = {
        let p = AliListPlayer()
        p?.scalingMode = AVPScalingMode(2)
        p?.preloadCount = 3
        p!.delegate = self
        p!.isAutoPlay = true
        p!.isLoop = true
        p!.stsPreloadDefinition = "HD"
        return p!
    }()
    
    lazy var listView: UITableView = {
        let pv = UITableView(frame: CGRectZero, style: .grouped)
        pv.delegate = self
        pv.dataSource = self
        pv.register(JTListVideoTableCell.self, forCellReuseIdentifier: "JTListVideoTableCell")
        if #available(iOS 15.0, *) {
            pv.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        pv.isPagingEnabled = true
        pv.tableHeaderView = nil
        pv.bounces = true
        return pv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(listView)
        listView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        listView.reloadData()
    }
    
    public func addResource(urls:[String]) {
        for urlStr in urls {
            if !(dataArr as NSArray).contains(urlStr) {
                dataArr.append(urlStr)
                self.player.addUrlSource(urlStr, uid: urlStr)
                self.listView.reloadData()
            }
        }
        self.player.move(to: urls[0])
    }
    func currentPlayCell()->JTListVideoTableCell? {
        let cell = self.listView.cellForRow(at: IndexPath(row: self.currentIndex, section: 0))
        return cell as? JTListVideoTableCell
    }
    
    func nextPlayCell()->JTListVideoTableCell? {
        let nextIndex = currentIndex + 1
        if nextIndex >= self.dataArr.count {
            return nil
        }
        
        if let cell = self.listView.cellForRow(at: IndexPath(row: nextIndex, section: 0)) as? JTListVideoTableCell {
            return cell
        }
        return nil
    }
    
    func lastPlayCell()->JTListVideoTableCell? {
        let nextIndex = currentIndex - 1
        if nextIndex < 0 {
            return nil
        }
        
        if let cell = self.listView.cellForRow(at: IndexPath(row: nextIndex, section: 0)) as? JTListVideoTableCell {
            return cell
        }
        return nil
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func moveToNext() {
        if nextPlayCell() == nil {
            return
        }
        self.currentIndex = self.currentIndex+1
        if let preplayer = self.player.getPreRenderPlayer(),let nc = nextPlayCell() {
            preplayer.playerView = nc.coverImgv
            preplayer.prepare()
            self.player.moveToNextWithPrerendered()
        } else {
            self.player.moveToNext()
        }
    }
    
    public func moveToLast() {
        if lastPlayCell() == nil {
            return
        }
        self.currentIndex = self.currentIndex-1
        self.player.moveToPre()
    }
    
    func destroyPlyerView() {
        self.player.stop()
        self.player.playerView = nil
        self.player.destroy()
    }
    
    deinit {
        
    }
    
}

extension JTListVideoPlayerView: AVPDelegate {
    
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
            if let cc = currentPlayCell() {
                cc.controlBar.progressMaxValue = Float(self.player.duration)
                self.player.playerView = cc.coverImgv
            }
            break
        case AVPEventAutoPlayStart:
            break
        case AVPEventFirstRenderedStart:
            // 首帧显示
            break
        case AVPEventCompletion:
            // 播放完成
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
    public func onCurrentPositionUpdate(_ player: AliPlayer!, position: Int64) {
        // 更新进度条
        if let cc = currentPlayCell() {
            cc.controlBar.progressValue = Float(position)
        }
        
    }
    
    /**
     @brief 视频缓存位置回调
     @param player 播放器player指针
     @param position 视频当前缓存位置
     */
    public func onBufferedPositionUpdate(_ player: AliPlayer!, position: Int64) {
        // 更新缓冲进度
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
    
}

extension JTListVideoPlayerView:  UITableViewDataSource, UITableViewDelegate, JTVideoListPlayerControlBarDelegate {
    
    // MARK: delegate
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.listView.frame.height
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JTListVideoTableCell", for: indexPath) as! JTListVideoTableCell
        cell.coverImgv.kf.setImage(with: URL(string: "\(dataArr[indexPath.row])?x-oss-process=video/snapshot,t_1000,m_fast"))
        cell.controlBar.delegate = self
        return cell
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let cc = currentPlayCell() {
            cc.controlBar.progressValue = 0
        }
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexFloat = CGFloat(scrollView.contentOffset.y/self.listView.frame.height)
        let indexInt = Int(indexFloat)
        if indexInt - currentIndex == 1 {
            moveToNext()
        } else if indexInt - currentIndex == -1 {
            moveToLast()
        }
    }
    
    public func seekToPosition(position: Int64) {
        self.player.seek(toTime: position, seekMode: AVPSeekMode(1))
    }
    
}


class JTListVideoTableCell: UITableViewCell {
    lazy var coverImgv: UIImageView = {
        let cbv = UIImageView()
        cbv.contentMode = .scaleAspectFill
        cbv.clipsToBounds = true
        return cbv
    }()
    
    lazy var controlBar: JTVideoListPlayerControlBar = {
        let cb = JTVideoListPlayerControlBar(frame: CGRectZero)
        return cb
    }()
    
    lazy var playIcon: UIImageView = {
        let pi = UIImageView()
        pi.image = JTVideoBundleTool.getBundleImg(with: "playIcon")
        pi.isHidden = true
        return pi
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.black
        contentView.addSubview(coverImgv)
        coverImgv.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        contentView.addSubview(controlBar)
        controlBar.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        contentView.addSubview(playIcon)
        playIcon.snp_makeConstraints { make in
            make.center.equalTo(self)
            make.size.equalTo(CGSizeMake(50, 50))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
