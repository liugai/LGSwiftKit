//
//  LGProgressHud.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/10/8.
//

import UIKit

/**hud tag标识**/
private let hudTag = 1000001

/**hud 颜色样式**/
public enum LGHudColorStyle {
    case light /**浅色背景**/
    case dark /**深色背景**/
}

public enum LGHudType {
    case text /**文本toast**/
    case loading /**单纯loading**/
    case textloading /**loading+文本**/
}

public class LGProgressHud: NSObject {
    
    /**单例，用于设置全局样式**/
    public static let shared = LGProgressHud()
    
    /**默认全局样式**/
    public var defaultStyle: LGHudColorStyle = .dark
    
    /**水平左右间距**/
    private var _horMargin: CGFloat = 20
    /**竖直上下间距**/
    private var _verMargin: CGFloat = 20
    /**文本与loading之间间距**/
    private var _innerGap: CGFloat = 15
    /**hud最小宽度**/
    private var _hudMinWidth: CGFloat = 120
    /**hud最小高度**/
    private var _hudMinHeight: CGFloat = 120
    
    //MARK: -
    //MARK: loading
    public class func showLoading(container: UIView?, text: String? = nil) {
        self.show(container: container, style: self.shared.defaultStyle, hudType: ((text != nil) ? .textloading : .loading), duration: 0, text: text, compeletion: nil)
    }

    //MARK: toast
    public class func showText(text: String) {
        self.show(container: self.defaultContainerView(), style: self.shared.defaultStyle, hudType: .text, duration: 0, text: text, compeletion: nil)
    }
    //MARK: toast 消失时回调
    public class func showText(text: String , compeletion: (() -> Void)?) {
        self.show(container: self.defaultContainerView(), style: self.shared.defaultStyle, hudType: .text, duration: 0, text: text, compeletion: compeletion)
    }
    //MARK: toast 容器view
    public class func showText(text: String, container: UIView?) {
        self.show(container: container, style: self.shared.defaultStyle, hudType: .text, duration: 0, text: text, compeletion: nil)
    }
    
    //MARK: toast 容器view 消失时回调
    public class func showText(text: String, container: UIView? , compeletion: (() -> Void)? = nil) {
        self.show(container: container, style: self.shared.defaultStyle, hudType: .text, duration: 0, text: text, compeletion: compeletion)
    }
    
    
    //MARK: 完整show
    public class func show(container: UIView?, style:LGHudColorStyle, hudType: LGHudType, duration:TimeInterval = 3, text:String?, compeletion: (() -> Void)?) {
        LGHud.showHud(style: style, hudType: hudType, text: text, containerView: container ?? self.defaultContainerView(), compeletion: compeletion)
    }
    
    //MARK: - dismiss
    public class func dismiss() {
        self.dismiss(container: self.defaultContainerView())
    }
    
    @objc public class func dismiss(container: UIView?) {
        guard let containerTemp = container else { return }
        guard let hud = containerTemp.viewWithTag(hudTag) , let realHud = hud as? LGHud else { return }
        realHud.dismiss()
    }
    
    //MARK: 默认容器视图
    private class func defaultContainerView() -> UIView {
        return UIApplication.shared.delegate!.window!!
    }

}

//MARK: - 定制样式
extension LGProgressHud {
    
    //MARK: 水平间距
    public var horMargin: CGFloat {
        get {
            return _horMargin
        }
        set {
            _horMargin = newValue
        }
    }
    
    //MARK: 竖直间距
    public var verMargin: CGFloat {
        get {
            return _verMargin
        }
        set {
            _verMargin = newValue
        }
    }
    
    //MARK: 文本loading之间间距
    public var innerGap: CGFloat {
        get {
            return _innerGap
        }
        set {
            _innerGap = newValue
        }
    }
    
    //MARK: hud最小宽度
    public var hudMinWidth: CGFloat {
        get {
            return _hudMinWidth
        }
        set {
            _hudMinWidth = min(max(120.0, newValue), CGFloat.screen_width/2)
        }
    }
    
    //MARK: hud最小高度
    public var hudMinHeight: CGFloat{
        get {
            return _hudMinHeight
        }
        set {
            _hudMinHeight = min(max(120.0, newValue), CGFloat.screen_width/2)
        }
    }
    
}

