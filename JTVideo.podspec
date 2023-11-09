#
# Be sure to run `pod lib lint JTVideo.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JTVideo'
  s.version          = '0.0.1'
  s.summary          = '精特视频组件'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
精特视频组件
                       DESC

  s.homepage         = 'https://github.com/OCdes/JTVideo'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'OCdes' => '76515226@qq.com' }
  s.source           = { :git => 'https://github.com/OCdes/JTVideo.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'JTVideo/Classes/**/*'
  
   s.resource_bundles = {
     'JTVideo' => ['JTVideo/Assets/*']
   }

   s.public_header_files = 'Pod/Classes/Video/*'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AliPlayerSDK_iOS'
  s.dependency "Moya", "~> 13.0.0"
  s.dependency "HandyJSON"
  s.dependency "IQKeyboardManagerSwift"
  s.dependency "RxSwift"
  s.dependency "RxCocoa"
  s.dependency "SnapKit", "~>4.0.0"
  s.dependency "Kingfisher"
  s.dependency "MJRefresh"
  s.dependency "SVProgressHUD"
#  s.dependency "ZAAlivcBasicVideo"
end
