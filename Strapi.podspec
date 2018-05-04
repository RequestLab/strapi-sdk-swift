#
#  Be sure to run `pod spec lint SliderFramework.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "Strapi"
  s.version      = "0.1"
  s.summary      = "Advanced usage of UIAlertController with TextField, DatePicker, PickerView, TableView and CollectionView."
  s.homepage     = "https://github.com/RequestLab/strapi-sdk-swift.git"
  s.license      = "MIT"
  s.author       = { "lgriffie" => "loic@requestlab.fr" }
  s.swift_version = '4.0'
  s.ios.deployment_target  = '9.0'
  s.osx.deployment_target  = '10.13'
  s.source       = { :git => "https://github.com/RequestLab/strapi-sdk-swift.git", :tag => "#{s.version}" }
  s.source_files  = "strapi/**/*.{swift}"
  s.dependency 'Alamofire'
end
