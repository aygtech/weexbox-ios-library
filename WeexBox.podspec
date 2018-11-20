Pod::Spec.new do |s|
  s.name         = "WeexBox"
  s.version      = "0.5.0"
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

  s.dependency 'WeexSDK', '~> 0.19.0'
  s.dependency 'WXDevtool', '~> 0.17.0'
  s.dependency 'Alamofire'
  s.dependency "Alamofire-Synchronous"
  s.dependency 'SwiftyJSON'
  s.dependency 'HandyJSON'
  s.dependency 'MBProgressHUD'
  s.dependency 'AsyncSwift'
  s.dependency 'RealmSwift'
  s.dependency 'Zip'
  s.dependency 'RTRootNavigationController_WeexBox'
  s.dependency 'SnapKit'
  s.dependency 'SDWebImage'
  s.dependency 'BindingX'
  s.dependency 'Hue'
  s.dependency 'SwiftEventBus'
  s.dependency 'TZImagePickerController'
  s.dependency 'LBXScan/LBXNative'
  s.dependency 'LBXScan/UI'
  s.dependency 'Charts'
  
end
