//
//  LGStringTool.swift
//  Integraler
//
//  Created by 刘盖 on 2020/5/22.
//  Copyright © 2020 刘盖. All rights reserved.
//

import UIKit
import CommonCrypto
import SystemConfiguration.CaptiveNetwork

// MARK: - 字符串空格与换行去除相关
extension String{
    
    // MARK: -  去掉所有换行和空格
    public mutating func removeSpaceAndNewline(){
        self = self.replacingOccurrences(of: " " , with: "")
        self = self.replacingOccurrences(of: "\r", with: "")
        self = self.replacingOccurrences(of: "\n", with: "")
        self = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    // MARK: 去掉首尾空格
    public mutating func removeHeadAndTailSpace(){
        
        guard self.count>0 else {
            return
        }
        
        self = self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
}

// MARK: - MD5加密
extension String{
    public var md5String:String{
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        return String(format: hash as String)
    }
}

// MARK: - 字符串校验
extension String{
    // MARK: 邮箱地址校验
    public var isValidEmail: Bool{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }
    
    // MARK: 字符串是否为数字校验
    public var isNumber: Bool{
        let regex = "[0-9]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    public static func isEmpty(str: String?) -> Bool {
        guard let strTemp = str else {
            return true
        }
        var strFinal = strTemp
        strFinal.removeSpaceAndNewline()
        if strFinal.count>0 {
            return false
        }
        return true
    }
}

// MARK: - 计算size
extension String{
    func size(width: CGFloat = 0, fontSize: CGFloat = 16,font:UIFont?) -> CGSize {
        var fontTemp = UIFont.systemFont(ofSize: fontSize)
        if let font = font{
            fontTemp = font
        }
        let attrDict = [NSAttributedString.Key.font:fontTemp]
        let str:NSString = self as NSString
        return str.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesFontLeading, attributes: attrDict, context: nil).size
    }
}

// MARK: - 系统字符串相关
extension String{
    
    // MARK 系统版本号
    static var sys_version:String {
        return UIDevice.current.systemVersion
    }
    
    // MARK: app版本号
        static func appVersion() -> String{
            if let dict = Bundle.main.infoDictionary {
    //            if let version =  dict["CFBundleShortVersionString"]{
    //                return version as! String
    //            }
                
                for (key,value) in dict{
                    print("\(key):\(value)")
                }
            }
            return "1.0"
        }
        
        // MARK: app名字
        static func appName() -> String{
            if let dict = Bundle.main.infoDictionary {
                if let nameTemp =  dict["CFBundleName"]{
                    return nameTemp as! String
                }
            }
            return "壹积分"
        }

        // MARK: 获取当前wifi服务集标志(SSID)
        static func currentWifiSSID() -> String?{
            var ssid:String?
            guard let ifs = CNCopySupportedInterfaces() else{
                return nil
            }
            print(ifs)
            let count = CFArrayGetCount(ifs)
            guard count>0 else {
                return nil
            }
            
            let p = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
            CFArrayGetValues(ifs, CFRange(location: 0, length: count), p)
            let buffer = UnsafeMutableBufferPointer<UnsafeRawPointer?>.init(start: p, count: count)
            buffer.forEach {
                if let p = $0 {
    //                print(Unmanaged<NSString>.fromOpaque(p).takeUnretainedValue())
                }
            }
            
            return ""
    //        NSString *ssid = nil;
    //        NSArray *ifs = (__bridge  id)CNCopySupportedInterfaces();
    //        for (NSString *ifname in ifs) {
    //            NSDictionary *info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
    //            if (info[@"SSIDD"])
    //            {
    //                ssid = info[@"SSID"];
    //            }
    //        }
    //        return ssid;
        }
    //    + (NSString *)currentWifiSSID{
    //    //
    //    //    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    //    //    CGFloat version = [phoneVersion floatValue];
    //    //    // 如果是iOS13 未开启地理位置权限 需要提示一下
    //    //    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined && version >= 13) {
    //    //      self.locationManager = [[CLLocationManager alloc] init];
    //    //      [self.locationManager requestWhenInUseAuthorization];
    //    //    }
    //
    //    NSString *ssid = nil;
    //    NSArray *ifs = (__bridge  id)CNCopySupportedInterfaces();
    //    for (NSString *ifname in ifs) {
    //    NSDictionary *info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
    //    if (info[@"SSIDD"])
    //    {
    //    ssid = info[@"SSID"];
    //    }
    //    }
    //    return ssid;
    //    }
}
