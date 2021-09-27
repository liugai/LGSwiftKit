//
//  LGCGFloat.swift
//  Integraler
//
//  Created by 刘盖 on 2020/5/29.
//  Copyright © 2020 刘盖. All rights reserved.
//

import UIKit

extension CGRect{
    public static var screen_bounds: CGRect {
        return UIScreen.main.bounds
    }
    
}

extension CGFloat{
    
    public static var screen_width: CGFloat {
        return CGRect.screen_bounds.size.width
    }
    
    public static var screen_height: CGFloat {
        return CGRect.screen_bounds.size.height
    }
    
    public static var statusbar_height: CGFloat {
        if #available(iOS 13.0, *) {
            return (UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height) ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
    
    public static var navbar_height: CGFloat {
        return 44
    }
    
    public static var navbar_statusbar_height: CGFloat {
        return self.statusbar_height+self.navbar_height
    }
    
    public static var tabbar_height: CGFloat {
        return Bool.is_full_iPhone ? 83 :49
    }
    
    public static var tabbar_safe_height :CGFloat {
        return Bool.is_full_iPhone ? 34 :0
    }
    
    public static var statusbar_safe_height :CGFloat {
        return Bool.is_full_iPhone ? 24 :0
    }
    
    // MARK: - 定义屏幕适配UI比例
    public static var base_factor_width: CGFloat{
        return 375
    }
    
    public static var base_factor_height: CGFloat{
        return 667
    }
    
    public static var lg_factor: CGFloat {
        return self.screen_width/self.base_factor_width
    }

    public static func lg_factor(_ x:CGFloat) -> CGFloat{
        return x*self.lg_factor
    }

    public static var radius_base: CGFloat{
        return lg_factor(4)
    }
    
    public static var lg_left: CGFloat{
        return lg_factor(17)
    }
    
    public static var lg_line_height: CGFloat{
        return 1
    }
    
}



