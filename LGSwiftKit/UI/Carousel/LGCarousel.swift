//
//  LGCarousel.swift
//  LGCarousel
//
//  Created by 刘盖 on 2021/9/23.
//

import UIKit

open class LGCarousel: UIView {
    
    
    
    weak open var delegate: LGCarouselDelegate?
    weak open var dataSource: LGCarouselDataSource?
    
    // MARK: 私有属性
    /// 是否循环,默认NO
    private var _cycleEnabled: Bool = false
    /// 是否是翻页模式,默认YES
    private var _pageEnabled: Bool = true
    /// 是否自动轮播，只有循环的情况下生效,默认NO
    private var _autoPlayEnabled: Bool = false
    /// 左右超出部分是否剪裁掉，默认yes剪裁，左右超出部分不露出，不会显示其他item，
    /// 如果设置NO，超出部分显示，需要配合contentInset、itemSize.width、itemSpace使用
    private var _shouldClipBoundary: Bool = true
    /// 自动轮播时间间隔
    private var _timerInterval:TimeInterval = 3
    /// 需要注意的是，只有contentInset.left+contentInset.right+itemSpace+itemSize.width == 轮播视图宽度时，翻页模式、循环模式、自动轮播才能生效
    /// item间隔
    private var _itemSpace: CGFloat = 0
    /// item size 滚动视图所在父视图，距离整个容器的边距，默认都为UIEdgeInsetsZero， 四个值必须非负
    private var _contentInset: UIEdgeInsets = UIEdgeInsets.zero
    /// item size 不能超过整个容器的frame size
    private var _itemSize: CGSize = CGSize.zero
    
    
    // MARK: 私有属性
    /// item数量
    private var itemsCount:UInt = 0
    ///定时器
    private var timer: Timer?
    /// 当前展示索引位
    private var currentIndexPath: LGCarouselIndexPath = LGCarouselIndexPath(itemIndex: 0, pageIndex: 0)
    /// 滚动宽度
    private var contentWidth: CGFloat = 0
    /// 是否可点击
    private var isClickEnabled = false
    /// item 类
    private var itemClass: LGCarouselItemView.Type?

    /// 重用标识，暂时不支持创建不同itemView
    private var reuseIdentifier: String?
    
    // MARK: 懒加载
    /// 缓存池视图
    private var arrayCacheViews: Array<LGCarouselItemView> = {
        return Array()
    }()

    /// 能够重用的视图，该数组只增不减，除非整个容器视图销毁
    private var arrayReuseViews: Array<LGCarouselItemView> = {
        return Array()
    }()

    /// 可视范围的indexPaths
    private var visibleItemIndexs: Array<LGCarouselIndexPath> = {
        return Array()
    }()

    /// 可视范围的itemViews
    private var visibleItemViews: Array<LGCarouselItemView> = {
        return Array()
    }()

    /// scroll容器
    private var containerView: UIView = {
        return UIView()
    }()

    /// scrollView
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        return scrollView
    }()

    

    // MARK: 方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 刷新数据
    open func reloadData() -> Void {
        self.stopTimer()
        self.clearContents()
        self.resetProperties()
        if (self.frame.size.width == 0 || self.frame.size.height == 0) {
            return
        }
        self.resetSubFrames()
        self.resetReuseViews()
        self.resetLayout()
        self.startTimer()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.reloadData()
    }

    private func initUI() -> Void {
        self.scrollView.delegate = self
        _pageEnabled = true
        _cycleEnabled = false
        _shouldClipBoundary = true
        self.clipsToBounds = true
        self.containerView.clipsToBounds = true
        self.addSubview(self.containerView)
        self.containerView.addSubview(self.scrollView)
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        }
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.containerTapAction))
        tapGesture.delegate = self
        self.containerView.addGestureRecognizer(tapGesture)
    }
    
    private func isPageEnabled() -> Bool {
        if ((self.itemSize.width+self.itemSpace) != self.scrollView.frame.size.width) {
            return false
        }
        return self.pageEnabled
    }

    private func isCycleEnabled() -> Bool {
        if ((self.itemSize.width+self.itemSpace) != self.scrollView.frame.size.width) {
            return false
        }
        if (self.itemsCount<=1) {
            return false
        }
        return self.cycleEnabled;
    }
    
    private func pageWidth() -> CGFloat {
        return self.itemSize.width+self.itemSpace
    }
    
    deinit {
        debugPrint("%@ dealloc", self)
    }
}


