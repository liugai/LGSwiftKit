//
//  LGMainScrollLinkedView.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/10/20.
//

import UIKit

@objc public protocol LGMainScrollLinkedViewDelegate: NSObjectProtocol {
    func scrollLinkedPageChanged(pageIndex: UInt) -> Void;
}

public class LGMainScrollLinkedView: UIView, UIScrollViewDelegate {
    
    //MARK: - 私有属性
    private lazy var mainScrollView: LGLinkedScrollView = {
        return LGLinkedScrollView()
    }()
    
    private var mainCanScroll = true

    public var currentContentView: LGLinkedContentProtocol?
    
    private var pageViews: Array<LGLinkedContentProtocol>?
    
    private lazy var scrollContainerView: UIScrollView = {
        return UIScrollView()
    }()

    //MARK: - 公开属性
    public weak var delegate: LGMainScrollLinkedViewDelegate?
    
    
    // header视图， 可以自定义一个视图插入,比如头图、
    public lazy var headerView: UIView = {
        return UIView()
    }()
    
    // 置顶视图，可以自定义一个视图插入,比如segment、
    public lazy var fixedView: UIView = {
        return UIView()
    }()
    
    

    // MARK: - 初始化
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
        self.addSubview(self.mainScrollView)
        self.mainScrollView.addSubview(self.headerView)
        self.mainScrollView.addSubview(self.fixedView)
        self.mainScrollView.addSubview(self.scrollContainerView);
        self.mainScrollView.delegate = self
        self.scrollContainerView.delegate = self
        self.scrollContainerView.isPagingEnabled = true
        
        self.mainScrollView.panGestureRecognizer.require(toFail: self.scrollContainerView.panGestureRecognizer)
    }
    
    // MARK: - frame设置
    private func refreshFrame() {
        self.mainScrollView.frame = self.bounds
        self.scrollContainerView.frame = CGRect(x: 0, y: self.fixedView.frame.maxY, width: self.bounds.size.width, height: self.bounds.size.height-self.fixedView.frame.height)
        if let pages = self.pageViews {
            var originX: CGFloat = 0
            for pageObj in pages {
                pageObj.rootView?.frame = CGRect(x: originX, y: 0, width: self.scrollContainerView.bounds.size.width, height: self.scrollContainerView.bounds.size.height)
                if let rootView = pageObj.rootView {
                    originX = rootView.frame.maxX
                }
                
            }
            
            self.scrollContainerView.contentSize = CGSize(width: self.scrollContainerView.frame.width*CGFloat(pages.count), height: self.scrollContainerView.frame.height)
            self.mainScrollView.contentSize = CGSize(width: self.bounds.width, height: self.headerView.frame.height+self.fixedView.frame.height+self.mainScrollView.frame.height);
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
    
    // MARK: - 外部调用
    public func updateHeaderFrame(frame:CGRect) {
        self.headerView.frame = frame
        self.refreshFrame()
    }
    
    public func updateFixedFrame(frame:CGRect) {
        self.fixedView.frame = frame
        self.refreshFrame()
    }
    
    public func setPage(page: UInt) {
        guard let pages = self.pageViews else {
            return
        }
        if page <= pages.count-1 {
            self.scrollContainerView.setContentOffset(CGPoint(x: CGFloat(page)*self.scrollContainerView.frame.width, y: 0), animated: true)
        }
    }
    
    public func setupPageViews(_ pageViews: Array<LGLinkedContentProtocol>?) {
        if let pages = self.pageViews {
            for pageObj in pages {
                pageObj.rootView?.removeFromSuperview()
            }
            self.pageViews = nil
            self.mainCanScroll = true
        }
        if let pages = pageViews {
            for pageObj in pages {
                if let rootView = pageObj.rootView {
                    self.scrollContainerView.addSubview(rootView)
                    pageObj.superCanScrollBlock = { [weak self](superCanScroll) in
                        self?.mainCanScroll = superCanScroll
                    }
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
            if !self.mainCanScroll {
                scrollView.contentOffset = CGPoint(x: 0, y: self.fixedView.frame.minY)
                self.currentContentView?.canScroll = true
            } else {
                if scrollView.contentOffset.y >= self.fixedView.frame.minY {
                    scrollView.contentOffset = CGPoint(x: 0, y: self.fixedView.frame.minY);
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
            self.currentContentView = self.pageViews?[Int(page)]
            if let delegate = self.delegate, delegate.responds(to: #selector(delegate.scrollLinkedPageChanged(pageIndex:))) {
                delegate.scrollLinkedPageChanged(pageIndex: page)
            }
        }
    }
   
    
}


class LGLinkedScrollView: UIScrollView, UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
