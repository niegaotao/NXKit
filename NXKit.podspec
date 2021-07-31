#
# Be sure to run `pod lib lint NXKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'NXKit'
    s.version          = '0.3.0'
    s.summary          = 'NXKit is a Swift UI framework for iOS.'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    这是一个工具库集合，主要包括如下内容：
    1.NXKit is a Swift UI framework for iOS.
    DESC
    
    s.homepage         = 'https://github.com/niegaotao/NXKit'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'niegaotao' => 'niegaotao@163.com' }
    s.source           = { :git => 'https://github.com/niegaotao/NXKit.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.platform         = :ios, '9.0'
    s.swift_version    = '5.0'
    
    s.source_files = 'NXKit/Classes/**/*'
    
     s.resource_bundles = {
       'NXKit' => ['NXKit/Assets/*.png']
     }
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
     s.frameworks = ['UIKit', 'Foundation']
    # s.dependency 'AFNetworking', '~> 2.3'
end
