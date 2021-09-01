Pod::Spec.new do |s|
    s.name             = 'NXKit'
    s.version          = '0.8.8'
    s.summary          = 'NXKit is a Swift UI framework for iOS.'
    s.description      = <<-DESC
        NXKit is a Swift UI framework for iOS.
    DESC
    s.homepage         = 'https://github.com/niegaotao/NXKit'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'niegaotao' => 'niegaotao@163.com' }
    s.source           = { :git => 'git@github.com:niegaotao/NXKit.git', :tag => s.version.to_s }
    s.platform         = :ios, '9.0'
    s.swift_version    = '5.0'
    s.source_files = 'NXKit/Classes/**/*'
    s.resource_bundles = {
        'NXKit' => ['NXKit/Assets/*.png']
    }
    s.frameworks = ['UIKit', 'Foundation']
end
