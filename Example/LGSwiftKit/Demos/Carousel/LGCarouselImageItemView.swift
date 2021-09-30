//
//  LGCarouselImageItemView.swift
//  LGSwiftKit_Example
//
//  Created by 刘盖 on 2021/9/30.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import LGSwiftKit

class LGCarouselImageItemView: LGCarouselItemView {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    } ()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
    }
}
