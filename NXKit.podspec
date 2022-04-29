Pod::Spec.new do |s|
    s.name             = 'NXKit'
    s.version          = '1.0.0.220901'
    s.summary          = 'NXKit is a Swift UI framework for iOS.'
    s.description      = <<-DESC
        NXKit is a Swift UI framework for iOS.
    DESC
    s.homepage         = 'https://github.com/niegaotao/NXKit'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'niegaotao' => '247268158@qq.com' }
    s.source           = { :git => 'https://github.com/niegaotao/NXKit.git', :tag => s.version.to_s }
    s.platform         = :ios, '9.0'
    s.swift_version    = '5.0'

    s.frameworks = ['UIKit', 'Foundation']
    s.subspec 'Foundation' do |ss|
            ss.source_files = 'NXKit/Classes/Foundation/*'
            ss.resource_bundles = {
                'NXKit' => ['NXKit/Assets/*']
            }
    end
    s.subspec 'Extensions' do |ss|
            ss.source_files = 'NXKit/Classes/Extensions/*'
            ss.dependency 'NXKit/Foundation'
    end
end
