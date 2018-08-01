Pod::Spec.new do |s|
  s.name         = "WeexBox"
  s.version      = "1.0.0"
  s.summary      = "WeexBox."
  s.homepage     = "https://github.com/WeexBox/ios-library"
  s.license      = "MIT"
  s.author       = { "Mario" => "myeveryheart@qq.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/WeexBox/ios-library.git", :tag => "#{s.version}" }
  s.source_files = 'WeexBox/**/*.{swift,h,m}'
  s.dependency "Alamofire-Synchronous"
  s.dependency 'SwiftyJSON'
  s.dependency 'WeexSDK', '~> 0.18.0'
  s.dependency 'HandyJSON'
  s.requires_arc = true
  
end
