//
//  JTEnterPlayerFullTransition.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/7.
//

import UIKit

class JTEnterPlayerFullTransition: NSObject {
    var playerView: UIView
    init(playerView: UIView) {
        self.playerView = playerView
        super.init()
    }
}

extension JTEnterPlayerFullTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else { return }
        let originCenter = transitionContext.containerView.convert(playerView.center, from: playerView)
        transitionContext.containerView.addSubview(toView)
        toView.addSubview(playerView)
        if let pv = self.playerView as? JTPlayerView {
            toView.bounds = pv.toVCFrame
        } else {
            toView.bounds = playerView.frame
        }
        
        toView.center = originCenter
        toView.transform = CGAffineTransformMakeRotation(Double.pi/2)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),delay: 0, options: .layoutSubviews) {
            toView.transform = CGAffineTransform.identity
            toView.bounds = transitionContext.containerView.bounds
            toView.center = transitionContext.containerView.center
            
        } completion: { _ in
            toView.transform = CGAffineTransform.identity
            toView.bounds = transitionContext.containerView.bounds
            toView.center = transitionContext.containerView.center
            transitionContext.completeTransition(true)
        }

    }
    
    
}
