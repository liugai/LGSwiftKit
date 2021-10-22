# LGSwiftKit
常用Swift工具类(尺寸、轮播组件、日期等)

# CocoaPods
pod 'LGSwiftKit' #包含整个库，目前等价于pod 'LGSwiftKit/LGSwiftUI'

pod 'LGSwiftKit/LGSwiftTool' #单纯工具类，如string、date等

pod 'LGSwiftKit/LGSwiftCarousel' #包含工具类，轮播

pod 'LGSwiftKit/LGSwiftHud' #包含工具类，toast、loading

pod 'LGSwiftKit/LGSwiftLinkedScroll' #包含工具类，scroll联动组件


# 使用
import LGSwiftKit

# 内容说明
## 轮播GIF示例
![Image text](https://github.com/liugai/LGSwiftKit/blob/master/File/carousel.gif)
### 代码示例

使用(关键代码)
```
import LGSwiftKit
//创建单个page视图
class LGCarouselImageItemView: LGCarouselItemView

//创建轮播视图
        let carousel = LGCarousel(frame: CGRect(x: 20, y: CGFloat.navbar_statusbar_height+10, width: CGFloat.screen_width-40, height: 160))
        carousel.itemSize = CGSize.init(width: CGFloat.screen_width-80, height: 160)
        carousel.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        carousel.registerClass(itemClass: LGCarouselImageItemView.self, reuseIdentifier: "LGCarouselImageItemView")
        carousel.layer.borderColor = UIColor.red.cgColor
        carousel.layer.borderWidth = 1
        carousel.pageEnabled = true
        carousel.cycleEnabled = true
        carousel.autoPlayEnabled = true
        carousel.shouldClipBoundary = true
        carousel.delegate = self
        carousel.dataSource = self
//实现代理       
    func carouselItemsCount(_ carousel: LGCarousel) -> UInt {
        return 10
    }
    
    func carouselItemView(_ carousel: LGCarousel, itemView: LGCarouselItemView, itemIndex: UInt) {
        (itemView as! LGCarouselImageItemView).imageView.image = UIImage.init(contentsOfFile:  Bundle.main.path(forResource: String(format: "scenery_%lu", itemIndex+1), ofType: "JPG")!)
    }

```

## toast loading GIF示例
![Image text](https://github.com/liugai/LGSwiftKit/blob/master/File/loading.gif)
### 代码示例
```
import LGSwiftKit
LGProgressHud.showLoading(container: self.hudSuperView)
LGProgressHud.showLoading(container: self.hudSuperView, text: "加载中...")
LGProgressHud.showText(text: "测试长文本toast测试长文本toast测试长文本toast测试长文本toast测试长文本toast", container: self.hudSuperView)
LGProgressHud.show(container: self.hudSuperView, style: LGProgressHud.shared.defaultStyle, hudType: .textloading, duration: 0, text: nil, compeletion: nil)
//设置样式
LGProgressHud.shared.defaultStyle = (LGProgressHud.shared.defaultStyle == .dark ? .light : .dark)
//loading dismiss
LGProgressHud.dismiss(container: self.hudSuperView)

```

## scroll嵌套联动
![Image text](https://github.com/liugai/LGSwiftKit/blob/master/File/scroll.gif)
### 代码示例
先创建page
```
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
```

使用
```
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
```

## 其他
LGAttributeString.swift ，计算字符串宽高
LGBool.swift  是否是全屏手机判断
LGCGExtension.swift  包含屏幕宽高、导航栏、状态栏、tabbar等高度定义
LGColor.swift  包含16进制颜色转化等api
LGDate.swift 包含时间戳、时间字符串等时间与字符串相互转化
LGDefine.swift
LGFont.swift 字体处理
LGImage.swift， 颜色转图片
LGString.swift 字符串处理，去空格、换行，数字、邮箱格式等校验，字符串宽高计算等
LGWeakProxy.swift， 可以用来打破Timer循环引用
```
self.timer = Timer(timeInterval: self.timerInterval, target: LGWeakProxy.proxyWithTarget(self, selector: #selector(self.autoScrollAction)), selector: #selector(self.autoScrollAction), userInfo: nil, repeats: true)
```