// MARK: - 注册itemView
extension LGCarousel {
    /// 必须调用该方法
    /// @param itemClass 必须继承自RCarouselItemView，且必须使用init方法初始化
    /// @param reuseIdentifier 重用标识
    open func registerClass(itemClass: LGCarouselItemView.Type, reuseIdentifier: String) -> Void{
        self.itemClass = itemClass
        self.reuseIdentifier = reuseIdentifier
        self.assertHandle()
    }
    
    
    private func assertHandle() -> Void {
        assert(self.itemClass != nil, "必须注册item类视图")
        assert(!String.isEmpty(str: self.reuseIdentifier), "重用标识必须有效")
    }
}

// MARK: - reload
extension LGCarousel {
    
    private func resetProperties() {
        self.isClickEnabled = false
        self.itemsCount = 0
        if let dataSource = self.dataSource, dataSource.responds(to: #selector(dataSource.carouselItemsCount(_:))) {
            self.itemsCount = dataSource.carouselItemsCount!(self)
        }
       
        if (self.itemsCount<1) {
            self.currentIndexPath =  LGCarouselIndexPath(itemIndex: 0, pageIndex: 0)
            return;
        }

        if (self.itemsCount==1) {
            self.currentIndexPath =  LGCarouselIndexPath(itemIndex: 0, pageIndex: 0)
            return
        }
       
        if (self.isCycleEnabled()) {
            self.currentIndexPath = LGCarouselIndexPath(itemIndex: self.currentIndexPath.itemIndex, pageIndex: self.currentIndexPath.itemIndex+1)
        }
        else {
            self.currentIndexPath = LGCarouselIndexPath(itemIndex: self.currentIndexPath.itemIndex, pageIndex: self.currentIndexPath.itemIndex)
        }
    }



    private func resetSubFrames() {
        self.containerView.frame = CGRect(x: self.contentInset.left, y: self.contentInset.top, width: self.frame.size.width-self.contentInset.left-self.contentInset.right, height: self.frame.size.height-self.contentInset.top-self.contentInset.bottom);
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height);
        if (self.itemsCount <= 1) {
            self.contentWidth = self.pageWidth();
        }
        else {
            if (self.isCycleEnabled()) {
                self.contentWidth = CGFloat(self.itemsCount+2)*self.pageWidth()
            }
            else {
                self.contentWidth = CGFloat(self.itemsCount)*self.pageWidth()
            }
        }
        self.scrollView.contentSize = CGSize(width: self.contentWidth, height: self.scrollView.frame.size.height);
        if (self.itemsCount <= 1) {
            self.scrollView.isScrollEnabled = false
        }
        else {
            self.scrollView.isScrollEnabled = true
        }
        self.scrollView.isPagingEnabled = self.isPageEnabled()
    }

    private func clearContents() {
        self.visibleItemIndexs.removeAll()
        self.visibleItemViews.removeAll()
        if self.arrayReuseViews.count>0 {
            for view in self.arrayReuseViews {
                view.isHidden = true
            }
        }
    }

    private func resetReuseViews() {
        if (self.arrayReuseViews.count>0) {
            self.arrayCacheViews = self.arrayReuseViews
        }
        self.initReuseArray(itemIndex: self.currentItemIndex)
    }

    private func resetLayout() {
        self.stopTimer()
        if (self.itemsCount < 1) {
            self.scrollView.setContentOffset(CGPoint.zero, animated: false)
            self.isClickEnabled = false
            return
        }
        self.resetCurrentItemIndex(currentItemIndex: self.currentItemIndex)
    }

}

