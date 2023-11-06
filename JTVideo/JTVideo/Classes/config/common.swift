//
//  common.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/10/31.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Moya
import SVProgressHUD
import HandyJSON
import Kingfisher
import Photos

let USERDEFAULT = UserDefaults.standard
//屏幕尺寸
let kScreenWidth: CGFloat = UIScreen.main.bounds.width
let kScreenHeight: CGFloat = UIScreen.main.bounds.height
//tabbar是否隐藏及其高度
let kTabbarHidden: Bool = true
let kTabBarHeight: CGFloat = 49
//机型判断
let kDynamicIsland: Bool = (kScreenHeight == 852 || kScreenHeight == 932)
let kiPhoneXOrXS: Bool = (kScreenHeight == 812 || kScreenHeight == 896 || kScreenHeight == 926)
let kiPhonePlus: Bool = kScreenHeight == 736 && kScreenWidth == 414
let kiPhonoe678: Bool = kScreenHeight == 667 && kScreenWidth == 375
let kiPhone45SC: Bool = kScreenHeight == 480 && kScreenHeight == 320
let kNavibarHeight: CGFloat = (kiPhoneXOrXS ? 88 : (kDynamicIsland ? 98 : 64))
let kBottomSafeHeight: CGFloat = ((kiPhoneXOrXS || kDynamicIsland) ? 34 : 0)
struct NotificationHelper {
    static let kChatOnlineNotiName = Notification.Name("kChatOnlineNotiName")
    static let kChatOnGroupNotiName = Notification.Name("kChatOnGroupNotiName")
    static let kReLoginName = Notification.Name("kReLoginName")
    static let kUpdateRedDot = Notification.Name("NewPrewarningIsComing")
    static let kUpdateRecentList = Notification.Name("kUpdateRecentList")
    static let kUpdateContactor = Notification.Name("kUpdateContactor")
}
//--------------------------- 全局函数 -------------------------
//获取十六进制颜色
func HEX_COLOR(hexStr x: String)->UIColor {
    var hexString = x.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    
    if (hexString.hasPrefix("#")) {
        let index = hexString.index(hexString.startIndex, offsetBy: 1)
        hexString = String(hexString[index...])
    }
    let scanner = Scanner(string: hexString)
    var color: UInt64 = 0
    scanner.scanHexInt64(&color)
    let mask = 0x000000FF
    let r = Int(color >> 16) & mask
    let g = Int(color >> 8) & mask
    let b = Int(color) & mask
    return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
}

func DECEM_COLOR(decemStr x: String)-> UIColor {
    var hexColorStr = "#"
    let decemInt = (x as NSString).intValue
    let red = (decemInt & 0xff0000) >> 16
    let green = (decemInt & 0x00ff00) >> 8
    let blue = (decemInt & 0x0000ff)
    if (blue >= 0 && blue <= 255) && (green >= 0 && green <= 255) && (red >= 0 && red <= 255) {
        var tr = String(format: "%0x", red)
        var tg = String(format: "%0x", green)
        var tb = String(format: "%0x", blue)
        tr = tr.count == 1 ? "0"+tr : tr
        tg = tg.count == 1 ? "0"+tg : tg
        tb = tb.count == 1 ? "0"+tb : tb
        hexColorStr = hexColorStr + tr + tg + tb
    } else { return HEX_FFF}
    return HEX_COLOR(hexStr: hexColorStr)
}

func isPurnInt(string: String) -> Bool {
    let regStr = "^[0-9]*$"
    let regex = try? NSRegularExpression(pattern: regStr, options: [])
    
    
    if string.count > 0 {
        if let result = regex?.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)), result.count != 0 {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
}

