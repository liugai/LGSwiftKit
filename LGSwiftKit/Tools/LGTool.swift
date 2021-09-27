//
//  LGTool.swift
//  Integraler
//
//  Created by 刘盖 on 2020/5/22.
//  Copyright © 2020 刘盖. All rights reserved.
//

import UIKit
class LGTool{
    ///排除NSNull对象
    
    public static func fiterNull(obj:Any?) -> Any?{
        guard let objNew = obj else{
            return nil
        }
        
        guard !(objNew is NSNull) else{
            return nil
        }
        return objNew
    }
    
    ///获取当前最上层控制器
    public static func currentVC() -> UIViewController{
        guard let window = UIApplication.shared.delegate?.window else {
            return UIViewController()
        }
        
        guard let vc = window!.rootViewController else {
            return UIViewController()
        }
        return vc
    }
    
    
}
