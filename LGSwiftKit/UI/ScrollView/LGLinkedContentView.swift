//
//  LGLinkedContentView.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/10/20.
//

import UIKit

public protocol LGLinkedContentProtocol: UIResponder {
    //MARK: scroll视图所在page根视图，只声明，不直接设置
    var rootView: UIView? { get set }
    //MARK: 是否能够滚动判断回调，声明即可
    var superCanScrollBlock: ((_ superCanScroll: Bool)->Void)? { get set }
    //MARK: scrollView，只声明，不直接设置
    var scrollView: UIScrollView? { get set }
    //MARK: 当前page是否能够滚动，声明即可
    var canScroll: Bool { get set }
    //MARK: 只实现，不调用
    func setupUI()
}

extension LGLinkedContentProtocol {
    
    public func setupScrollView(scrollView: UIScrollView, scrollSuper: UIView){
        if let scroll = self.scrollView {
            scroll.removeObserver(self, forKeyPath: "contentOffset")
            scroll.removeFromSuperview()
            self.scrollView = nil
        }
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
        scrollSuper.addSubview(scrollView)
        self.scrollView = scrollView
        self.scrollView?.frame = scrollSuper.bounds
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    public func setupRootView(rootView: UIView){
        if let view = self.rootView {
            view.removeObserver(self, forKeyPath: "frame")
            self.rootView = nil
        }
        
        self.rootView = rootView
        rootView.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    //MARK: 需要在observer监听中调用此方法
    public func observerChanged(keyPath: String?) {
        if let kPath = keyPath, let scroll = self.scrollView, kPath == "contentOffset" {
            DispatchQueue.main.async {
                if !self.canScroll {
                    scroll.contentOffset = CGPoint(x: 0, y: 0)
                }
                else{
                    if scroll.contentOffset.y<=0 {
                        DispatchQueue.main.async {
                            scroll.contentOffset = CGPoint(x: 0, y: 0)
                        }
                        self.canScroll = false
                        if let scrollBlock = self.superCanScrollBlock {
                            scrollBlock(true)
                        }
                    }

                }
            }

        }

        if let kPath = keyPath, let rootView = self.rootView, kPath == "frame" {
            DispatchQueue.main.async {
                self.scrollView?.frame = rootView.bounds
            }

        }
    }
    
    //MARK: - deinit时调用
    public func removeAllObserver() {
        if let scroll = scrollView {
            scroll.removeObserver(self, forKeyPath: "contentOffset")
        }
        if let rootView = rootView {
            rootView.removeObserver(self, forKeyPath: "frame")
        }
    }
}
