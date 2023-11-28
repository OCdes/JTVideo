//
//  JTShortVideoVC.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/11/24.
//

import UIKit

open class JTShortVideoVC: UIViewController, JTListVideoPlayerViewDelegate {
    
    
    lazy var playerView: JTListVideoPlayerView = {
        let pv = JTListVideoPlayerView(frame: CGRectZero)
        pv.delegate = self
        return pv
    }()
    
    var dataArr = ["https://jtyhresource.oss-cn-qingdao.aliyuncs.com/2155/users/13194403361/video/bdf26641fc3144d7b20d03a57259a9a1.mp4","https://jtyhresource.oss-cn-qingdao.aliyuncs.com/2153/users/18858309145/video/b099bcfe540d40539b5ca19357a51b5b.mp4","https://jtyhresource.oss-cn-qingdao.aliyuncs.com/2153/users/18858309145/video/fab63059c03840a9b738671ec31b3716.mp4"]
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.addSubview(playerView)
        playerView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }

        playerView.addResource(urls: dataArr)
    }
    
    deinit {
        playerView.destroyPlyerView()
    }
    
    
    func needLoadMoreVideoList(listView: UIScrollView) {
        print("再加载三条")
        playerView.addResource(urls: dataArr)
        listView.jt_endRefresh()
    }
    
    func needRefreshVideoList(listView: UIScrollView) {
        print("没有更新视频了")
        listView.jt_endRefresh()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
