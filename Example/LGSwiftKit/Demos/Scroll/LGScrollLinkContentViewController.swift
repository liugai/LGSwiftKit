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
    
    // MARK: - LGLinkedContentProtocol协议中的属性
    weak var rootView: UIView?
    
    var superCanScrollBlock: ((_ superCanScroll: Bool)->Void)?

    var canScroll: Bool = false
    
    var scrollView: UIScrollView?
    
    // MARK: - 自有属性
    var tableTitle: String?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: 必须实现
    func setupUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setupRootView(rootView: self.view)
        self.setupScrollView(scrollView: self.tableView, scrollSuper: self.view)
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

    // MARK: 必须实现
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.observerChanged(keyPath: keyPath)
    }
    
    deinit {
        // MARK: 必须实现
        self.removeAllObserver()
    }
}
