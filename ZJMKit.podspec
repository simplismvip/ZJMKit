#
# Be sure to run `pod lib lint ZJMKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZJMKit'
  s.version          = '0.2.0'
  s.summary          = '常用分类和工具组件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
常用分类封装📦，省去了每次都复制代码麻烦
                       DESC

  s.homepage         = 'https://github.com/simplismvip/ZJMKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '明' => 'tonyzhao60@gmail.com' }
  s.source           = { :git => 'https://github.com/simplismvip/ZJMKit.git', :tag => s.version.to_s }
  s.social_media_url = 'http://www.restcy.com'

  s.swift_version = '5.0'
  s.platform      = :ios, '10.0'
  s.source_files = [ 'ZJMKit/*.{h,swift}' ]
  
  # s.resource_bundles = {
  #   'ZJMKit' => ['ZJMKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
