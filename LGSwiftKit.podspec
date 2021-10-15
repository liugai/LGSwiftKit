Pod::Spec.new do |s|
  s.name         = "LGSwiftKit"
  s.version      = "0.0.2"
  s.summary      = "A short description of LGSwiftKit."
  s.description  = "my kit"
  s.homepage     = "https://github.com/liugai/LGSwiftKit"
  s.license      = "MIT"
  s.author             = { "Liu Gai 刘盖" => "1477650746@qq.com" }
  s.source       = { :git => "https://github.com/liugai/LGSwiftKit.git", :tag => s.version }
  s.requires_arc = true
  s.source_files  = "LGSwiftKit/**/*"
  s.platform = :ios, "9.0"
end
