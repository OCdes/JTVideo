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
        var toVcBounds = self.fromVC.view.bounds
        var toPlayerFrame = self.fromVC.view.bounds
        var parentView = self.fromVC.view
        var toPlayBounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: 300)
        if let pv = self.playerView as? JTPlayerView, let parentV = pv.parentView {
            toVcBounds = pv.toVCFrame
            parentView = parentV
            toPlayBounds = pv.parentFrame
        }
        fromView.bounds = toVcBounds
        var finalCenter = CGPointMake(toVcBounds.width/2+toVcBounds.origin.x, toVcBounds.height/2+toVcBounds.origin.y)
        transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .layoutSubviews) {
            fromView.transform = CGAffineTransform.identity
            fromView.center = finalCenter
            fromView.bounds = toVcBounds
        } completion: { _ in
            fromView.transform = CGAffineTransform.identity
            fromView.center = finalCenter
            fromView.bounds = toVcBounds
            self.playerView.frame = toPlayBounds
            parentView?.addSubview(self.playerView)
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    
}
