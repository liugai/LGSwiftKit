Pod::Spec.new do |s|
  s.name         = "LGSwiftKit"
  s.version      = "1.0.1"
  s.summary      = "涵盖常用距离、比例、颜色、图片等处理工具，轮播、loading(toast)、scroll嵌套联动等组件，图片、网络等中间件"
  s.description  = "my kit"
  s.homepage     = "https://github.com/liugai/LGSwiftKit"
  s.license      = "MIT"
  s.author             = { "Liu Gai 刘盖" => "1477650746@qq.com" }
  s.source       = { :git => "https://github.com/liugai/LGSwiftKit.git", :tag => s.version }
  s.requires_arc = true
  s.platform = :ios, "9.0"
  
  s.subspec 'LGSwiftTool' do |m|
      m.source_files = 'LGSwiftKit/Tools/**/*'
  end
  
  s.subspec 'LGSwiftCarousel' do |m|
      m.source_files = 'LGSwiftKit/UI/Carousel/**/*'
      m.dependency 'LGSwiftKit/LGSwiftTool'
  end
  
  s.subspec 'LGSwiftHud' do |m|
      m.source_files = 'LGSwiftKit/UI/Hud/**/*'
      m.dependency 'LGSwiftKit/LGSwiftTool'
  end
  
  s.subspec 'LGSwiftLinkedScroll' do |m|
      m.source_files = 'LGSwiftKit/UI/ScrollView/**/*'
      m.dependency 'LGSwiftKit/LGSwiftTool'
  end
  
  s.subspec 'LGSwiftUI' do |m|
      m.source_files = 'LGSwiftKit/UI/**/*'
      m.dependency 'LGSwiftKit/LGSwiftTool'
  end
  
  s.subspec 'LGLayoutAdapter' do |m|
      m.source_files = 'LGSwiftKit/LayoutAdapter/**/*'
      m.dependency 'LGSwiftKit/LGSwiftTool'
      m.dependency 'SnapKit', '4.2.0'
  end
  
  s.subspec 'LGImageAdapter' do |m|
      m.source_files = 'LGSwiftKit/ImageAdapter/**/*'
      m.dependency 'LGSwiftKit/LGSwiftTool'
      m.dependency 'Kingfisher', '4.10.1'
  end
  
  s.subspec 'LGNetworkingAdapter' do |m|
      m.source_files = 'LGSwiftKit/NetworkingAdapter/**/*'
      m.dependency 'LGSwiftKit/LGSwiftTool'
      m.dependency 'Alamofire', '4.9.1'
  end
  
  s.subspec 'LGJsonAdapter' do |m|
      m.source_files = 'LGSwiftKit/JsonAdapter/**/*'
      m.dependency 'LGSwiftKit/LGSwiftTool'
      m.dependency 'SwiftyJSON', '5.0.1'
  end
  
  
  
end