// MARK: - 计算属性，外部可设置
extension LGCarousel {

    /// 当前index
    open var currentItemIndex: UInt {
        get {
            return self.currentIndexPath.itemIndex
        }
    }
    
    open var cycleEnabled: Bool {
        get {
            return _cycleEnabled
        }
        set {
            if newValue != _cycleEnabled {
                _cycleEnabled = newValue;
                self.reloadData()
            }
        }
    }
    
    open var pageEnabled: Bool {
        get {
            return _pageEnabled
        }
        set {
            if newValue != _pageEnabled {
                _pageEnabled = newValue;
                self.reloadData()
            }
        }
    }
    
    open var autoPlayEnabled: Bool {
        get {
            return _autoPlayEnabled
        }
        set {
            if newValue != _autoPlayEnabled {
                _autoPlayEnabled = newValue;
                self.reloadData()
            }
        }
    }
    
    open var shouldClipBoundary: Bool {
        get {
            return _shouldClipBoundary
        }
        set {
            if newValue != _shouldClipBoundary {
                _shouldClipBoundary = newValue;
                self.containerView.clipsToBounds = _shouldClipBoundary
                self.reloadData()
            }
        }
    }

    /// item间距  不能超过item宽度
    open var itemSpace: CGFloat {
        get {
            if (_itemSpace<0) {
                return 0
            }
            return _itemSpace
        }
        set {
            _itemSpace = newValue
        }
    }
    
    open var contentInset: UIEdgeInsets {
        get {
            if (_contentInset.bottom<0 || _contentInset.top<0 || _contentInset.left<0 || _contentInset.right<0) {
                return UIEdgeInsets.zero
            }
            var edge = _contentInset;
            // 左右间距之和，必须小于整体宽度，否则左右间距都为0
            if (edge.left+edge.right>self.frame.size.width) {
                edge.left = 0
                edge.right = 0
            }
            // 上下间距之和+itemSize.height，必须小于整体高度，否则上下间距都为0
            if (_contentInset.top+_contentInset.bottom+self.itemSize.height>self.frame.size.height) {
                edge.top = 0;
                edge.bottom = 0;
            }
            return edge
        }
        set {
            _contentInset = newValue
        }
    }
    
    /// item间距  不能超过item宽度
    open var itemSize: CGSize {
        get {
            var size = _itemSize
            /// 高度不能超过scroll容器高度
            if (size.height>self.containerView.frame.size.height) {
                size.height = self.containerView.frame.size.height
            }
            /// 宽度不能为0
            if (size.width <= 0) {
                size.width = self.containerView.frame.size.width;
            }
            return size
        }
        set {
            _itemSize = newValue
        }
    }

    open var timerInterval: TimeInterval {
        get {
            return _timerInterval
        }
        set {
            if newValue != _timerInterval{
                _timerInterval = newValue
                if _timerInterval == 0 {
                    _autoPlayEnabled = false
                }
                self.reloadData()
            }
            
        }
    }
}

// MARK: -  UIScrollViewDelegate
extension LGCarousel: UIScrollViewDelegate {
    
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stopTimer()
        self.isClickEnabled = false
    }
  
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.didContentOffsetChanged()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollOver()
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollOver()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollOver()
        }
    }
  
    private func scrollOver() {
        self.isClickEnabled = true
        self.resetCurrentIndexPath()
        self.startTimer()
    }
    
}

