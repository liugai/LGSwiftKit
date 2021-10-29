//
//  LGLayoutAdapter.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/10/28.
//

import Foundation
import SnapKit

public extension UIView {
    var lg_layout: ConstraintViewDSL {
        return self.snp
    }
}

