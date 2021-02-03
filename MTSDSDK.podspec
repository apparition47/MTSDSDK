Pod::Spec.new do |s|

  s.name                  = 'MTSDSDK'
  s.version               = '0.0.1'

  s.cocoapods_version     = '>= 1.7.0'

  s.module_name           = 'MTSDSDK'
  s.ios.deployment_target = '10.0'
  s.source                = { :git => 'https://github.com/apparition47/MTSDSDK.git', :tag => s.version.to_s }

  s.source_files          = 'Sources/**/*.swift'
  s.swift_version         = ['5.0', '5.1', '5.2', '5.3', '5.4']

end
