//
//  LGScrollLinkDemoViewController.swift
//  LGSwiftKit_Example
//
//  Created by 刘盖 on 2021/10/20.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import LGSwiftKit

class LGScrollLinkDemoViewController: UIViewController, LGMainScrollLinkedViewDelegate{
    
    lazy var linkedScrollView: LGMainScrollLinkedView = {
        return LGMainScrollLinkedView(frame: CGRect(x: 0, y: CGFloat.navbar_statusbar_height, width: CGFloat.screen_width, height: CGFloat.screen_height-CGFloat.navbar_statusbar_height))
    }()

    var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["推荐","兴趣","爱好"])
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.initUI()
        // Do any additional setup after loading the view.
    }
    
    func initUI() -> Void {
        self.segmentControl.addTarget(self, action: #selector(self.segmentValueChanged(segment:)), for: UIControlEvents.valueChanged)
        self.linkedScrollView.delegate = self
        self.view.addSubview(self.linkedScrollView)
        self.linkedScrollView.headerView.backgroundColor = UIColor.cyan
        self.linkedScrollView.updateHeaderFrame(frame: CGRect(x: 0, y: 0, width: CGFloat.screen_width, height: 150))
        self.linkedScrollView.fixedView.backgroundColor = UIColor.gray
        self.linkedScrollView.fixedView.addSubview(self.segmentControl)
        self.segmentControl.center = CGPoint(x: CGFloat.screen_width/2, y: self.segmentControl.center.y)
        self.linkedScrollView.updateFixedFrame(frame: CGRect(x: 0, y: self.linkedScrollView.headerView.frame.maxY, width: CGFloat.screen_width, height: self.segmentControl.frame.height))
        self.setupScrollContents()
    }
    
    func setupScrollContents() {
        var array: Array<LGLinkedContentProtocol> = []
        for item in ["推荐","兴趣","爱好"] {
            let view = LGScrollLinkContentViewController()
            view.tableTitle = item
            view.setupUI()
            array.append(view)
        }
        self.linkedScrollView.setupPageViews(array)
    }

    @objc func segmentValueChanged(segment: UISegmentedControl) -> Void {
        self.linkedScrollView.setPage(page: UInt(segment.selectedSegmentIndex))
    }

    // MARK: LGMainScrollLinkedViewDelegate
    func scrollLinkedPageChanged(pageIndex: UInt) {
        self.segmentControl.selectedSegmentIndex = Int(pageIndex)
    }
}
