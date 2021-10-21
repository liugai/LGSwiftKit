# LGSwiftKit
常用Swift工具类(尺寸、轮播组件、日期等)

# CocoaPods
pod 'LGSwiftKit'

# 使用
import LGSwiftKit

# 内容说明
## 轮播GIF示例
![Image text](https://github.com/liugai/LGSwiftKit/blob/master/File/carousel.gif)
### 代码示例

先创建单个轮播控件
```
import LGSwiftKit
class LGCarouselImageItemView: LGCarouselItemView {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    } ()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
    }
}

```

使用
```

class LGCarouselDemoViewController: UIViewController, LGCarouselDelegate, LGCarouselDataSource {

    lazy var carousel:LGCarousel = {
        let carousel = LGCarousel(frame: CGRect(x: 20, y: CGFloat.navbar_statusbar_height+10, width: CGFloat.screen_width-40, height: 160))
        carousel.itemSize = CGSize.init(width: CGFloat.screen_width-80, height: 160)
        carousel.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        carousel.registerClass(itemClass: LGCarouselImageItemView.self, reuseIdentifier: "LGCarouselImageItemView")
        carousel.layer.borderColor = UIColor.red.cgColor
        carousel.layer.borderWidth = 1
        return carousel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.initUI()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initUI() -> Void {
        self.carousel.pageEnabled = self.isPage
        self.carousel.cycleEnabled = self.isCycle
        self.carousel.autoPlayEnabled = self.isAutoPlay
        self.carousel.shouldClipBoundary = self.clipBoundary
        self.carousel.delegate = self
        self.carousel.dataSource = self
        self.view.addSubview(self.carousel)
        self.carousel.reloadData()
    }

    func carouselDidItemIndexChanged(_ carousel: LGCarousel, itemIndex: UInt) {
        
    }
    
    func carouselDidClick(_ carousel: LGCarousel, itemIndex: UInt) {
        
    }
    
    func carouselItemsCount(_ carousel: LGCarousel) -> UInt {
        return 10
    }
    
    func carouselItemView(_ carousel: LGCarousel, itemView: LGCarouselItemView, itemIndex: UInt) {
        (itemView as! LGCarouselImageItemView).imageView.image = UIImage.init(contentsOfFile:  Bundle.main.path(forResource: String(format: "scenery_%lu", itemIndex+1), ofType: "JPG")!)
    }
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

