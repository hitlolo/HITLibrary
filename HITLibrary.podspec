#
# Be sure to run `pod lib lint HITLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HITLibrary'
  s.version          = '0.1.0'
  s.summary          = 'HITLibrary.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/hitlolo/HITLibrary'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lolo' => 'hitlolo@qq.com' }
  s.source           = { :git => 'https://github.com/hitlolo/HITLibrary.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  # s.source_files = 'HITLibrary/Classes/**/*'

  s.subspec 'UIKitCategory' do |UIKitCategory|
    UIKitCategory.source_files = 'Pod/Classes/UIKitCategory/**/*'
    UIKitCategory.public_header_files = 'Pod/Classes/UIKitCategory/**/*.h'
  end

  s.subspec 'HITMarqueeLabel' do |HITMarqueeLabel|
    HITMarqueeLabel.source_files = 'Pod/Classes/HITMarqueeLabel/**/*'
    HITMarqueeLabel.public_header_files = 'Pod/Classes/HITMarqueeLabel/**/*.h'
    # ui.resource = "Pod/Assets/MLSUIKitResource.bundle"
    HITMarqueeLabel.dependency 'HITLibrary/UIKitCategory'
  end

  # s.resource_bundles = {
  #   'HITLibrary' => ['HITLibrary/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
