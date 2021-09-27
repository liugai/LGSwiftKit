//
//  LGAttributeString.swift
//  Integraler
//
//  Created by 刘盖 on 2020/5/29.
//  Copyright © 2020 刘盖. All rights reserved.
//

import UIKit

// MARK: - 计算size
extension NSAttributedString{
    public func sizeFromAttrStr(width:CGFloat) -> CGSize{
        return self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesFontLeading, context: nil).size
    }
}

