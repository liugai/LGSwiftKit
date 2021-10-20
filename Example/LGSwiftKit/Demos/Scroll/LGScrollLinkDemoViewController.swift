//
//  LGScrollLinkDemoViewController.swift
//  LGSwiftKit_Example
//
//  Created by 刘盖 on 2021/10/20.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import LGSwiftKit

class LGScrollLinkDemoViewController: UIViewController {
    
    lazy var linkedScrollView: LGMainScrollLinkedView = {
        return LGMainScrollLinkedView(frame: CGRect(x: 0, y: 0, width: CGFloat.screen_width, height: CGFloat.screen_height))
    }()

    var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["推荐","兴趣","爱好"])
        segment.selectedSegmentIndex = 0
        return segment
    }()
    lazy var segmentView: UIView = {
        return UIView()
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.initUI()
        // Do any additional setup after loading the view.
    }
    
    func initUI() -> Void {
        self.segmentControl.addTarget(self, action: #selector(self.segmentValueChanged(segment:)), for: UIControlEvents.valueChanged)
        self.segmentView.addSubview(self.segmentControl)
        
        self.view.addSubview(self.linkedScrollView)
        self.linkedScrollView.headerView.addSubview(self.segmentView)
        self.linkedScrollView.headerView.backgroundColor = UIColor.cyan
        self.linkedScrollView.updateHeaderFrame(frame: CGRect(x: 0, y: 0, width: CGFloat.screen_width, height: 200))
        self.setupScrollContents()
    }
    
    func setupScrollContents() {
        var array: Array<LGLinkedContentView> = []
        for i in 0..<4 {
            let view = LGLinkedContentView(frame: CGRect.zero)
            let scroll = UIScrollView()
            scroll.backgroundColor = UIColor.lg_rgb(CGFloat(i)*50.0, CGFloat(i)*50.0, CGFloat(i)*50.0)
            view.setupScrollView(scrollView: scroll)
            array.append(view)
        }
        self.linkedScrollView.setupPageViews(array)
    }

    @objc func segmentValueChanged(segment: UISegmentedControl) -> Void {
        
    }


}
