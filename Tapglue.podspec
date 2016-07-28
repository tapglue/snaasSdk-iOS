Pod::Spec.new do |s|
  s.name     = 'Tapglue'
  s.version  = '2.0.0'
  s.license  = 'Apache License, Version 2.0'
  s.summary  = 'Tapglue enables mobile developers to create products with a social graph and a news feed in hours instead of weeks.'
  s.homepage = 'https://developers.tapglue.com/docs/ios'
  s.social_media_url = 'https://twitter.com/tapglue'
  s.authors  = { 'Tapglue' => 'devs@tapglue.com' }
  s.source   = { :git => 'https://github.com/tapglue/ios_sdk.git', :tag => "v#{s.version}" }
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.source_files = 'Sources/**/*.{swift}'

  s.dependency 'RxSwift', '2.6.0'
  s.dependency 'Alamofire', '3.4.1'
  s.dependency 'ObjectMapper', '1.3.0'
end
