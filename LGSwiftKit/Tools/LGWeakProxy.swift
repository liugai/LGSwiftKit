//
//  LGWeakProxy.swift
//  LGSwiftKit
//
//  Created by 刘盖 on 2021/9/23.
//

import Foundation

open class LGProxy: NSProxy {
    private weak var _target: NSObjectProtocol?
    public weak var target: NSObjectProtocol? {
        get {
            return _target
        }
    }
    
    func initWithTarget(_ target:NSObjectProtocol?) -> Self {
        _target = target
        return self
    }
    
    public class func proxyWithTarget(_ target:NSObjectProtocol?) -> Self {
        
        return Self.alloc().initWithTarget(target)
    }
    
//    - (id)forwardingTargetForSelector:(SEL)selector {
//        return _target;
//    }

//    - (void)forwardInvocation:(NSInvocation *)invocation {
//        void *null = NULL;
//        [invocation setReturnValue:&null];
//    }

//
//    - (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
//        return [NSObject instanceMethodSignatureForSelector:@selector(init)];
//    }

    open override func responds(to aSelector: Selector!) -> Bool {
        guard let target = _target else {
            return false
        }
        return target.responds(to: aSelector)
    }

    open override func isEqual(_ object: Any?) -> Bool {
        guard let target = _target else {
            return false
        }
        return target.isEqual(object)
    }

    open override var hash: Int {
        guard let target = _target else {
            return 0
        }
        return target.hash
    }

    open override var superclass: AnyClass? {
        guard let target = _target else {
            return nil
        }
        return target.superclass
    }
    
    open override func isKind(of aClass: AnyClass) -> Bool {
        guard let target = _target else {
            return false
        }
        return target.isKind(of: aClass)
    }

    open override func isMember(of aClass: AnyClass) -> Bool {
        guard let target = _target else {
            return false
        }
        return target.isMember(of: aClass)
    }
    
    open override func conforms(to aProtocol: Protocol) -> Bool {
        guard let target = _target else {
            return false
        }
        return target.conforms(to: aProtocol)
    }
    
    
    open override func isProxy() -> Bool {
        return true
    }
   
    open override var description: String {
        guard let target = _target else {
            return ""
        }
        return target.description
    }

    open override var debugDescription: String {
        guard let target = _target, let desc = target.debugDescription else {
            return ""
        }
        return desc
    }
}

open class LGWeakProxy: NSObject {
    
    private weak var _target: NSObjectProtocol?
    private var _sel:Selector?
    open weak var target: AnyObject? {
        get {
            return _target
        }
    }
    
    public required override init() {
        super.init()
    }
   
    open class func proxyWithTarget(_ target: NSObjectProtocol?, selector: Selector?) -> Self {
        let proxy = Self()
        proxy._target = target
        proxy._sel = selector
        proxy.exchangeMethod()
        return proxy
    }
    
    private func exchangeMethod() {
        // 加强安全保护
        guard let target = self.target, let selTemp = self._sel, target.responds(to: selTemp) else {
            return
        }
        let method = class_getInstanceMethod(self.classForCoder, #selector(self.redirectionMethod))!
        class_replaceMethod(self.classForCoder, selTemp, method_getImplementation(method), method_getTypeEncoding(method))
        
    }
    
    @objc func redirectionMethod () {
        // 如果target未被释放，则调用target方法，否则释放timer
        if let target = self.target, let selTemp = self._sel {
            target.perform(selTemp)
        }
    
    }
    
}
