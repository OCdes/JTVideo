//
//  ScrollView+Extension.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/1/3.
//  Copyright © 2020 WanCai. All rights reserved.
//

import Foundation
import MJRefresh
import UIKit

extension UIScrollView {
   @objc public func jt_addRefreshHeader(handler handle:@escaping ()->Void)->MJRefreshStateHeader {
        let header: MJRefreshStateHeader = MJRefreshStateHeader.init(refreshingBlock: handle)
        header.stateLabel?.font = UIFont.systemFont(ofSize: 14)
        header.stateLabel?.textColor = HEX_999
        self.mj_header = header
        return self.mj_header as! MJRefreshStateHeader
    }
    
    @objc public func jt_addRefreshHeaderWithNoText(handler handle:@escaping ()->Void)->MJRefreshStateHeader {
        let header: MJRefreshStateHeader = MJRefreshStateHeader.init(refreshingBlock: handle)
        header.stateLabel?.isHidden = true
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.font = UIFont.systemFont(ofSize: 14)
        header.stateLabel?.textColor = HEX_999
        self.mj_header = header
        return self.mj_header as! MJRefreshStateHeader
    }
    
   @objc public func jt_addRefreshFooter(handler handle:@escaping ()->Void)->MJRefreshAutoNormalFooter {
        let footer: MJRefreshAutoNormalFooter = MJRefreshAutoNormalFooter.init(refreshingBlock: handle)
        footer.stateLabel?.font = UIFont.systemFont(ofSize: 14)
        footer.stateLabel?.textColor = HEX_999
        self.mj_footer = footer
        return self.mj_footer as! MJRefreshAutoNormalFooter
    }
    
   @objc public func jt_startRefresh() {
        if self.mj_header != nil {
            self.mj_header?.beginRefreshing()
        }
        if self.mj_footer != nil {
            self.mj_footer?.isHidden = true
        }
    }
    
    @objc public func jt_endRefresh() {
        if self.mj_header != nil {
            self.mj_header?.endRefreshing()
        }
        if self.mj_footer != nil {
            self.mj_footer?.isHidden = false
            self.mj_footer?.resetNoMoreData()
        }
    }
    
   @objc public func jt_addPagingRefreshFooterWithNotice(_ notice: String, _ handle:@escaping()->Void)->MJRefreshAutoNormalFooter {
        let footer = self.jt_addRefreshFooter(handler: handle)
        footer.stateLabel?.textColor = HEX_999;
        footer.stateLabel?.font = UIFont.systemFont(ofSize: 14)
        self.mj_footer = footer
        return self.mj_footer as! MJRefreshAutoNormalFooter
    }
    
   @objc public func jt_endRefreshWithNoMoreData() {
        if self.mj_footer != nil {
            self.mj_footer?.endRefreshingWithNoMoreData()
        }
    }
    
    @objc public func jt_endHeaderRefreshWithNoMoreData() {
        if self.mj_header != nil {
            self.mj_header?.endRefreshing()
            self.mj_header?.isHidden = true
        }
    }
    
}
