//
//  JTExitPlayerFullTransition.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/7.
//

import UIKit

class JTExitPlayerFullTransition: NSObject {
    var playerView: UIView
    var fromVC: UIViewController
    init(playerView: UIView, fromVc: UIViewController) {
        self.playerView = playerView
        self.fromVC = fromVc
        super.init()
    }
}

extension JTExitPlayerFullTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from), let toView = transitionContext.view(forKey: .to) else { return }
        toView.frame = toView.bounds
        let toVcBounds = self.fromVC.view.bounds
        let finalCenter = CGPointMake(toVcBounds.width/2, 150)
        transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .layoutSubviews) {
            fromView.transform = CGAffineTransform.identity
            fromView.center = finalCenter
            fromView.bounds = CGRect(x: 0, y: 0, width: toVcBounds.width, height: 300)
        } completion: { _ in
            fromView.transform = CGAffineTransform.identity
            fromView.center = finalCenter
            fromView.bounds = CGRect(x: 0, y: 0, width: toVcBounds.width, height: 300)
            self.playerView.frame = CGRect(x: 0, y: 0, width: toVcBounds.width, height: 300)
            self.fromVC.view.addSubview(self.playerView)
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    
}
