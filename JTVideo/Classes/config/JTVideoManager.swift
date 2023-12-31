//
//  JTManager.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/10/31.
//

import Foundation

var kJTVideoUrlKey = "kJTVideoUrlKey"
var kJTVideoPlayViewKey = "kJTVideoPlayViewKey"
@objc
public protocol JTVideoDelegate {
    
    @objc optional func JTNeedRelogin()
    
}


open class JTVideoManager: NSObject {
    public static let manager = JTVideoManager()
    open weak var delegate: JTVideoDelegate?
    @objc open var url: String = "" {
        didSet {
            USERDEFAULT.set(url, forKey: "baseURL")
        }
    }
    @objc open var AccessToken: String = "" {
        didSet {
            USERDEFAULT.set(AccessToken, forKey: "AccessToken")
        }
    }

    @objc open var phone: String = "" {
        didSet {
            USERDEFAULT.set(phone, forKey: "phone")
        }
    }
    @objc open var isWaterShow: Bool = false {
        didSet {
            USERDEFAULT.set(isWaterShow, forKey: "isWaterShow")
        }
    }
    @objc open var isAutoResizeBottom: Bool = false {
        didSet {
            USERDEFAULT.set(isAutoResizeBottom, forKey: "isAutoResizeBottom")
        }
    }
    
    @objc open var isHiddenPrice: Bool = false {
        didSet {
            USERDEFAULT.set(isHiddenPrice, forKey: "isHiddenPrice")
        }
    }
    
    @objc open var isHideBottom: Bool = false {
        didSet {
            USERDEFAULT.set(isHideBottom, forKey: "isHideBottom")
        }
    }
    @objc open var isFlagShip: Bool = false {
        didSet {
            USERDEFAULT.set(isHideBottom, forKey: "isFlagShip")
        }
    }
    @objc open var placeID: Int = 0 {
        didSet {
            USERDEFAULT.set(placeID, forKey: "placeID")
        }
    }
    @objc open var socketUrl: String = "" {
        didSet {
            USERDEFAULT.set(socketUrl, forKey: "baseSocket")
        }
    }
    @objc open var departmentDict: Dictionary<String, Any> = [:] {
        didSet {
            USERDEFAULT.set(departmentDict, forKey: "cdepartmentDict")
        }
    }
    @objc open var employeeDict: Dictionary<String, Any> = [:] {
        didSet {
            USERDEFAULT.set(employeeDict, forKey: "cemployeeDict")
        }
    }
    
    @objc open var tabBarIsTranlucent: Bool = true
    
    @objc open var isSafeQrCode: Bool = false
    
    @objc open var addFriendSilence: Bool = false
    
    @objc open class func shareManager()->JTVideoManager {
        return manager
    }
    
}


