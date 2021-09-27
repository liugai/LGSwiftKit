//
//  LGImageTool.swift
//  Integraler
//
//  Created by 刘盖 on 2020/5/22.
//  Copyright © 2020 刘盖. All rights reserved.
//

import UIKit
import CoreGraphics.CGContext

extension UIImage{

    public static func image_placeholder_head(gender:Int) -> UIImage?{
        if gender == 1{
            return UIImage(named: "user_head_woman")
        }
        return UIImage(named: "user_head_man")
    }

    
    // MARK:颜色生成图片：指定某一边有边框的
    public enum LGImageBorderPosition{
        case None,Left,Top,Right,Bottle,All
    }
    public enum LGImageShape {
        case Rectangle //矩形
        case RectCorner(radius:CGFloat) //带圆角的矩形(带圆角，椭圆)
        case Circle
    }
    
    public static func imageFrom(color: UIColor, size: CGSize,shape:LGImageShape = .Rectangle, borderPos: LGImageBorderPosition = .None,borderWidth: CGFloat = 0, borderColor:UIColor = UIColor.clear, word:String = "", wordColor:UIColor = UIColor.clear, wordFontSize:CGFloat = 18) -> UIImage{
        var rectFill = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        var rectBorder:CGRect? = rectFill
        UIGraphicsBeginImageContext(rectBorder!.size)
        switch borderPos {
        case .None:
            rectBorder = nil
        case .Left:
            rectFill.origin.x += borderWidth
            rectFill.size.width -= borderWidth
        case .Right:
            rectFill.size.width -= borderWidth
        case .Top:
            rectFill.origin.y += borderWidth
            rectFill.size.height -= borderWidth
        case .Bottle:
            rectFill.size.height -= borderWidth
        case .All:
            rectFill.origin.x += borderWidth
            rectFill.origin.y += borderWidth
            rectFill.size.width -= borderWidth*2
            rectFill.size.height -= borderWidth*2
        }
        
        let context = UIGraphicsGetCurrentContext()
        var borderPath:UIBezierPath?
        
        var borderRadius:CGFloat = 0
        var fillRadius:CGFloat = 0
        switch shape {
        case let .RectCorner(radius: radiusTemp):
            borderRadius = min(radiusTemp, min(size.width/2, size.height/2))
            fillRadius = min(radiusTemp, min(rectFill.size.width/2, rectFill.size.height/2))
        case .Circle:
            borderRadius = size.width/2
            fillRadius = rectFill.size.width/2
        default:
            borderRadius = 0
            fillRadius = 0
        }
        let fillPath = UIBezierPath(roundedRect: rectFill, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: fillRadius, height: fillRadius))
        if let rectBorderNew = rectBorder {
            context?.setFillColor(borderColor.cgColor)
            borderPath = UIBezierPath(roundedRect: rectBorderNew, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: borderRadius, height: borderRadius))
            borderPath?.fill()
        }
        
        context?.setFillColor(color.cgColor)
        fillPath.fill()
    
        if word.count>0 {
            let textStyle = NSMutableParagraphStyle()
            textStyle.lineBreakMode = .byWordWrapping
            textStyle.alignment = .center
            let attrDict:[NSAttributedString.Key:Any] = [NSAttributedString.Key.paragraphStyle:textStyle,NSAttributedString.Key.foregroundColor:wordColor,NSAttributedString.Key.kern:0,NSAttributedString.Key.font:UIFont.systemFont(ofSize: wordFontSize)]
            let wordSize = (word as NSString).size(withAttributes: attrDict)
            let marginTop = (rectFill.size.height-wordSize.height)/2
            let rectWord = CGRect(x: rectFill.origin.x, y: rectFill.origin.y+marginTop, width: rectFill.size.width, height: wordSize.height)
            (word as NSString).draw(in: rectWord, withAttributes: attrDict)
        }
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img ?? UIImage()
    }
    
    public static func imageDefalut() -> UIImage{
        return self.imageFrom(color: UIColor.white, size: CGSize(width: 2, height: 2))
    }
    
    public static func imageFrom(color:UIColor) -> UIImage{
        return self.imageFrom(color: color, size: CGSize(width: 2, height: 2), shape: .Rectangle, borderPos: .None, borderWidth: 0)
    }
    
    public static func imageFrom(color:UIColor, size:CGSize) -> UIImage{
        return self.imageFrom(color: color, size: size, shape: .Rectangle, borderPos: .None, borderWidth: 0)
    }
    
    public static func imageFrom(color:UIColor, size:CGSize, shape:LGImageShape) -> UIImage{
        return self.imageFrom(color: color, size: size, shape: shape, borderPos: .None, borderWidth: 0)
    }
    
    public static func imageFrom(color:UIColor, size:CGSize, shape:LGImageShape, borderPos:LGImageBorderPosition, borderWidth:CGFloat, borderColor:UIColor) -> UIImage{
        return self.imageFrom(color: color, size: size, shape: shape, borderPos: borderPos, borderWidth: borderWidth, borderColor: borderColor)
    }
    
    public static func imageFrom(color: UIColor, size: CGSize,shape:LGImageShape, word:String, wordColor:UIColor, wordFontSize:CGFloat = 18) -> UIImage{
        return self.imageFrom(color: color, size: size, shape: shape,  word: word, wordColor: wordColor, wordFontSize: wordFontSize)
    }

    // MARK: - 绘制渐变色
    // MARK: 渐变色绘制
    private static func drawLinerChangedImage(context: CGContext, path: CGPath, beiginColor: UIColor, endColor: UIColor){
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]
        let colors = [beiginColor.cgColor,endColor.cgColor]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations:locations)
        guard let gradientNew = gradient else {
            return
        }
        let pathRect = path.boundingBox
        let startPoint = CGPoint(x: pathRect.minX, y: pathRect.midY)
        let endPoint = CGPoint(x: pathRect.maxX, y: pathRect.midY)
        context.saveGState()
        context.addPath(path)
        context.clip()
        context.drawLinearGradient(gradientNew, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        context.restoreGState()
        
    }
    
    public static func imageLinerChanged(size: CGSize, beiginColor: UIColor, endColor: UIColor) -> UIImage{
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        guard let contextNew = context else{
            return UIImage()
        }
        let path = CGMutablePath()
        path.addRect(rect)
        self.drawLinerChangedImage(context: contextNew, path: path, beiginColor: beiginColor, endColor: endColor)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    

//    static UIImage *imgAwardCutScoreBackNormal;
//    static UIImage *imgAwardCutScoreBackSelected;
//    + (UIImage *)imgAwardCutScoreBackIsNormal:(BOOL)isNormal{
//        if (isNormal) {
//            if (!imgAwardCutScoreBackNormal) {
//                imgAwardCutScoreBackNormal = [UIImage imageWithColor:[UIColor colorOxString:@"#02CF7B"]];
//            }
//            return imgAwardCutScoreBackNormal;
//        }
//
//        if (!imgAwardCutScoreBackSelected) {
//            imgAwardCutScoreBackSelected = [UIImage imageWithColor:LG_COLOR_MAIN_RED];
//        }
//        return imgAwardCutScoreBackSelected;
//
//    }
    
}
