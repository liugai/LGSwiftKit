//
//  LGBool.swift
//  Integraler
//
//  Created by 刘盖 on 2020/5/29.
//  Copyright © 2020 刘盖. All rights reserved.
//

import CoreGraphics

// MARK: - 是否全屏
extension Bool{
    public static var is_full_iPhone: Bool{
        return CGFloat.statusbar_height>20
    }
}
