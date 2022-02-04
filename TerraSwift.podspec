Pod::Spec.new do |spec|
  spec.name         = "TerraSwift"
  spec.version      = "1.0.8"
  spec.summary      = "Apple Health SDK for Terra"
  spec.description  = <<-DESC
			Apple Health SDK for Terra which pushes Apple Health data and enables connecting to the Terra API
                   DESC
  spec.homepage     = "https://docs.tryterra.co/apple-sdk"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "JaafarRammal" => "jarammal@gmail.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = "13.0"
  spec.source       = { :git => "https://github.com/tryterra/TerraSwift.git", :tag => "v#{spec.version}"}
  spec.swift_version = "4.2"
  spec.vendored_frameworks = "TerraSwift.xcframework"  
end
