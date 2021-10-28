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
    
    public static let manager = LGNetWorkManager()
    
    open func initSet(_ baseUrl: String, headers: LGNetHeaderType?) {
        self.baseUrl = baseUrl
        self.headers = headers
    }
    
    open func request(method:LGRequestMethod = .post, baseUrl: String? = nil, urlPath: String, headers: LGNetHeaderType?, params: LGNetParamType?, completion: ((_ error:Error?, _ data: Any?) -> Void)?) {
    
        if let url = URL(self.requestUrl(baseUrl: baseUrl, urlPath: urlPath)) {
            Alamofire.request(url, method: self.requestMethod(method: method), parameters: params, headers: HTTPHeaders?)
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
        var headersTemp = self.headers ?? LGNetHeaderType()
        headersTemp.merge(headers?? LGNetHeaderType()) { key, value in
            <#code#>
        }
        
    }
    
}
