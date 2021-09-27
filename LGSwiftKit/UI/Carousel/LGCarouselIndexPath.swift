//
//  LGCarouselIndexPath.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/9/24.
//

import Foundation
struct LGCarouselIndexPath: Equatable{
    /// 索引
    var itemIndex: UInt
    /// 对应页
    var pageIndex: UInt
    /// 比较是否相等
    /// - Parameters:
    ///   - lhs: 第一个
    ///   - rhs: 第二个
    /// - Returns: 返回值
    static func == (lhs: Self, rhs: Self) -> Bool{
        return lhs.itemIndex == rhs.itemIndex
    }
}
