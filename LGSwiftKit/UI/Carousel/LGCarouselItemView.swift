//
//  LGCarouselItemView.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/9/24.
//

import UIKit
open class LGCarouselItemView: UIView {
    
    /// 对应索引
    var indexPath: LGCarouselIndexPath = LGCarouselIndexPath(itemIndex: 0, pageIndex: 0)

    /// 重用标识，暂时不支持创建不同itemView
    var reuseIdentifier: String = ""
}
