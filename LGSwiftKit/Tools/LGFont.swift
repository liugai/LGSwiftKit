//
//  LGFont.swift
//  Integraler
//
//  Created by 刘盖 on 2020/5/29.
//  Copyright © 2020 刘盖. All rights reserved.
//

import UIKit
// MARK: - 定义字体大小/粗细
extension UIFont{
    
    public static func lg_font(_ fontSize:CGFloat) -> UIFont {
        return self.systemFont(ofSize: fontSize)
    }
    
    public static func lg_font_mid(_ fontSize:CGFloat) -> UIFont {
        return self.systemFont(ofSize: fontSize, weight: self.Weight.medium)
    }
    
    public static func lg_font_bold(_ fontSize:CGFloat) -> UIFont {
        return self.boldSystemFont(ofSize: fontSize)
    }
    
}
