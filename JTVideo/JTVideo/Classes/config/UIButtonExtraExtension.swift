//
//  UIButtonExtraExtension.swift
//  Swift-jtyh
//
//  Created by jingte on 2022/3/2.
//  Copyright © 2022 WanCai. All rights reserved.
//

import Foundation
import UIKit
var kExtraPropertyKey = "kExtraPropertyKey"
extension UIButton {
    func extraArea(area: UIEdgeInsets) {
        objc_setAssociatedObject(self, &kExtraPropertyKey, area, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let edges = objc_getAssociatedObject(self, &kExtraPropertyKey) as? UIEdgeInsets {
            var extraArea = self.bounds
            extraArea = CGRect(x: extraArea.minX-edges.left, y: extraArea.minY-edges.top, width: extraArea.width+edges.left+edges.right, height: extraArea.height+edges.top+edges.bottom)
            return extraArea.contains(point)
        } else {
            return self.bounds.contains(point)
        }
        
    }
}
