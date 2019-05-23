Pod::Spec.new do |spec|

  spec.name         = "EMPlacePicker"
  spec.version      = "0.1.7"
  spec.summary      = "Google address place picker."

  spec.homepage     = "https://github.com/LahiruChathuranga/LCPlacePicker"
  spec.license      = "MIT"
  spec.author             = { "Lahiru Chathuranga" => "hiru.wlc@gmail.com" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/LahiruChathuranga/LCPlacePicker.git", :tag => "0.1.7" }
  spec.source_files  = "EMPlacePicker/**/*.{swift}"
  spec.frameworks = "UIkit", "SnapKit", "FloatingPanel", "GoogleMaps", "GooglePlaces"
  spec. static_framework = true
  spec.dependency 'GoogleMaps'
  spec.dependency 'GooglePlaces'
  spec.dependency 'FloatingPanel'
  spec.dependency 'SnapKit'

end
