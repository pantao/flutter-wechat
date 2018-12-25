#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'wechat'
  s.version          = '0.0.5'
  s.summary          = 'Wechat Plugin for Flutter app.'
  s.description      = <<-DESC
Wechat SDK for Flutter App.
                       DESC
  s.homepage         = 'https://github.com/pantao/flutter-wechat'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Pan Tao' => '54778899@qq.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.static_framework = true
  
  s.dependency 'Flutter'
  s.dependency 'WechatOpenSDK'

  s.frameworks = ["SystemConfiguration", "CoreTelephony"]
  s.libraries = ["z", "sqlite3.0", "c++"]

  s.ios.deployment_target = '8.0'
end

