//
//  LGColorTool.swift
//  Integraler
//
//  Created by 刘盖 on 2020/5/22.
//  Copyright © 2020 刘盖. All rights reserved.
//

import UIKit



// MARK: - 16进制颜色
extension UIColor{
    
    private enum LGColorType:String {
        case Color_2C = "#2c2c2c"
        case Color_99 = "#999999"
        case Color_66 = "#666666"
        case Color_EE = "#eeeeee"
        case Color_E3 = "#e3e3e3"
        case Color_DC = "#dcdcdc"
        case Color_F4 = "#f4f4f4"
        case Color_C5 = "#c5c5c5"
        case Color_01 = "#010101"
        case Color_A1 = "#a1a1a1"
        case Color_30 = "#303030"
    }
    
    // MARK: 颜色转换 IOS中十六进制的颜色转换为UIColor
    public static func colorOfOxString(oxString:String) -> UIColor{
        var colorString = oxString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if colorString.count<6{
            return UIColor.clear
        }
        
        var aStr: String?, rStr: String?, gStr: String?, bStr: String?
        
        var indexBegin = colorString.index(colorString.startIndex, offsetBy: 2)
        var indexEnd = colorString.endIndex
        var range:Range<String.Index> = indexBegin..<indexEnd
        if colorString.hasPrefix("0X") {
            colorString = String(colorString[range])
        }
        if colorString.hasPrefix("#") {
            colorString = colorString.replacingOccurrences(of: "#", with: "")
        }
        if colorString.count == 8 {
            range = colorString.startIndex..<colorString.index(colorString.startIndex, offsetBy: 2)
            aStr = String(colorString[range])
            colorString.replaceSubrange(range, with: "")
        }
        else if colorString.count == 6{
            aStr = "FF"
        }
        else{
            return UIColor.clear
        }
        
        indexBegin = colorString.startIndex
        indexEnd = colorString.index(indexBegin, offsetBy: 2)
        range = indexBegin..<indexEnd
        rStr = String(colorString[range])
        
        indexBegin = colorString.index(indexBegin, offsetBy: 2)
        indexEnd = colorString.index(indexBegin, offsetBy: 2)
        range = indexBegin..<indexEnd
        gStr = String(colorString[range]);
        
        indexBegin = colorString.index(indexBegin, offsetBy: 2)
        indexEnd = colorString.index(indexBegin, offsetBy: 2)
        range = indexBegin..<indexEnd
        bStr = String(colorString[range]);
        
        // Scan values
        let a: UnsafeMutablePointer<UInt64> = UnsafeMutablePointer<UInt64>.allocate(capacity: 1), r: UnsafeMutablePointer<UInt64> = UnsafeMutablePointer<UInt64>.allocate(capacity: 1), g: UnsafeMutablePointer<UInt64> = UnsafeMutablePointer<UInt64>.allocate(capacity: 1), b: UnsafeMutablePointer<UInt64> = UnsafeMutablePointer<UInt64>.allocate(capacity: 1)
        Scanner(string: aStr!).scanHexInt64(a)
        Scanner(string: rStr!).scanHexInt64(r)
        Scanner(string: gStr!).scanHexInt64(g)
        Scanner(string: bStr!).scanHexInt64(b)

        return UIColor(red: CGFloat(r.pointee)/255.0, green: CGFloat(g.pointee)/255.0, blue: CGFloat(b.pointee)/255.0, alpha: CGFloat(a.pointee)/255.0)
    }
    
    
    
    
    private static func colorFromOxEnum(_ colorType: LGColorType) -> UIColor{
        return UIColor.colorOfOxString(oxString: colorType.rawValue)
    }
    
    public class var color_2c: UIColor {
        return self.colorFromOxEnum(.Color_2C)
    }
    
    public class var color_99: UIColor {
        return self.colorFromOxEnum(.Color_99)
    }
    
    public class var color_66: UIColor {
        return self.colorFromOxEnum(.Color_66)
    }
    
    public class var color_ee: UIColor {
        return self.colorFromOxEnum(.Color_EE)
    }
    
    public class var color_e3: UIColor {
        return self.colorFromOxEnum(.Color_E3)
    }
    
    public class var color_dc: UIColor {
        return self.colorFromOxEnum(.Color_DC)
    }
    
    public class var color_f4: UIColor {
        return self.colorFromOxEnum(.Color_F4)
    }
    
    public class var color_c5: UIColor {
        return self.colorFromOxEnum(.Color_C5)
    }
    
    public class var color_01: UIColor {
        return self.colorFromOxEnum(.Color_01)
    }
    
    public class var color_a1: UIColor {
        return self.colorFromOxEnum(.Color_A1)
    }
    
    public class var color_30: UIColor {
        return self.colorFromOxEnum(.Color_30)
    }
    
}

// MARK: - RGB颜色

extension UIColor{
    public static func lg_rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, a: CGFloat = 1) -> UIColor{
        guard a>=0 && a<=1 && r>=0 && r<=255 && g>=0 && g<=255 && b>=0 && b<=255 else {
            return UIColor.clear
        }
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a/255.0)
    }
}

