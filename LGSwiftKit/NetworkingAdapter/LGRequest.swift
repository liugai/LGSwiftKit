//
//  LGRequest.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/10/28.
//

import Foundation
import Alamofire
import UIKit

open class LGRequest {
    private var _request: Request
    open var request: Request {
        get {
            return request
        }
    }
    open var requestHeader: Dictionary<String, Any>?
    
    init(_ request: Request) {
        request = request
    }
    
    
}
