//
//  LGMainScrollLinkedView.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/10/20.
//

import UIKit

public protocol LGMainScrollLinkedViewDelegate: NSObjectProtocol {
    func pageChanged(pageIndex: UInt) -> Void;
}

public class LGMainScrollLinkedView: UIView, UIScrollViewDelegate {

    public weak var delegate: LGMainScrollLinkedViewDelegate?
    
    private lazy var mainScrollView: LGLinkedScrollView = {
        return LGLinkedScrollView()
    }()
    public lazy var scrollContainerView: UIScrollView = {
        return UIScrollView()
    }()
    // 可以自定义一个视图插入,比如头图、segment
    public lazy var headerView: UIView = {
        return UIView()
    }()
    
    private var mainCanScroll = true

    public var currentContentView: LGLinkedContentView?
    
    private var pageViews: Array<LGLinkedContentView>?

    // MARK: - 初始化
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        self.addSubview(self.mainScrollView)
        self.mainScrollView.addSubview(self.headerView)
        self.mainScrollView.addSubview(self.scrollContainerView);
        self.mainScrollView.delegate = self
        self.scrollContainerView.delegate = self
        self.scrollContainerView.isPagingEnabled = true
    }
    
    // MARK: - frame设置
    private func refreshFrame() {
        self.mainScrollView.frame = self.bounds
        self.scrollContainerView.frame = CGRect(x: 0, y: self.headerView.frame.maxY, width: self.bounds.size.width, height: self.bounds.size.height)
        if let pages = self.pageViews {
            var originX: CGFloat = 0
            for view in pages {
                view.frame = CGRect(x: originX, y: 0, width: self.scrollContainerView.bounds.size.width, height: self.scrollContainerView.bounds.size.height)
                originX = view.frame.maxX
            }
            
            self.scrollContainerView.contentSize = CGSize(width: self.scrollContainerView.frame.width*CGFloat(pages.count), height: self.scrollContainerView.frame.height)
            self.mainScrollView.contentSize = CGSize(width: self.bounds.width, height: self.headerView.frame.height+self.scrollContainerView.frame.height);
        }
        else {
            self.scrollContainerView.contentSize = CGSize.zero
            self.mainScrollView.contentSize = CGSize.zero
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.refreshFrame()
    }
    
    public func updateHeaderFrame(frame:CGRect) {
        self.headerView.frame = frame
        self.refreshFrame()
    }
    
    public func setupPageViews(_ pageViews: Array<LGLinkedContentView>?) {
        if let pages = self.pageViews {
            for view in pages {
                view.removeFromSuperview()
            }
            self.pageViews = nil
            self.mainCanScroll = true
        }
        if let pages = pageViews {
            for view in pages {
                self.scrollContainerView.addSubview(view)
                view.superCanScrollBlock = { [weak self](superCanScroll) in
                    self?.mainCanScroll = superCanScroll
                }
            }
            self.pageViews = pageViews
            self.currentContentView = pages.first
            self.refreshFrame()
        }
    }
    
    
    // MARK: - scroll delegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.mainScrollView {
            self.headerView.isHidden = (scrollView.contentOffset.y>=self.headerView.frame.height)
            if !self.mainCanScroll {
                scrollView.contentOffset = CGPoint(x: 0, y: self.headerView.frame.height)
                self.currentContentView?.canScroll = true
            } else {
                if scrollView.contentOffset.y >= self.headerView.frame.height {
                    scrollView.contentOffset = CGPoint(x: 0, y: self.headerView.frame.height);
                    self.mainCanScroll = false
                    self.currentContentView?.canScroll = true
                }
            }
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.handleContentScroll(scrollView: scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.handleContentScroll(scrollView: scrollView)
    }

    private func handleContentScroll(scrollView: UIScrollView) -> Void {
        if scrollView == self.scrollContainerView {
            let page: UInt = UInt(self.scrollContainerView.contentOffset.x/max(1, self.scrollContainerView.frame.width))
            if let delegate = self.delegate {
                delegate.pageChanged(pageIndex: page)
            }
        }
    }
   
    
}
