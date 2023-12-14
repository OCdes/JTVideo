//
//  VideoNetServiceManager.swift
//  JTVideo
//
//  Created by 袁炳生 on 2023/10/31.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift
import SystemConfiguration.CaptiveNetwork

//http://localhost/TestSites/app.json
//网络环境枚举->分别为测试网络环境，开发网络环境，生产网络环境
enum NetworkEnvironment {
    case NetworkEnvironmentTest
    case NetworkEnvironmentDevelopment
    case NetworkEnvironmentProduct
    case NetworkEnviromentMerchantInfo
}
//请求类型
enum RequestType {
    case RequestTypeGet
    case RequestTypePost
    case RequestTypeUpload
    case RequestTypeDownload
}
//网络状态码
enum NetworkStautsCode : Int32 {
    case NetworkStatusCodeUnkonw        = -1
    case NetworkStatusCodeNotReachable  = 0
    case NetworkStautsCodeWWAN          = 1
    case NetworkStatusCodeWifi          = 2
    
}
/** 访问出错具体原因 */
struct AFSErrorInfo {
    var code = 0
    var message = ""
    var error: NSError?
}
//网络请求成功回调
typealias RequestSuccess = (_ msg: String,_ code: Int,_ response: AnyObject, _ data: Dictionary<String, Any>) -> Void
//网络请求失败回调
typealias RequestFail = (AFSErrorInfo)->Void
//网络状态
typealias NetworkStatus = (_ status: UInt32)->Void
//加载进度
typealias NetworkProgress = (_ value: Double)->Void


//网络环境
let currentNetworkEv: NetworkEnvironment = .NetworkEnvironmentProduct

let networkTimeout: TimeInterval = 20

var netBaseUrl: String = USERDEFAULT.object(forKey: "baseURL") as! String

func urlByNetworkEnv(env: NetworkEnvironment)->String{
    var urlStr = BASE_URL
    switch env {
    case .NetworkEnvironmentTest:
        urlStr = netBaseUrl
    case .NetworkEnvironmentDevelopment:
        urlStr = netBaseUrl
    case .NetworkEnvironmentProduct:
        urlStr = BASE_URL
    case .NetworkEnviromentMerchantInfo:
        urlStr = URL_CLOUD
    }
    
    return urlStr
}


class VideoNetServiceManager: NSObject {
    private var sessionManager: SessionManager?
    static let manager = VideoNetServiceManager()
    let dataCachePath = NSHomeDirectory()+"/Documents/NetworkDataCache/"
    let networkStatus: NetworkStautsCode = .NetworkStatusCodeWifi
    private var header:[String: Any] = {
        var httpHeader: HTTPHeaders = SessionManager.defaultHTTPHeaders
        return httpHeader
    }()
    private var subject: PublishSubject<Any>?
    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = networkTimeout
        
        sessionManager = SessionManager.init(configuration: configuration, delegate: SessionDelegate.init(), serverTrustPolicyManager: nil)
        
    }
    
    public func checkWifi() {
        
    }
    
    private func getSSID() -> String {
        let interfaces = CNCopySupportedInterfaces()
        var ssid = ""
        if interfaces != nil {
            let interfacesArray = CFBridgingRetain(interfaces) as! Array<Any>
            if interfacesArray.count > 0 {
                let interfaceName = interfacesArray[0] as! CFString
                let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
                if (ussafeInterfaceData != nil) {
                    let interfaceData = ussafeInterfaceData as! Dictionary<String, Any>
                    ssid = interfaceData["SSID"]! as! String
                 }
            }
        }
        return ssid
    }
    
    public func requestByType(requestType: RequestType, url: String, params: [String: Any], success: @escaping RequestSuccess, fail: @escaping RequestFail)->PublishSubject<Any> {
        let sub: PublishSubject = PublishSubject<Any>()
        self.header = SessionManager.defaultHTTPHeaders
        if let a = USERDEFAULT.object(forKey: "AccessToken") {
            self.header["AccessToken"] = a
        }
        var mparam: Dictionary<String, Any> = params
        print(mparam)
        switch requestType {
        case .RequestTypeGet:
            self.GET(requestType: requestType, url: url, params: mparam, success: { (msg, code, response, data) in
                success(msg,code,response,data)
                sub.onNext(data)
                sub.dispose()
            }) { (errorInfo) in
                fail(errorInfo)
            }
        case .RequestTypePost:
            self.POST(requestType: requestType, url: url, params: mparam, success: { (msg, code, response, data) in
                success(msg,code,response,data)
                sub.onNext(data)
                sub.dispose()
            }) { (errorInfo) in
                fail(errorInfo)
            }
        case .RequestTypeUpload:
            self.POST(requestType: requestType, url: url, params: mparam, success: { (msg, code, response, data) in
                success(msg,code,response,data)
                sub.onNext(data)
                sub.dispose()
            }) { (errorInfo) in
                fail(errorInfo)
            }
        case .RequestTypeDownload:
            self.GET(requestType: requestType, url: url, params: mparam, success: { (msg, code, response, data) in
                success(msg,code,response,data)
                sub.onNext(data)
                sub.dispose()
            }) { (errorInfo) in
                fail(errorInfo)
            }
        }
        return sub
    }
    
    public func requestByType(requestType: RequestType, api: String, params: [String: Any], success: @escaping RequestSuccess, fail: @escaping RequestFail)->PublishSubject<Any> {
        self.header = SessionManager.defaultHTTPHeaders
        let sub: PublishSubject = PublishSubject<Any>()
        var mparam: Dictionary<String, Any> = params
        if let a = USERDEFAULT.object(forKey: "AccessToken") {
            self.header["AccessToken"] = a
        }
        let uStr = urlByNetworkEnv(env: currentNetworkEv) + api
        print("\(uStr)\(mparam)")
        switch requestType {
        case .RequestTypeGet:
            self.GET(requestType: requestType, url: uStr, params: mparam, success: { (msg, code, response, data) in
                success(msg,code,response,data)
                sub.onNext(data)
                sub.dispose()
            }) { (errorInfo) in
                fail(errorInfo)
            }

        case .RequestTypePost:
            self.POST(requestType: requestType, url: uStr, params: mparam, success: { (msg, code, response, data) in
                success(msg,code,response,data)
                sub.onNext(data)
                sub.dispose()
            }) { (errorInfo) in
                fail(errorInfo)
            }

        case .RequestTypeUpload:
            self.POST(requestType: requestType, url: uStr, params: mparam, success: { (msg, code, response, data) in
                success(msg,code,response,data)
                sub.onNext(data)
                sub.dispose()
            }) { (errorInfo) in
                fail(errorInfo)
            }
        case .RequestTypeDownload:
            self.GET(requestType: requestType, url: uStr, params: mparam, success: { (msg, code, response, data) in
                success(msg,code,response,data)
                sub.onNext(data)
                sub.dispose()
            }) { (errorInfo) in
                fail(errorInfo)
            }
        }
        return sub
    }
}

