Pod::Spec.new do |s|
  s.name     = 'Tapglue'
  s.version  = '3.0.1'
  s.license  = 'Apache License, Version 2.0'
  s.summary  = 'Tapglue enables mobile developers to create products with a social graph and a news feed in hours instead of weeks.'
  s.homepage = 'https://developers.tapglue.com/docs/ios'
  s.social_media_url = 'https://twitter.com/tapglue'
  s.authors  = { 'Tapglue' => 'devs@tapglue.com' }
  s.source   = { :git => 'https://github.com/tapglue/ios_sdk.git', :tag => "v#{s.version}" }
  s.requires_arc = true
  s.ios.deployment_target = '9.0'
  s.source_files = 'Sources/**/*.{swift}'

  s.dependency 'RxSwift', '3.0.1'
  s.dependency 'ObjectMapper', '2.0.0'
end
