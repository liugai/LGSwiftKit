//
//  LGScrollLinkContentViewController.swift
//  LGSwiftKit_Example
//
//  Created by 刘盖 on 2021/10/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import LGSwiftKit
class LGScrollLinkContentViewController: UIViewController, LGLinkedContentProtocol, UITableViewDataSource, UITableViewDelegate {
    
    
    var tableTitle: String?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        return tableView
    }()
    
    lazy var linkedContentView: LGLinkedContentView = {
        let contentView = LGLinkedContentView(frame: CGRect.zero)
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func setupUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.linkedContentView)
        self.linkedContentView.setupRootView(rootView: self.view)
        self.linkedContentView.setupScrollView(scrollView: self.tableView)
    }
    
    
    
    // MARK: tableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") ?? UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "UITableViewCell")
        cell.textLabel?.text = self.tableTitle
        return cell
    }

}