func isNum(str: String) -> Bool {
    let regStr = "^([0-9]{1,}[.]?[0-9]*)$"
    let regex = try? NSRegularExpression(pattern: regStr, options: [])
    
    
    if str.count > 0 {
        if let result = regex?.matches(in: str, options: [], range: NSRange(location: 0, length: str.count)), result.count != 0 {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
}

func isEmailSuffixEqualToAt(textStr: String) -> Bool {
    if textStr.count > 0 , textStr.hasSuffix("@") {
        let regex = "[0-9a-zA-Z]@"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: textStr)
    } else {
        return false
    }
}

func currentDateStr() -> String {
    let date = Date()
    let dateFormatter = DateFormatter.init()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.string(from: date)
}

func checkCameraAuth()->Bool {
    let auth = AVCaptureDevice.authorizationStatus(for: .video)
    if auth == .denied {
        let alertvc = UIAlertController(title: "提示", message: "您的相机权限未开启，请开启权限以扫描二维码", preferredStyle: .alert)
        alertvc.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        let sureAction = UIAlertAction.init(title: "去打开", style: .destructive) { (ac) in
            let url = URL(string: UIApplicationOpenSettingsURLString)
            if let u = url, UIApplication.shared.canOpenURL(u) {
                UIApplication.shared.open(u, options: [:], completionHandler: nil)
            }
        }
        alertvc.addAction(sureAction)
        APPWINDOW.rootViewController?.present(alertvc, animated: true, completion: nil)
        return false
    }
    return true
}

func checkPhotoLibaray()->Bool {
    if #available(iOS 14, *) {
        let status = PHPhotoLibrary.authorizationStatus(for:.readWrite)
        if status == .denied {
            let alertvc = UIAlertController(title: "提示", message: "您的照片权限未开启，请开启权限以发送图片", preferredStyle: .alert)
            alertvc.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
            let sureAction = UIAlertAction.init(title: "去打开", style: .destructive) { (ac) in
                let url = URL(string: UIApplicationOpenSettingsURLString)
                if let u = url, UIApplication.shared.canOpenURL(u) {
                    UIApplication.shared.open(u, options: [:], completionHandler: nil)
                }
            }
            alertvc.addAction(sureAction)
            APPWINDOW.rootViewController?.present(alertvc, animated: true, completion: nil)
            return false
        } else if status == .limited {
            let resut = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
            for i in 0..<resut.count {
                let re = resut[i]
                let asset = PHAsset.fetchAssets(in: re, options: nil)
                if asset.count == 0 && i == 0 {
                    return false
                }
            }
        }
        return true
    } else {
        // Fallback on earlier versions
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .denied {
            let alertvc = UIAlertController(title: "提示", message: "您的照片权限未开启，请开启权限以发送图片", preferredStyle: .alert)
            alertvc.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
            let sureAction = UIAlertAction.init(title: "去打开", style: .destructive) { (ac) in
                let url = URL(string: UIApplicationOpenSettingsURLString)
                if let u = url, UIApplication.shared.canOpenURL(u) {
                    UIApplication.shared.open(u, options: [:], completionHandler: nil)
                }
            }
            alertvc.addAction(sureAction)
            APPWINDOW.rootViewController?.present(alertvc, animated: true, completion: nil)
            return false
        }
        return true
    }
}

func SVPShowSuccess(content str: String) {
    SVProgressHUD.setDefaultMaskType(.none)
    SVProgressHUD.showSuccess(withStatus: str)
}

func SVPShowError(content str: String) {
    SVProgressHUD.setDefaultMaskType(.none)
    SVProgressHUD.showError(withStatus: str)
    SVProgressHUD.dismiss(withDelay: 2)
}

func SVPShow(content str: String) {
    SVProgressHUD.show(withStatus: str)
}

func SVPNoUserinteractShow(content str: String) {
    SVProgressHUD.setDefaultMaskType(.clear)
    SVProgressHUD.show(withStatus: str)
    
}

func hideCardId(str: String) -> String {
    if str.count > 0  {
        let s = (str as NSString).substring(with: NSRange(location: str.count-4, length: 4))
        return "****\(s)"
    } else {
        return ""
    }
}

func timeExchange(time: String)-> String {
    if time.count > 0 {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: Date = dateFormatter.date(from: time)!
        dateFormatter.dateFormat = "MM-dd HH:mm"
        return dateFormatter.string(from: date)
    } else {
        return "日期格式无效"
    }
}

//--------------------------------------------------------------
let kIsFlagShip = JTManager.manager.isFlagShip
let HEX_FFF = HEX_COLOR(hexStr: "#FFFFFF")
let HEX_333 = kIsFlagShip ? HEX_FFF : HEX_COLOR(hexStr: "#333333")
let HEX_666 = HEX_COLOR(hexStr: "#666666")
let HEX_999 = HEX_COLOR(hexStr: "#999999")
let HEX_LightBlue = HEX_COLOR(hexStr: "#408CE2")
let HEX_ThemeBlack = HEX_COLOR(hexStr: "#1A1C29")
let HEX_F5F5F5 = HEX_COLOR(hexStr: "#f5f5f5")
let HEX_VIEWBACKCOLOR = HEX_COLOR(hexStr: "#2C3039")
let HEX_GOLDTEXTCOLOR = HEX_COLOR(hexStr: "#E1D1AC")
let HEX_GOLDGRATYCOLOR = HEX_COLOR(hexStr: "#a29d95")
let HEX_GOLDBLACK = HEX_COLOR(hexStr: "#151722")
let HEX_GOLDYELLOW = HEX_COLOR(hexStr: "#D0A72F")


let APPWINDOW: UIWindow = (UIApplication.shared.delegate?.window!)!
//云端地址
let URL_CLOUD = "https://cloud.hzjtyh.com"
public var BASE_URL = {()->String in
    return (USERDEFAULT.object(forKey: "baseURL") as? String) ?? ""
}()

public var tocken = {()->String in
    return USERDEFAULT.object(forKey: "jwt") as! String
}()

//请求状态码
//NOTE:网络请求状态码
let REQUEST_SUCCESSFUL: Int = 0
let REQUEST_LOGINFORBIDEN: Int = 1013
let REQUEST_SERVERERRO: Int = -400
let REQUEST_UNKNOWNERROR: Int = 1
let REQUEST_NOTOKEN: Int = 6601
let REQUEST_UNVALIDTOKEN: Int = 1005
let REQUEST_TODIVCELOGIN: Int = 6603
let REQUEST_NOPAYUSER: Int = 2001

