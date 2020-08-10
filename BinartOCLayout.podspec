
Pod::Spec.new do |s|

    # 1 - Specs
    s.platform = :ios
    s.ios.deployment_target = '9.0'
    s.name = 'BinartOCLayout'
    s.summary = "The Final autoLayout, exprimental in InputBar"
    s.description  = "The Final autoLayout, exprimental in InputBar....."
    s.requires_arc = true

    # 2 - Version
    s.version = "1.0.0"

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
    s.source_files = 'BinartOCLayout/Classes/**/*.{h,m}'
end
