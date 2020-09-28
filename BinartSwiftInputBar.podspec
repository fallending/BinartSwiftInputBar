
Pod::Spec.new do |s|

    # 1 - Specs
    s.platform = :ios
    s.ios.deployment_target = '11.0'
    s.name = 'BinartSwiftInputBar'
    s.summary = "Some Extension for nathantannar4/InputBarAccessoryView"
    s.description  = "Featuring reactive changes, autocomplete, image paste support and so much more."
    s.requires_arc = true
    s.swift_versions = '5.0'

    # 2 - Version
    s.version = "5.0.0"

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
    s.default_subspec = 'Core'

    s.subspec 'Core' do |ss|
      ss.source_files = "InputBar/**/*.{swift}"
    end

    # 9. Dependency
    s.dependency 'BinartOCLayout'
    s.dependency 'BinartOCPlotView'
    s.dependency 'BinartOCStickerKeyboard'
#    s.dependency 'IQKeyboardManagerSwift'
end
