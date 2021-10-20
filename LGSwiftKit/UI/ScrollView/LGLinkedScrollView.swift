//
//  LGLinkedScrollView.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/10/20.
//

import UIKit

class LGLinkedScrollView: UIScrollView, UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
