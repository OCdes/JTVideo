#
# Be sure to run `pod lib lint JTVideo.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'JTVideo'
    s.version          = '0.0.2'
    s.summary          = '精特视频组件'
    s.description      = <<-DESC
    优化视频全屏方案
    DESC
    s.homepage         = 'https://github.com/OCdes/JTVideo'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'OCdes' => '76515226@qq.com' }
    s.source           = { :git => 'https://github.com/OCdes/JTVideo.git', :tag => s.version.to_s }
    s.xcconfig = { 'VALID_ARCHS' => 'arm64 x86_64 armv7 armv7s', }
    s.ios.deployment_target = '10.0'
    s.swift_versions = ['5.0']
    s.source_files = 'JTVideo/Classes/**/*'
    s.resource_bundles = {
        'JTVideo' => ['JTVideo/Assets/*']
    }
    s.dependency 'AliPlayerSDK_iOS'
    s.dependency "Moya", "~> 13.0.0"
    s.dependency "HandyJSON"
    s.dependency "SwiftyJSON"
    s.dependency "ZCycleView","1.0.2"
    s.dependency "IQKeyboardManagerSwift"
    s.dependency "RxSwift"
    s.dependency "RxCocoa"
    s.dependency "SnapKit"
    s.dependency "Kingfisher"
    s.dependency "MJRefresh"
    s.dependency "SVProgressHUD"
end
