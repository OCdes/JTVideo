//
//  JTEnterPlayerFullTransition.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/7.
//

import UIKit

class JTEnterPlayerFullTransition: NSObject {
    var playerView: UIView
    var fromVC: UIViewController
    init(playerView: UIView, fromVC: UIViewController) {
        self.playerView = playerView
        self.fromVC = fromVC
        super.init()
    }
}

extension JTEnterPlayerFullTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to), let _ = transitionContext.viewController(forKey: .to) else { return }
        let originCenter = transitionContext.containerView.convert(playerView.center, from: playerView)
        transitionContext.containerView.addSubview(toView)
        toView.addSubview(playerView)
        toView.bounds = playerView.bounds
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
