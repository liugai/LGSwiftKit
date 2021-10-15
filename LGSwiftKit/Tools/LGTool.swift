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
    public static func currentTopController() -> UIViewController{
        let window = UIApplication.shared.delegate!.window!!
        var topViewController = window.rootViewController!
        while true {
            if let presentedVC = topViewController.presentedViewController {
                topViewController = presentedVC
            }
            else if topViewController is UINavigationController, let topTemp = (topViewController as! UINavigationController).topViewController   {
                topViewController = topTemp
            }
            else if topViewController is UITabBarController ,let topTemp = (topViewController as! UITabBarController).selectedViewController{
                topViewController = topTemp
            }
            else {
                break
            }
        }
        return topViewController
    }
    
    
}
