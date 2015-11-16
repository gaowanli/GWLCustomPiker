Pod::Spec.new do |s|
  s.name         = "GWLCustomPiker"
  s.version      = "1.0.1"
  s.summary      = "自定义外观的pikcerView，使用方法和UIPikcerView基本一致"
  s.homepage     = "https://github.com/gaowanli/GWLCustomPiker"
  s.license      = "MIT"
  s.author       = { "Wanli Gao" => "im_gwl@163.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/gaowanli/GWLCustomPiker.git", :tag => s.version }
  s.source_files = "GWLCustomPiker/GWLCustomPiker/*"
  s.requires_arc = true
end
