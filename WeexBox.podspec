Pod::Spec.new do |s|
  s.name         = "WeexBox"
  s.version      = "1.3.6"
  s.summary      = "WeexBox."
  s.homepage     = "https://github.com/aygtech/weexbox-ios-library"
  s.license      = "MIT"
  s.author       = { "Mario" => "myeveryheart@qq.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/aygtech/weexbox-ios-library.git", :tag => "#{s.version}" }
  s.source_files = 'WeexBox/**/**/*.{swift,h,m}'
  s.swift_version = '4.2'
  s.requires_arc = true
  s.frameworks = 'Foundation', 'UIKit'
  s.libraries = 'sqlite3'

  s.dependency 'WeexSDK', '0.20.0'
  s.dependency 'WXDevtool', '~> 0.20.0'
  s.dependency 'Alamofire', '~> 4.0'
  s.dependency "Alamofire-Synchronous", '~> 4.0'
  s.dependency 'SwiftyJSON', '~> 4.0'
  s.dependency 'HandyJSON', '~> 5.0'
  s.dependency 'MBProgressHUD', '~> 1.0'
  s.dependency 'AsyncSwift', '~> 2.0'
  s.dependency 'RealmSwift', '~> 3.0'
  s.dependency 'Zip', '~> 1.0'
  s.dependency 'RTRootNavigationController_WeexBox', '~> 0.7.0'
  s.dependency 'SnapKit', '~> 4.0'
  s.dependency 'SDWebImage', '~> 4.0'
  s.dependency 'BindingX', '~> 1.0'
  s.dependency 'Hue', '~> 4.0'
  s.dependency 'SwiftEventBus', '~> 5.0'
  s.dependency 'TZImagePickerController', '~> 3.0'
  s.dependency 'LBXScan/LBXNative', '~> 2.0'
  s.dependency 'LBXScan/UI', '~> 2.0'
  s.dependency 'Charts', '~> 3.0'
  s.dependency 'VasSonic', '~> 3.0'
  s.dependency 'XFAssistiveTouch_WeexBox', '~> 1.0'
  s.dependency 'lottie-ios', '~> 2.0'
end