extension VideoNetServiceManager {
    
    fileprivate func GET(requestType: RequestType, url: String, params: [String: Any], success:@escaping RequestSuccess, fail:@escaping RequestFail){
        self.sessionManager?.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: self.header as? HTTPHeaders).validate().responseJSON(completionHandler: { [weak self](response) in
            self!.handleResponse(response: response, successBlock: success, faliedBlock: fail)
        })
    }

    fileprivate func POST(requestType: RequestType, url: String, params: [String: Any], success:@escaping RequestSuccess, fail:@escaping RequestFail){
        var paraItems:[String] = Array()
        for (key,value) in params {
            paraItems.append("\(key)=\(value)")
        }
        let paraStr = paraItems.joined(separator: "&")
        let urlReqest = URL.init(string: url)
        var request = URLRequest.init(url: urlReqest!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = paraStr.data(using: .utf8)
        self.sessionManager?.request(url, method: HTTPMethod.post, parameters: params, encoding: URLEncoding.default, headers: self.header as? HTTPHeaders).responseJSON(completionHandler: { [weak self](response) in
            return self!.handleResponse(response: response, successBlock: success, faliedBlock: fail)
        })
    }
        
    /** 处理服务器响应数据*/
    private func handleResponse(response:DataResponse<Any>, successBlock: RequestSuccess ,faliedBlock: RequestFail){
        if let error = response.result.error {
            // 服务器未返回数据
                self.handleRequestError(error: error as NSError , faliedBlock: faliedBlock)
            
        }else if let value = response.result.value {
            // 服务器又返回数h数据
            if (value as? NSDictionary) == nil {
                // 返回格式不对
                self.handleRequestSuccessWithFaliedBlcok(faliedBlock: faliedBlock)
            }else{
                self.handleRequestSuccess(value: response.data as Any, data: value as! Dictionary<String, Any>, successBlock: successBlock, faliedBlock: faliedBlock)
            }
        }
    }
    
    /** 处理请求失败数据*/
    private func handleRequestError(error: NSError, faliedBlock: RequestFail){
        var errorInfo = AFSErrorInfo();
        errorInfo.code = error.code;
        errorInfo.error = error;
        if ( errorInfo.code == -1009 ) {
            errorInfo.message = "无网络连接";
        }else if ( errorInfo.code == -1001 ){
            errorInfo.message = "请求超时";
        }else if ( errorInfo.code == -1005 ){
            errorInfo.message = "网络连接丢失(服务器忙)";
        }else if ( errorInfo.code == -1004 ){
            errorInfo.message = "服务没有启动";
        }else if ( errorInfo.code == 404 || errorInfo.code == 3) {
        }
        faliedBlock(errorInfo)
    }
    
     /** 处理请求成功数据*/
    private func handleRequestSuccess(value: Any, data: Dictionary<String , Any>, successBlock: RequestSuccess,faliedBlock: RequestFail){
        let code: Int = (data["error_code"] ?? (data["code"] ?? data["status"] ?? data["ErrCode"] ?? "101" )) as! Int
        let msg: String = (data["msg"] ?? data["Msg"] ?? data["message"] ?? data["ErrMsg"] ?? "未知错误") as! String
        if code == REQUEST_SUCCESSFUL {
            successBlock(msg,code,value as AnyObject,data)
        } else if code == 501 || code == 6601 {
            SVPShowError(content: msg)
            if let de = JTVideoManager.manager.delegate {
                de.JTNeedRelogin?()
            }
        } else {
            var errorInfo = AFSErrorInfo();
            errorInfo.code = code;
            errorInfo.message = msg.count > 0 ? msg : "";
            faliedBlock(errorInfo)
        }
    }
    
    /** 服务器返回数据解析出错*/
    private func handleRequestSuccessWithFaliedBlcok(faliedBlock:RequestFail){
        var errorInfo = AFSErrorInfo();
        errorInfo.code = -1;
        errorInfo.message = "数据解析出错";
    }
}

