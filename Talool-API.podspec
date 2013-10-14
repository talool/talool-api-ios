Pod::Spec.new do |s|
  s.name                = "Talool-API"
  s.version             = "1.0.1"
  s.summary             = "Talool client library"
  s.description         = <<-DESC
                          This Library handles all service calls for Talool, so you can
                          work simply with Merchants, Deals, Activities, and Offers.
                          DESC
  s.homepage            = "https://github.com/talool/talool-api-ios"
  s.license             = 'MIT'
  s.authors             = { "Doug McCuen" => "doug@talool.com", "Chris Lintz" => "chris@talool.com", "Cory Zachman" => "cory@talool.com" }
  s.platform            = :ios, '7.0'
  s.source              = { :git => "https://github.com/talool/talool-api-ios.git", :tag => "v#{s.version}" }
  s.source_files        = 'talool-api-ios/**/*.{h,m}', 'talool-api-ios', 'Classes', 'Classes/**/*.{h,m}'

  s.vendored_library    = 'talool-api-ios/libGoogleAnalytics.a'
  
  s.resource            = "talool-api-ios/talool-api-ios.bundle"
  s.preserve_paths      = 'talool-api-ios/talool-api-ios/*'
  s.frameworks          = 'CoreFoundation', 'Foundation', 'UIKit', 'SystemConfiguration', 'CoreData', 'SenTestingKit'
  s.requires_arc        = true

  s.dependency 'GoogleAnalytics-iOS-SDK', "~> 3.0.1"

end
