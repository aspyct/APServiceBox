#
# Be sure to run `pod spec lint APServiceBox.podspec' to ensure this is a
# valid spec.
#
# Remove all comments before submitting the spec. Optional attributes are commented.
#
# For details see: https://github.com/CocoaPods/CocoaPods/wiki/The-podspec-format
#
Pod::Spec.new do |s|
  s.name         = "APServiceBox"
  s.version      = "0.1.0"
  s.summary      = "Dependency injection for iOS / ObjC."
  s.homepage     = "http://aspyct.org/apservicebox"
  s.license      = 'MIT'
  s.author       = { "Antoine d'Otreppe" => "a.dotreppe@aspyct.org" }
  s.source       = { :git => "https://github.com/aspyct/APServiceBox.git", :tag => "0.1.0" }
  s.source_files = 'Classes', 'APServiceBox/**/*.{h,m}'
  s.requires_arc = true
end
