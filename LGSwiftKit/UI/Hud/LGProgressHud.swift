//
//  LGProgressHud.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/10/8.
//

import UIKit

private let hudTag = 1000001
private let horMargin:CGFloat = 20
private let verMargin:CGFloat = 20
private let innerGap:CGFloat = 15
private var hudContainerView: UIView?


public enum LGHudBackStyle {
    case light, dark
}

public enum LGHudType {
    case text
    case loading
    case textloading
}

public class LGProgressHud {
    
    public static let shared = LGProgressHud()
    
    public class func showLoading() {
        self.showLoading(container: nil)
    }
    
    public class func showLoading(container: UIView?) {
        self.show(container: container, style: .dark, hudType: .loading, duration: 0, text: nil, compeletion: nil)
    }
    
    public class func showLoading(text: String) {
        self.showLoading(container: nil, text: text)
    }
    
    public class func showLoading(container: UIView?, text: String) {
        self.show(container: container, style: .dark, hudType: .textloading, duration: 0, text: text, compeletion: nil)
    }
    
    public class func showText(text: String) {
        self.show(container: nil, style: .dark, hudType: .text, duration: 0, text: text, compeletion: nil)
        self.delayDismiss(container: nil)
    }
    
    public class func showText(text: String, container: UIView?) {
        self.show(container: container, style: .dark, hudType: .text, duration: 0, text: text, compeletion: nil)
        self.delayDismiss(container: container)
    }
    
    
    
    public class func show(container: UIView?, style:LGHudBackStyle = .dark, hudType: LGHudType = .loading, duration:TimeInterval = 3, text:String?, compeletion: (() -> Void)?) {
        self.dismiss(container: hudContainerView)
        let containerTemp: UIView = container ?? UIApplication.shared.delegate!.window!!
        hudContainerView = containerTemp
        let hud = LGHud(style: style, hudType: hudType, text: text, containerView: containerTemp, compeletion: compeletion)
        hud.tag = hudTag
        containerTemp.addSubview(hud)
        
    }
    
    private class func delayDismiss(container: UIView?) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2.5) {
            self.dismiss(container: container)
        }
    }
    
    public class func dismiss() {
        self.dismiss(container: hudContainerView)
        hudContainerView = nil
    }
    
    public class func dismiss(container: UIView?) {
        guard let containerTemp = container else { return }
        guard let hud = containerTemp.viewWithTag(hudTag) , let realHud = hud as? LGHud else { return }
        realHud.removeFromSuperview()
        guard let completion = realHud.completion else { return }
        completion()
    }

}

fileprivate class LGHud: UIView {
    
    
    var style:LGHudBackStyle
    var hudType:LGHudType
    
    var completion:(()->Void)?
    private var indicatorView: UIActivityIndicatorView?
    private var textLabel: UILabel?
    private var containerView: UIView
    private var duration: TimeInterval = 3.0
    
    var text: String?
    
    override init(frame: CGRect) {
        style = LGHudBackStyle.dark
        hudType = LGHudType.text
        containerView = UIApplication.shared.delegate!.window!!
        super.init(frame: frame)
    }
    
    convenience init(style:LGHudBackStyle = LGHudBackStyle.dark, hudType:LGHudType = LGHudType.text, text:String? , containerView: UIView, compeletion: (() -> Void)?){
        self.init(frame: CGRect.zero)
        self.style = style
        self.hudType = hudType
        self.text = text
        self.completion = compeletion
        self.containerView = containerView
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
            self.textLabel?.text = self.text
        case .loading:
            self.createIndicatorView()
            self.addSubview(self.indicatorView!)
        default:
            self.createLabel()
            self.createIndicatorView()
            self.addSubview(self.textLabel!)
            self.textLabel?.text = self.text
            self.addSubview(self.indicatorView!)
        }
        self.refreshSubLayout()
    }
    
    
    func refreshSubLayout() {
        let maxWidth: CGFloat = CGFloat.screen_width/2.0
        let minWidth: CGFloat = CGFloat.screen_width/3.0
        var realWidth: CGFloat = maxWidth
        if let label = textLabel, let loadingView = indicatorView {
            var labelSize: CGSize = label.text!.size(width: maxWidth-horMargin*2, fontSize: 0, font: label.font)
            labelSize.height = min(labelSize.height, label.font.lineHeight*2)
            realWidth = min(max(labelSize.width+horMargin*2.0, loadingView.frame.size.width+horMargin*2.0), maxWidth)
            realWidth = max(realWidth, minWidth)
            
            let sizeHud = CGSize(width: realWidth, height: verMargin+loadingView.frame.size.height+innerGap+labelSize.height+verMargin)
            self.frame = CGRect(x: (self.containerView.frame.size.width-sizeHud.width)/2.0, y: (self.containerView.frame.size.height-sizeHud.height)/2.0, width: sizeHud.width, height: sizeHud.height)
            loadingView.center = CGPoint(x: sizeHud.width/2.0, y: verMargin+loadingView.frame.size.height/2.0)
            label.frame = CGRect(x: (sizeHud.width-labelSize.width)/2.0, y: loadingView.frame.maxY+innerGap, width: labelSize.width, height: labelSize.height)
            loadingView.startAnimating()
            return
        }
        
        if let loadingView = indicatorView {
            let sizeLoading = loadingView.frame.size
            realWidth = min(horMargin+sizeLoading.width+horMargin, maxWidth)
            realWidth = max(realWidth, minWidth)
            let sizeHud = CGSize(width: realWidth, height: verMargin+sizeLoading.height+verMargin)
            self.frame = CGRect(x: (self.containerView.frame.size.width-sizeHud.width)/2.0, y: (self.containerView.frame.size.height-sizeHud.height)/2.0, width: sizeHud.width, height: sizeHud.height)
            loadingView.center = CGPoint(x: sizeHud.width/2.0, y: sizeHud.height/2.0)
            loadingView.startAnimating()
            return
        }
        
        if let label = textLabel {
            var labelSize: CGSize = label.text!.size(width: maxWidth-horMargin*2, fontSize: 0, font: label.font)
            labelSize.height = min(labelSize.height, label.font.lineHeight*2)
            realWidth = min(labelSize.width+horMargin*2.0, maxWidth)
            realWidth = max(realWidth, minWidth)
            let sizeHud = CGSize(width: realWidth, height: verMargin+labelSize.height+verMargin)
            self.frame = CGRect(x: (self.containerView.frame.size.width-sizeHud.width)/2.0, y: (self.containerView.frame.size.height-sizeHud.height)/2.0, width: sizeHud.width, height: sizeHud.height)
            label.frame = CGRect(x: (sizeHud.width-labelSize.width)/2.0, y: verMargin, width: labelSize.width, height: labelSize.height)
            return
        }
    }
    
    func createLabel() {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.text = self.text
        self.textLabel = label
    }
    
    func createIndicatorView() {
        var loadinView:UIActivityIndicatorView?
        if #available(iOS 13.0, *) {
            loadinView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorView.Style.large)
        } else {
            loadinView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorView.Style.whiteLarge)
            // Fallback on earlier versions
        }
        loadinView?.transform = CGAffineTransform(scaleX: 2, y: 2)
        switch self.style {
        case .light:
            loadinView?.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        case .dark:
            loadinView?.color = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        }
        self.indicatorView = loadinView
    }
    
}