fileprivate class LGHud: UIView {
    
    /**背景样式 **/
    var style:LGHudColorStyle
    /**hud类型**/
    var hudType:LGHudType
    /**消失回调**/
    var completion:(()->Void)?
    
    /**loading视图**/
    private var indicatorView: UIActivityIndicatorView?
    /**文本视图**/
    private var textLabel: UILabel?
    /**容器视图**/
    private var containerView: UIView
    /**toast持续时间**/
    private var duration: TimeInterval = 3.0
    
    /**文本**/
    var text: String?
    
    override init(frame: CGRect) {
        style = LGHudColorStyle.dark
        hudType = LGHudType.text
        containerView = UIApplication.shared.delegate!.window!!
        super.init(frame: frame)
    }
        
    private convenience init(style:LGHudColorStyle = LGHudColorStyle.dark, hudType:LGHudType = LGHudType.text, text:String? , containerView: UIView, duartion: TimeInterval = 2.0, compeletion: (() -> Void)?){
        self.init(frame: CGRect.zero)
        self.style = style
        self.hudType = hudType
        self.text = text
        self.completion = compeletion
        self.containerView = containerView
        self.duration = max(duartion, 1.0)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func initUI() {
        // 设置背景色
        switch self.style {
        case .dark:
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        default:
            self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        }
        
        switch self.hudType {
        case .text:
            self.createLabel()
            self.addSubview(self.textLabel!)
        case .loading:
            self.createIndicatorView()
            self.addSubview(self.indicatorView!)
        default:
            self.createLabel()
            self.createIndicatorView()
            self.addSubview(self.textLabel!)
            self.addSubview(self.indicatorView!)
        }
        self.refreshSubLayout()
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
    }
    
    //MARK: 布局
    func refreshSubLayout() {
        var realWidth: CGFloat = LGProgressHud.shared.hudMinWidth
        var realHeight: CGFloat = LGProgressHud.shared.hudMinHeight
        
        if let label = textLabel, let loadingView = indicatorView {
            realWidth = CGFloat.screen_width/2.0
            var labelSize: CGSize = label.text!.size(width: realWidth-LGProgressHud.shared.horMargin*2, font: label.font)
            labelSize.height = min(labelSize.height, label.font.lineHeight*2)
            realWidth = max(LGProgressHud.shared.hudMinWidth, labelSize.width+LGProgressHud.shared.horMargin*2)
            realHeight = LGProgressHud.shared.verMargin+loadingView.frame.size.height+LGProgressHud.shared.innerGap+labelSize.height+LGProgressHud.shared.verMargin
            let sizeHud = CGSize(width: realWidth, height: realHeight)
            self.frame = CGRect(x: (self.containerView.frame.size.width-sizeHud.width)/2.0, y: (self.containerView.frame.size.height-sizeHud.height)/2.0, width: sizeHud.width, height: sizeHud.height)
            
            let top = (sizeHud.height-loadingView.frame.size.height-LGProgressHud.shared.innerGap-labelSize.height)/2.0;
            loadingView.center = CGPoint(x: sizeHud.width/2.0, y: top+loadingView.frame.size.height/2.0)
            label.frame = CGRect(x: (sizeHud.width-labelSize.width)/2.0, y: loadingView.frame.maxY+LGProgressHud.shared.innerGap, width: labelSize.width, height: labelSize.height)
            loadingView.startAnimating()
            return
        }
        
        if let loadingView = indicatorView {
            let sizeHud = CGSize(width: realWidth, height: realHeight)
            self.frame = CGRect(x: (self.containerView.frame.size.width-sizeHud.width)/2.0, y: (self.containerView.frame.size.height-sizeHud.height)/2.0, width: sizeHud.width, height: sizeHud.height)
            loadingView.center = CGPoint(x: sizeHud.width/2.0, y: sizeHud.height/2.0)
            loadingView.startAnimating()
            return
        }
        
        if let label = textLabel {
            realWidth = CGFloat.screen_width*2.0/3.0
            var labelSize: CGSize = label.text!.size(width: realWidth-LGProgressHud.shared.horMargin*2, font: label.font)
            labelSize.height = min(labelSize.height, label.font.lineHeight*2)
            realWidth = max(LGProgressHud.shared.hudMinWidth, labelSize.width+LGProgressHud.shared.horMargin*2)
            realHeight = LGProgressHud.shared.verMargin+labelSize.height+LGProgressHud.shared.verMargin
            let sizeHud = CGSize(width: realWidth, height: realHeight)
            self.frame = CGRect(x: (self.containerView.frame.size.width-sizeHud.width)/2.0, y: (self.containerView.frame.size.height-sizeHud.height)/2.0, width: sizeHud.width, height: sizeHud.height)
            label.frame = CGRect(x: (sizeHud.width-labelSize.width)/2.0, y: (sizeHud.height-labelSize.height)/2.0, width: labelSize.width, height: labelSize.height)
            return
        }
    }
    
    //MARK: 创建文本视图
    func createLabel() {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        label.text = self.text ?? "加载中..."
        switch self.style {
        case .light:
            label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        case .dark:
            label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        }
        self.textLabel = label
    }
    
    //MARK: 创建loading视图
    func createIndicatorView() {
        var loadinView:UIActivityIndicatorView?
        if #available(iOS 13.0, *) {
            loadinView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorView.Style.large)
        } else {
            loadinView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorView.Style.whiteLarge)
            // Fallback on earlier versions
        }
        loadinView?.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        switch self.style {
        case .light:
            loadinView?.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        case .dark:
            loadinView?.color = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        }
        self.indicatorView = loadinView
    }
    
    
}

extension LGHud {
    
    //MARK: 移除hud
    @objc func dismiss() {
        if let completion = self.completion {
            completion()
        }
        self.removeFromSuperview()
    }
    
    //MARK: 当前容器视图中，展示hud前 已有的hud
    func beforeHud(container: UIView) -> Self? {
        guard let hud = container.viewWithTag(hudTag) , let realHud = hud as? LGHud else { return nil}
        return (realHud as! Self)
    }
    
    //MARK: 展示hud
    class func showHud(style:LGHudColorStyle = LGHudColorStyle.dark, hudType:LGHudType = LGHudType.text, text:String? , containerView: UIView,  duartion: TimeInterval = 2.0, compeletion: (() -> Void)?) -> Void {
        let hud = LGHud(style: style, hudType: hudType, text: text, containerView: containerView, duartion: duartion, compeletion: compeletion)
        if let beforeHud = hud.beforeHud(container: containerView) {
            self.cancelPreviousPerformRequests(withTarget: beforeHud, selector: #selector(beforeHud.dismiss), object: containerView)
            beforeHud.dismiss()
        }
        hud.tag = hudTag
        containerView.addSubview(hud)
        if hudType == .text{
            hud.perform(#selector(hud.dismiss), with: nil, afterDelay: hud.duration);
        }
    }
}
