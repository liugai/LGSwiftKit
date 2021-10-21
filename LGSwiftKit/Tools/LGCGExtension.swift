//
//  LGCGFloat.swift
//  Integraler
//
//  Created by 刘盖 on 2020/5/29.
//  Copyright © 2020 刘盖. All rights reserved.
//

import UIKit

extension CGRect{
    //MARK: 屏幕bounds
    public static var screen_bounds: CGRect {
        return UIScreen.main.bounds
    }
    
}

extension CGFloat{
    
    //MARK: 屏幕宽度
    public static var screen_width: CGFloat {
        return CGRect.screen_bounds.size.width
    }
    
    //MARK: 屏幕高度
    public static var screen_height: CGFloat {
        return CGRect.screen_bounds.size.height
    }
    
    //MARK: 状态栏高度
    public static var statusbar_height: CGFloat {
        if #available(iOS 13.0, *) {
            return (UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height) ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
    
    //MARK: 导航栏高度
    public static var navbar_height: CGFloat {
        return 44
    }
    
    //MARK: 状态栏+导航栏高度
    public static var navbar_statusbar_height: CGFloat {
        return self.statusbar_height+self.navbar_height
    }
    
    //MARK: tabbar高度
    public static var tabbar_height: CGFloat {
        return Bool.is_full_iPhone ? 83 :49
    }
    
    //MARK: 底部安全区域高度
    public static var bottom_safe_height :CGFloat {
        return Bool.is_full_iPhone ? 34 :0
    }
    
    //MARK: 顶部安全区域高度
    public static var top_safe_height :CGFloat {
        return Bool.is_full_iPhone ? 24 :0
    }
    
    // MARK: 基础适配宽度
    public static var base_factor_width: CGFloat{
        return 375
    }
    
    // MARK: 基础适配高度
    public static var base_factor_height: CGFloat{
        return 667
    }
    
    // MARK: 适配比例
    public static var lg_factor: CGFloat {
        return self.screen_width/self.base_factor_width
    }

    // MARK: 获取适配后的长度
    public static func lg_factor(_ x:CGFloat) -> CGFloat{
        return x*self.lg_factor
    }
}



