//
//  ViewController.swift
//  LGSwiftKit
//
//  Created by Liu Gai 刘盖 on 09/23/2021.
//  Copyright (c) 2021 Liu Gai 刘盖. All rights reserved.
//

import UIKit
import LGSwiftKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    private var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        
        return tableView
    }()
    
    private var dataSource: Array = {
        return ["轮播demo","Hud(loading, toast)", "String扩展", "scroll联动"]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.initUI()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initUI() -> Void {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.view.addSubview(self.tableView)
        self.tableView.frame = CGRect(x: 0, y: CGFloat.statusbar_height, width: CGFloat.screen_width, height: CGFloat.screen_height-CGFloat.statusbar_height-CGFloat.tabbar_safe_height)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = self.dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var vc:UIViewController?
        
        switch indexPath.row {
        case 0:
            vc = LGCarouselDemoViewController()
        case 1:
            vc = LGHudDemoViewController()
        case 2:
            print("app名称："+String.appName())
            print("app版本："+String.appVersion())
            print("手机系统版本："+String.sys_version)
        case 3:
            vc = LGScrollLinkDemoViewController()
        default: break
        }
        
        if let vc = vc {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
}

