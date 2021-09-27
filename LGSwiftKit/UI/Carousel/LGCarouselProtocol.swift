//
//  LGCarouselProtocol.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/9/24.
//

import Foundation

@objc public protocol LGCarouselDelegate: NSObjectProtocol {
    
    @objc optional func carouselDidClick(_ carousel: LGCarousel, itemIndex: UInt) -> Void
    
    @objc optional func carouselDidItemIndexChanged(_ carousel: LGCarousel, itemIndex: UInt) -> Void
}

@objc public protocol LGCarouselDataSource: NSObjectProtocol {
    
    @objc optional func carouselItemsCount(_ carousel: LGCarousel) -> UInt
    
    @objc optional func carouselItemView(_ carousel: LGCarousel, itemView: LGCarouselItemView, itemIndex: UInt) -> Void
}
