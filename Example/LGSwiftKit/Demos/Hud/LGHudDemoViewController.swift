//
//  LGHudDemoViewController.swift
//  LGSwiftKit_Example
//
//  Created by 刘盖 on 2021/10/12.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import LGSwiftKit

class LGHudDemoViewController: UIViewController {
    
    var hudSuperView: UIView?
    var style: LGHudColorStyle = .dark

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let temp = "adfa"
        var array = ["样式", "隐藏"]
        var yTemp: CGFloat = CGFloat.navbar_statusbar_height+20.0
        for i in 0..<array.count{
            let button = UIButton()
            button.tag = i
            button.setTitle(array[i], for: UIControlState.normal)
            button.frame = CGRect(x: 150, y: yTemp, width:150, height: 30)
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            self.view.addSubview(button)
            yTemp = button.frame.maxY+20
            button.addTarget(self, action: #selector(self.setClick(_:)), for: UIControlEvents.touchUpInside)
        }
        
        yTemp = CGFloat.navbar_statusbar_height+20.0
        array = ["loading","文本+loading", "文本", "样式+loading"]
        for i in 0..<array.count{
            let button = UIButton()
            button.tag = i
            button.setTitle(array[i], for: UIControlState.normal)
            button.frame = CGRect(x: 0, y: yTemp, width:150, height: 30)
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            self.view.addSubview(button)
            yTemp = button.frame.maxY+20
            button.addTarget(self, action: #selector(self.buttonClick(_:)), for: UIControlEvents.touchUpInside)
        }
        
        
        
        self.hudSuperView = UIView(frame: CGRect(x: 0, y: yTemp, width: CGFloat.screen_width, height: CGFloat.screen_height-yTemp))
        self.hudSuperView?.backgroundColor = UIColor.lightGray
        self.view.addSubview(self.hudSuperView!)
        // Do any additional setup after loading the view.
    }
    
    @objc func buttonClick(_ button: UIButton) -> Void {
        switch button.tag {
        case 0:
            LGProgressHud.showLoading(container: self.hudSuperView)
        case 1:
            LGProgressHud.showLoading(container: self.hudSuperView, text: "加载中...")
        case 2:
            LGProgressHud.showText(text: "测试长文本toast测试长文本toast测试长文本toast测试长文本toast测试长文本toast", container: self.hudSuperView)
        case 3:
            LGProgressHud.show(container: self.hudSuperView, style: self.style, hudType: .textloading, duration: 0, text: nil, compeletion: nil)
        default:
            break
        }
    }
    
    @objc func setClick(_ button: UIButton) -> Void {
        switch button.tag {
        case 0:
            self.style = (style == .dark ? .light : .dark)
        case 1:
            LGProgressHud.dismiss(container: self.hudSuperView)
        default:
            break
        }
    }

}
