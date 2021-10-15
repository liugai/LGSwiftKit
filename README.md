# LGSwiftKit
常用Swift工具类(尺寸、轮播组件、日期等)

# CocoaPods
pod 'LGSwiftKit'

# 使用
import LGSwiftKit

# 内容说明
图片示例
![Image text](https://github.com/liugai/LGSwiftKit/blob/master/res/carousel1.PNG)


LGAttributeString.swift ，计算字符串宽高

LGBool.swift  是否是全屏手机判断

LGCGExtension.swift  包含屏幕宽高、导航栏、状态栏、tabbar等高度定义

LGColor.swift  包含16进制颜色转化等api

LGDate.swift 包含时间戳、时间字符串等时间与字符串相互转化

LGDefine.swift

LGFont.swift 字体处理

LGImage.swift， 颜色转图片

LGString.swift 字符串处理，去空格、换行，数字、邮箱格式等校验，字符串宽高计算等

LGTool.swift

LGWeakProxy.swift， 可以用来打破Timer循环引用
```
self.timer = Timer(timeInterval: self.timerInterval, target: LGWeakProxy.proxyWithTarget(self, selector: #selector(self.autoScrollAction)), selector: #selector(self.autoScrollAction), userInfo: nil, repeats: true)
```

