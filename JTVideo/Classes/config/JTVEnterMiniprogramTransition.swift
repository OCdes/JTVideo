//
//  JTVEnterMiniprogramTransition.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/12/20.
//

import UIKit

class JTVEnterMiniprogramTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    
    
}