// MARK: - 视图位置、复用等处理
extension LGCarousel {
    /// 指定当前展示的视图
    /// @param currentItemIndex 当前需要展示视图的index
    open func resetCurrentItemIndex(currentItemIndex: UInt) -> Void{
        let indexPathTemp = self.transformIndexPathFromItemIndex(currentItemIndex)
        if ((indexPathTemp == nil || (indexPathTemp!.itemIndex ==  self.currentIndexPath.itemIndex)) && self.visibleItemViews.count>0) {
            return;
        }
        self.currentIndexPath = indexPathTemp!
        var offsetPoint:CGPoint = CGPoint.zero;
        if (self.itemsCount>1) {
            offsetPoint = CGPoint(x:self.pageWidth()*CGFloat(self.currentIndexPath.pageIndex), y: 0);
        }
        self.scrollView.setContentOffset(offsetPoint, animated: false)
        self.didContentOffsetChanged()
        self.resetCurrentIndexPath()
        self.isClickEnabled = true
    }
    
    // MARK: contentOffset发生变化
    private func didContentOffsetChanged() {
        self.didContentOffsetReachCriticalValue()
        self.resetVisibleItemIndexPaths()
        let lastItemViews = self.visibleItemViews
        var arrayUsedItems: Array<LGCarouselItemView> = Array();
        var arrayUsedIndexPaths = Array(self.visibleItemIndexs)
        // 有可能存在索引相同的视图
        // 可能存在多个视图对应同一个索引
        for itemView in lastItemViews {
            // 如国已显示视图的indexPath在可视数组包中，说明这个视图会被再次使用
            if arrayUsedIndexPaths.contains(itemView.indexPath) {
                arrayUsedItems.append(itemView)
                arrayUsedIndexPaths.remove(at: arrayUsedIndexPaths.index(of: itemView.indexPath)!)
            }
            else {
                self.pushToCacheArray(itemView: itemView)
            }
        }

        // 如果当前视图存在与即将显示的可视集合中
        for indexPath in self.visibleItemIndexs {
            let itemView = self.getExistItemInVisible(indexPath: indexPath, arrayItems: arrayUsedItems)
            if let itemView = itemView {
                arrayUsedItems.remove(at: arrayUsedItems.index(of: itemView)!)
            }
            self.setupShow(indexPath: indexPath, itemView: itemView)
        }
        
        debugPrint("开始打印")
        debugPrint("caches: %@",self.arrayCacheViews)
        debugPrint("reuses: %@",self.arrayReuseViews)
        debugPrint("visibles: %@",self.visibleItemViews)
        debugPrint("visibleIndexPaths: %@",self.visibleItemIndexs)
        debugPrint("结束打印")
    }

    // MARK: 滚动达到临界点时进行处理，只有循环滚动时才需要处理
    private func didContentOffsetReachCriticalValue() {
        // 非循环模式，可直接计算可视范围应该显示的indexPath
        if (self.isCycleEnabled()) {
            // 循环模式下，在计算可视范围应该显示的indexPath时，
            // 保证contentOffsetX始终是一个正值
            let  contentOffsetX = self.scrollView.contentOffset.x
            let pageWidth = self.pageWidth()
            var finalOffsetX:CGFloat = 0
            if (contentOffsetX<=self.contentInset.left) {
                let offsetX = contentOffsetX+pageWidth
                finalOffsetX = CGFloat(self.itemsCount-1)*pageWidth+offsetX
                self.scrollView.setContentOffset(CGPoint(x: CGFloat.maximum(0, finalOffsetX), y:0), animated: false)
            }
            else if(contentOffsetX>=(self.contentWidth-pageWidth-self.contentInset.right)){
                let offsetX = contentOffsetX-(self.contentWidth-pageWidth)
                finalOffsetX = pageWidth+offsetX
                self.scrollView.setContentOffset(CGPoint(x: CGFloat.maximum(0, finalOffsetX), y:0), animated: false)
            }

        }

    }

    
    

    // MARK: 获取可见视图中，已存在并且不需要放入缓存的视图
    private func getExistItemInVisible(indexPath: LGCarouselIndexPath, arrayItems: Array<LGCarouselItemView>) -> LGCarouselItemView?{
        let results = arrayItems.filter { (item: LGCarouselItemView) -> Bool in
            return item.indexPath.itemIndex == indexPath.itemIndex
        }
        if (results.count>0) {
            return results.first!
        }
        return nil;
    }

