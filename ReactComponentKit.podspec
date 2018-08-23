Pod::Spec.new do |s|
  s.name         = "ReactComponentKit"
  s.version      = "0.0.3"
  s.summary      = "ReactComponentKit is library for building UIViewController based on Components."
  s.homepage     = "https://github.com/skyfe79/ReactComponentKit"
  s.license      = "MIT"
  s.author             = { "Burt.K" => "skyfe79@gmail.com" }
  s.social_media_url   = "http://twitter.com/skyfe79"
  s.platform     = :ios
  s.ios.deployment_target = "9.0"
  s.swift_version         = "4.1"
  s.source       = { :git => "https://github.com/skyfe79/ReactComponentKit.git", :tag => "#{s.version}" }
  s.source_files  = "ReactComponentKitApp/ReactComponentKit/**/{*.swift}"
  s.requires_arc = true
  s.dependency "RxSwift", "~> 4.2.0"
  s.dependency "RxCocoa", "~> 4.2.0"
  s.dependency "BKRedux", "~> 0.0.7"
  s.dependency "BKEventBus", "~> 1.0.6"
  s.dependency "SnapKit", "~> 4.0.0"
end