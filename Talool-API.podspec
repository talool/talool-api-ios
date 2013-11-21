Pod::Spec.new do |s|
  s.name                = "Talool-API"
  s.version             = "1.1.1"
  s.summary             = "Talool client library"
  s.description         = <<-DESC
                          This Library handles all service calls for Talool, so you can
                          work simply with Merchants, Deals, Activities, and Offers.
                          DESC
  s.homepage            = "https://github.com/talool/talool-api-ios"
  s.license		= { :type => 'MIT', :text => <<-LICENSE
				Copyright 2013
				Permission is granted to Talool
				LICENSE
			  }
  s.authors             = { "Doug McCuen" => "doug@talool.com", "Chris Lintz" => "chris@talool.com", "Cory Zachman" => "cory@talool.com" }
  s.platform            = :ios, '7.0'
  s.source              = { :git => "https://github.com/talool/talool-api-ios.git", :tag => "v#{s.version}" }
  s.source_files        = 'talool-api-ios/**/*.{h,m}'

  s.resource            = "talool-api-ios/talool-api-ios.bundle"
  
  s.preserve_paths      = 'talool-api-ios/*'
  s.frameworks          = 'CoreFoundation', 'Foundation', 'SystemConfiguration', 'CoreData'
  s.requires_arc        = true

  s.prefix_header_file  = 'talool-api-ios/talool-api-ios-Prefix.pch'

  s.dependency 'GoogleAnalytics-iOS-SDK', "~> 3.0.1"

end