    // MARK: 布局对应indexPath需要展示的item
    private func setupShow(indexPath: LGCarouselIndexPath, itemView: LGCarouselItemView?) -> Void{
        var item: LGCarouselItemView? = itemView
        if (item == nil) {
            item = self.popFromCacheArray(itemIndex: indexPath.itemIndex)
        }
        item!.indexPath = indexPath
        if let dataSource = self.dataSource, dataSource.responds(to: #selector(dataSource.carouselItemView(_:itemView:itemIndex:))){
            dataSource.carouselItemView!(self, itemView: item!, itemIndex: indexPath.itemIndex)
        }
        item!.isHidden = false
        item!.frame = CGRect(x: self.pageWidth()*CGFloat(indexPath.pageIndex), y: 0, width: self.itemSize.width, height: self.itemSize.height)
        if itemView == nil {
            self.visibleItemViews.append(item!)
        }
    }

    
    

}

// MARK: - indexPath处理
extension LGCarousel {
    
    // MARK: 重新计算可见范围的indexPaths
    private func resetVisibleItemIndexPaths() {
        if (self.itemsCount<1) {
            self.visibleItemIndexs.removeAll()
            return;
        }
        if (self.isCycleEnabled()) {
            self.resetCycleVisibleIndexPaths()
        }
        else {
            self.resetNoneCycleVisibleIndexPaths()
        }
    }

    // MARK: 重新计算循环模式下可见范围的indexPaths
    private func resetCycleVisibleIndexPaths() {
        var insetLeft = self.contentInset.left
        var visibleNormalWidth: CGFloat = self.frame.size.width
        if (self.shouldClipBoundary) {
            insetLeft = 0
            visibleNormalWidth = self.scrollView.frame.size.width
        }

        let contentOffsetX = self.scrollView.contentOffset.x
        let pageWidth = self.pageWidth()
        var pageStart: UInt = 0
        var arrayIndexPaths: Array<LGCarouselIndexPath> = Array()
        var visibleRemainWidth: CGFloat = visibleNormalWidth

        let page: Int = Int(contentOffsetX/pageWidth);
        var xTemp: CGFloat = contentOffsetX-CGFloat(page)*pageWidth;
        xTemp = pageWidth-xTemp;
        var leftMax: CGFloat = xTemp+insetLeft;
        pageStart = UInt(page);
        leftMax = leftMax-pageWidth;
        while (leftMax>0) {
            pageStart = pageStart-1
            leftMax = leftMax - pageWidth
        }
        visibleRemainWidth = visibleNormalWidth+fabs(leftMax)
        arrayIndexPaths.append(self.transformIndexPathFromPageIndex(pageStart)!)
        var totalWidth: CGFloat = pageWidth
        while (totalWidth-visibleRemainWidth<0) {
            pageStart = pageStart+1;
            arrayIndexPaths.append(self.transformIndexPathFromPageIndex(pageStart)!)
            totalWidth = totalWidth+pageWidth;
        }
        self.visibleItemIndexs = arrayIndexPaths;
    }

