//
//  LGCarouselDemoViewController.swift
//  LGSwiftKit_Example
//
//  Created by 刘盖 on 2021/9/24.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import LGSwiftKit


class LGCarouselDemoViewController: UIViewController, LGCarouselDelegate, LGCarouselDataSource {

    var isPage = true
    var isCycle = true
    var isAutoPlay = false
    var clipBoundary = true
   
    lazy var carousel:LGCarousel = {
        let carousel = LGCarousel(frame: CGRect(x: 20, y: CGFloat.navbar_statusbar_height+10, width: CGFloat.screen_width-40, height: 160))
        carousel.itemSize = CGSize.init(width: CGFloat.screen_width-80, height: 160)
        carousel.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        carousel.registerClass(itemClass: LGCarouselImageItemView.self, reuseIdentifier: "LGCarouselImageItemView")
        carousel.layer.borderColor = UIColor.red.cgColor
        carousel.layer.borderWidth = 1
        return carousel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.initUI()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initUI() -> Void {
        self.carousel.pageEnabled = self.isPage
        self.carousel.cycleEnabled = self.isCycle
        self.carousel.autoPlayEnabled = self.isAutoPlay
        self.carousel.shouldClipBoundary = self.clipBoundary
        self.carousel.delegate = self
        self.carousel.dataSource = self
        self.view.addSubview(self.carousel)
        self.carousel.reloadData()
        var yTemp: CGFloat = self.carousel.frame.maxY+20.0
        for i in 0..<4{
            let button = UIButton()
            button.tag = i
            self.resetButtonTitle(button)
            button.frame = CGRect(x: 10, y: yTemp, width:150, height: 30)
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            self.view.addSubview(button)
            yTemp = button.frame.maxY+20
            button.addTarget(self, action: #selector(self.buttonClick(_:)), for: UIControlEvents.touchUpInside)
        }
    }

    
    func carouselDidItemIndexChanged(_ carousel: LGCarousel, itemIndex: UInt) {
        
    }
    
    func carouselDidClick(_ carousel: LGCarousel, itemIndex: UInt) {
        
    }
    
    func carouselItemsCount(_ carousel: LGCarousel) -> UInt {
        return 10
    }
    
    func carouselItemView(_ carousel: LGCarousel, itemView: LGCarouselItemView, itemIndex: UInt) {
        (itemView as! LGCarouselImageItemView).imageView.image = UIImage.init(contentsOfFile:  Bundle.main.path(forResource: String(format: "scenery_%lu", itemIndex+1), ofType: "JPG")!)
    }
    
    @objc func buttonClick(_ button: UIButton) -> Void {
        switch button.tag {
        case 0:
            self.isPage = !self.isPage
            self.carousel.pageEnabled = self.isPage
        case 1:
            self.isCycle = !self.isCycle
            self.carousel.cycleEnabled = self.isCycle
        case 2:
            self.isAutoPlay = !self.isAutoPlay
            self.carousel.autoPlayEnabled = self.isAutoPlay
        case 3:
            self.clipBoundary = !self.clipBoundary
            self.carousel.shouldClipBoundary = self.clipBoundary
        default:
            break
        }
        self.resetButtonTitle(button)
    }
    
    func resetButtonTitle(_ button: UIButton) -> Void {
        switch button.tag {
        case 0:
            button.setTitle(self.isPage ? "翻页" : "不翻页", for: UIControlState.normal)
        case 1:
            button.setTitle(self.isCycle ? "循环" : "不循环", for: UIControlState.normal)
        case 2:
            button.setTitle(self.isAutoPlay ? "自动播放" : "不自动播放", for: UIControlState.normal)
        case 3:
            button.setTitle(self.clipBoundary ? "左右剪裁" : "左右不剪裁", for: UIControlState.normal)
        default:
            break
        }
    }
    
    
}
