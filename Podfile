# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

# ignore all warnings from all dependencies
inhibit_all_warnings!

target 'PeerGC' do
  # Comment the next line if you don't want to use dynamic frameworks
  # use_frameworks!

  # Pods for PeerGC

	pod 'Firebase'	
	pod 'FirebaseUI'
	pod 'Firebase/Auth'	
	pod 'Firebase/Core'
	pod 'Firebase/Functions'
	pod 'Firebase/Crashlytics'
	pod 'Firebase/Analytics'
	pod 'Firebase/Messaging'
	pod 'Firebase/Performance'
	pod 'Firebase/Firestore'
	pod 'FBSDKCoreKit', :modular_headers => true
	pod 'MessageKit', '3.1.0'
	pod 'SwiftLint'

  target 'PeerGCTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PeerGCUITests' do
    # Pods for testing
  end

end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
end