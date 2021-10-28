//
//  LGNetworkingAdapter.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/10/28.
//

import Foundation
import Alamofire
public enum LGRequestMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public typealias LGNetHeaderType = Dictionary<String, String>
public typealias LGNetParamType = Dictionary<String, Any>

open class LGNetWorkManager {
    
    private var baseUrl: String?
    private var headers: LGNetHeaderType?
    private var _sessionManager: SessionManager?
    private var sessionManager: SessionManager {
        get {
            return _sessionManager ?? SessionManager.default
        }
    }
    
    public static let manager = LGNetWorkManager()
    
    public var requestTimeout: TimeInterval = 10
    public var resourceTimeout: TimeInterval = 10
    
    open func initSet(_ baseUrl: String, headers: LGNetHeaderType?) {
        self.baseUrl = baseUrl
        self.headers = headers
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = self.requestHeaders(headers: SessionManager.defaultHTTPHeaders)
        configuration.timeoutIntervalForRequest = self.requestTimeout
        configuration.timeoutIntervalForResource = self.resourceTimeout
        _sessionManager = SessionManager(configuration: configuration)
    }
    
    open func request(method:LGRequestMethod = .post, baseUrl: String? = nil, urlPath: String, headers: LGNetHeaderType?, params: LGNetParamType?, completion: ((_ errorMsg: String?, _ data: Any?) -> Void)?) {
        
        if let url = URL(string: self.requestUrl(baseUrl: baseUrl, urlPath: urlPath)) {
            self.sessionManager.request(url, method: self.requestMethod(method: method), parameters: params, headers: self.requestHeaders(headers: headers)).responseJSON { response in
                switch response.result {
                case .success:
                    guard let completion = completion else {
                        return
                    }
                    completion(nil, response.result.value)
                case .failure(let error):
                    guard let completion = completion else {
                        return
                    }
                    completion(error.localizedDescription, nil)
                }
            }
            
        }
        
        
    }
    
    open func requestUrl(baseUrl: String? = nil, urlPath: String) -> String {
        if let baseUrlTemp = baseUrl {
            return baseUrlTemp+urlPath
        }
        
        if let baseUrlTemp = self.baseUrl {
            return baseUrlTemp+urlPath
        }
        
        return urlPath
    }
    
    private func requestMethod(method: LGRequestMethod) -> HTTPMethod {
        guard let methodNew = HTTPMethod(rawValue: method.rawValue) else {
            return .post
        }
        return methodNew
    }
    
    open func requestHeaders(headers: LGNetHeaderType? = nil) -> HTTPHeaders {
        var headersOriginal = self.headers ?? LGNetHeaderType()
        let headerMore = headers ?? LGNetHeaderType()
        headersOriginal.merge(headerMore) { _, new in
            return new
        }
        return headersOriginal
    }
    
}
