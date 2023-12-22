Pod::Spec.new do |s|
  s.name             = 'SwiftRestClient'
  s.version          = '0.5.0'
  s.summary          = 'Simple Swift Rest client'

  s.homepage         = 'https://github.com/duhnnie/SwiftRestClient'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Canedo Ramos' => 'me@duhnnie.net' }
  s.source           = { :git => 'https://github.com/duhnnie/SwiftRestClient.git', :tag => s.version.to_s }

  ios_deployment_target = '11.0'
  osx_deployment_target = '10.15'
  watchos_deployment_target = '4.0'
  tvos_deployment_target = '11.0'

  s.ios.deployment_target = ios_deployment_target
  s.osx.deployment_target = osx_deployment_target
  s.watchos.deployment_target = watchos_deployment_target
  s.tvos.deployment_target = tvos_deployment_target

  s.swift_versions = ['5']

  s.source_files = 'Sources/SwiftRestClient/**/*'
end
