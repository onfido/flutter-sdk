#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint onfido_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'onfido_sdk'
  s.version          = '0.0.1'
  s.summary          = 'Official Onfido Flutter Plugin'
  s.description      = 'The official Onfido Flutter plugin wrapping native Onfido SDKs'
  s.homepage         = 'https://www.onfido.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Onfido Ltd' => 'info@onfido.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Onfido', '~> 30.5.0'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
