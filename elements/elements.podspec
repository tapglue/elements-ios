#
# Be sure to run `pod lib lint elements.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "elements"
  s.version          = "0.1.0"
  s.summary          = "A short description of elements."
  s.license          = 'MIT'
  s.author           = { "John Nilsen" => "nilsen340@gmail.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/elements.git", :tag => s.version.to_s }

  s.homepage = 'https://github.com/nilsen340/'
  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'elements' => ['Pod/Assets/*.png']
  }
end