    // MARK: 重新计算非循环模式下可见范围的indexPaths
    private func resetNoneCycleVisibleIndexPaths() {

        var insetLeft: CGFloat = self.contentInset.left
        var visibleNormalWidth: CGFloat = self.frame.size.width
        if (self.shouldClipBoundary) {
            insetLeft = 0
            visibleNormalWidth = self.scrollView.frame.size.width
        }

        let contentOffsetX: CGFloat = self.scrollView.contentOffset.x
        let pageWidth: CGFloat = self.pageWidth()
        var pageStart:UInt = 0;
        var arrayIndexPaths: Array<LGCarouselIndexPath> = Array()
        var visibleRemainWidth: CGFloat = visibleNormalWidth

        if (contentOffsetX<=0) {
            visibleRemainWidth = visibleNormalWidth - (insetLeft+fabs(contentOffsetX));
            pageStart = 0;
        }
        else {
            let page: Int = Int(contentOffsetX/pageWidth);
            var xTemp: CGFloat = CGFloat(contentOffsetX-CGFloat(page)*pageWidth);
            if (page == 0) {
                visibleRemainWidth = visibleNormalWidth+xTemp-insetLeft
                pageStart = 0
            }
            else {
                xTemp = pageWidth-xTemp
                var leftMax: CGFloat = xTemp+insetLeft
                pageStart = UInt(page);
                leftMax -= pageWidth;
                while (leftMax>0) {
                    pageStart = pageStart-1
                    leftMax = leftMax - pageWidth;
                }
                visibleRemainWidth = visibleNormalWidth+fabs(leftMax);
            }
        }
        arrayIndexPaths.append(self.transformIndexPathFromPageIndex(pageStart)!)
        var totalWidth: CGFloat = pageWidth
        while (totalWidth-visibleRemainWidth<0 && pageStart<self.itemsCount-1) {
            pageStart = pageStart+1
            arrayIndexPaths.append(self.transformIndexPathFromPageIndex(pageStart)!)
            totalWidth += pageWidth
        }

        self.visibleItemIndexs = arrayIndexPaths
    }

    
    // MARK: 将当前页码，转化为对应的indexPath
    private func transformIndexPathFromPageIndex(_ pageIndex: UInt) -> LGCarouselIndexPath?{
        var itemIndex:UInt = 0
        if (!self.isCycleEnabled()) {
            itemIndex = pageIndex
        }
        else {
            if (pageIndex == 0) {
                itemIndex = self.itemsCount-1
            }
            else if (pageIndex == (self.itemsCount+1)) {
                itemIndex = 0
            }
            else {
                itemIndex = pageIndex-1
            }
        }
        return LGCarouselIndexPath(itemIndex: itemIndex, pageIndex: pageIndex)
    }

    // MARK: 将当前视图实际索引，转化为对应的indexPath
    private func transformIndexPathFromItemIndex(_ itemIndex: UInt) -> LGCarouselIndexPath?{
        if (self.itemsCount<1) {
            return nil;
        }
        if (!self.isCycleEnabled() && itemIndex>self.itemsCount-1) {
            return nil;
        }

        var pageIndex:UInt = 0;
        var itemIndexTemp: UInt = itemIndex
        var isValid = true
        if (!self.isCycleEnabled()) {
            pageIndex = itemIndexTemp
            if (pageIndex > self.itemsCount-1) {
                isValid = false
            }
        }
        else {
            if (itemIndexTemp>self.itemsCount-1) {
                itemIndexTemp = 0
                pageIndex = 1
            }
            else {
                pageIndex = itemIndex+1
            }

        }

        if (!isValid) {
            return nil;
        }
        return LGCarouselIndexPath(itemIndex: itemIndexTemp, pageIndex: pageIndex)
    }
    
