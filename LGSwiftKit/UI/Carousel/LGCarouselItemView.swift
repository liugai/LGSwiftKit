//
//  LGCarouselItemView.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/9/24.
//

import UIKit

public protocol LGCarouselItemViewProtocol: NSObjectProtocol {
    
    static func itemView() -> Self
}

open class LGCarouselItemView: UIView, LGCarouselItemViewProtocol {
    
    /// 对应索引
    var indexPath: LGCarouselIndexPath = LGCarouselIndexPath(itemIndex: 0, pageIndex: 0)

    /// 重用标识，暂时不支持创建不同itemView
    var reuseIdentifier: String = ""
    
    required public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public static func itemView() -> Self {
        return Self.init(frame: CGRect.zero)
    }
}
