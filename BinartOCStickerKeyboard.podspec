#
# Be sure to run `pod lib lint BinartOCStickerKeyboard.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  # 1 - Specs
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  
  s.name = 'BinartOCStickerKeyboard'
  s.summary = "表情输入键盘"
  s.description  = "表情输入键盘，仿最新微信样式"
  s.requires_arc = true

  # 2 - Version
  s.version = "0.2.1"

  # 3 - License
  s.license = { :type => "MIT", :file => "LICENSE" }

  # 4 - Author
  s.author = { "fallen ink" => "fengzilijie@qq.com" }

  # 5 - Homepage
  s.homepage = "https://github.com/fallending/BinartSwiftInputBar-iOS"

  # 6 - Source
  s.source = { :git => "https://github.com/fallending/BinartSwiftInputBar-iOS.git", :tag => "#{s.version}"}

  # 7 - Dependencies
  s.framework = "UIKit"

  # 8 - Sources
  s.source_files = 'StickerKeyboard/Classes/**/*'
  s.resources = [
    'StickerKeyboard/Assets/SampleSticker.bundle',
    'StickerKeyboard/Assets/SampleSticker.plist'
  ]

  # 9.....
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
