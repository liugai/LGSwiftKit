//
//  LGLinkedContentView.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/10/20.
//

import UIKit

public protocol LGLinkedContentProtocol: UIResponder {
    var linkedContentView: LGLinkedContentView { get set}
    func setupUI();
}


public class LGLinkedContentView: UIView {

    public weak var _rootView: UIView?
    public weak var rootView: UIView? {
        get {
            return _rootView
        }
    }
    var superCanScrollBlock: ((_ superCanScroll: Bool)->Void)?
    private var _scrollView: UIScrollView?
    private var _canScroll: Bool = false
    
    public var canScroll: Bool {
        get {
            return _canScroll
        }
        set {
            _canScroll = newValue
        }
    }
    
    public var scrollView: UIScrollView? {
        get {
            return _scrollView
        }
        set {
            _scrollView = newValue
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView?.frame = self.bounds
    }
    
    public func setupScrollView(scrollView: UIScrollView){
        if let scroll = self.scrollView {
            scroll.removeObserver(self, forKeyPath: "contentOffset")
            scroll.removeFromSuperview()
            self.scrollView = nil
        }
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
        self.addSubview(scrollView)
        self.scrollView = scrollView
        self.scrollView?.frame = self.bounds
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    public func setupRootView(rootView: UIView){
        if let view = self.rootView {
            view.removeObserver(self, forKeyPath: "frame")
            _rootView = nil
        }
        
        _rootView = rootView
        rootView.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
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
                self.frame = rootView.bounds
            }
            
        }
    }
    
    deinit {
        if let scroll = scrollView {
            scroll.removeObserver(self, forKeyPath: "contentOffset")
        }
        
        if let rootView = rootView {
            rootView.removeObserver(self, forKeyPath: "frame")
        }
    }
}