    private func resetCurrentIndexPath() -> Void {
        var indexPath: LGCarouselIndexPath?
        if (self.visibleItemViews.count>0) {
            for itemView in self.visibleItemViews {
                let rect = itemView.superview!.convert(itemView.frame, to: self.containerView)
                let center = CGPoint(x: rect.origin.x+rect.size.width/2, y :rect.origin.y+rect.size.height/2);
                if (center.x>0 && center.x<self.pageWidth()) {
                    indexPath = itemView.indexPath;
                    break;
                }
            }
        }
        self.currentIndexPath = indexPath ?? LGCarouselIndexPath(itemIndex: 0, pageIndex: 0)
        if (indexPath != nil && ((self.delegate?.responds(to: #selector(self.delegate!.carouselDidItemIndexChanged(_:itemIndex:)))) != nil)) {
            self.delegate?.carouselDidItemIndexChanged!(self, itemIndex: self.currentIndexPath.itemIndex)
        }
    }
    
}

// MARK: - cache处理
extension LGCarousel {
    private func initReuseArray(itemIndex: UInt) -> Void {
        if (self.itemsCount == 0) {
            return;
        }
        let itemView: LGCarouselItemView = self.dequeueReusableItem()
        itemView.isHidden = true
        if !self.arrayReuseViews.contains(itemView) {
            self.arrayReuseViews.append(itemView)
        }
        if !self.arrayCacheViews.contains(itemView) {
            self.arrayCacheViews.append(itemView)
        }
        if !self.scrollView.subviews.contains(itemView) {
            self.scrollView.addSubview(itemView)
        }
    }

    // 将暂时用不到的可复用视图放入缓存池
    private func pushToCacheArray(itemView: LGCarouselItemView) {
        itemView.isHidden = true
        if !self.arrayCacheViews.contains(itemView) {
            self.arrayCacheViews.append(itemView)
        }
        
        if self.visibleItemViews.contains(itemView) {
            let indexTemp = self.visibleItemViews.index(of: itemView)!
            self.visibleItemViews.remove(at: indexTemp)
        }
    }

    // 从缓存池取出可复用的视图，如果没有，则会创建一个新的
    private func popFromCacheArray(itemIndex: UInt) -> LGCarouselItemView? {
        if (self.itemsCount == 0) {
            return nil;
        }
        let itemView:LGCarouselItemView = self.dequeueReusableItem()
        itemView.isHidden = false
        if !self.arrayReuseViews.contains(itemView) {
            self.arrayReuseViews.append(itemView)
        }
        
        if self.arrayCacheViews.contains(itemView) {
            let indexTemp = self.arrayCacheViews.index(of: itemView)!
            self.arrayCacheViews.remove(at: indexTemp)
        }
        
        if !self.scrollView.subviews.contains(itemView) {
            self.scrollView.addSubview(itemView)
        }
        return itemView;
    }
    
    /// 取出缓存的视图，如果不存在，则创建
    private func dequeueReusableItem() -> LGCarouselItemView {
        self.assertHandle()
        let results = self.arrayCacheViews.filter { (itemView: LGCarouselItemView) -> Bool in
            return itemView.reuseIdentifier.compare(self.reuseIdentifier!) == ComparisonResult.orderedSame
        }
        if results.count>0 {
            return results.first!
        }
        let itemView = self.itemClass!.itemView()
        itemView.reuseIdentifier = self.reuseIdentifier!
        return itemView
    }
}

// MARK: - timer
extension LGCarousel {
    
    private func startTimer() -> Void {
        self.stopTimer()
        if !self.isCycleEnabled() || !self.autoPlayEnabled {
            return
        }
        self.timer = Timer(timeInterval: self.timerInterval, target: LGWeakProxy.proxyWithTarget(self, selector: #selector(self.autoScrollAction)), selector: #selector(self.autoScrollAction), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    
    private func stopTimer() -> Void {
        guard let timer = self.timer else {
            return
        }
        timer.invalidate()
        self.timer = nil;
    }
    
    @objc private func autoScrollAction() -> Void {
        let willOffsetX = CGFloat((self.currentIndexPath.pageIndex+1))*self.pageWidth()
        self.scrollView.setContentOffset(CGPoint(x:willOffsetX , y: 0), animated: true)
    }
    
    
}

// MARK: - 点击事件
extension LGCarousel: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.itemsCount<1 || !self.isClickEnabled {
            return false
        }
        return true
    }
 
    @objc private func containerTapAction() {
        if (self.itemsCount<1) {
            return;
        }
        if let delegate = self.delegate , delegate.responds(to: #selector(delegate.carouselDidClick(_:itemIndex:))) {
            delegate.carouselDidClick!(self, itemIndex: self.currentItemIndex)
        }
    }

}


