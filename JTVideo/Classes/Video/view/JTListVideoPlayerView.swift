//
//  JTListVideoPlayerView.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/11/22.
//

import UIKit
import AliyunPlayer
class JTListVideoPlayerView: UIView {
    lazy var player: AliListPlayer = {
        let p = AliListPlayer()
        p?.preloadCount = 3
        p!.delegate = self
        return p!
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension JTListVideoPlayerView: AVPDelegate {
    
}
