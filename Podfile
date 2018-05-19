platform :ios, '9.0'

target 'TravelApp' do
    use_frameworks!
    
    pod 'Alamofire', '~> 4.7'
    pod 'SwiftyJSON', '~> 4.0'
    pod 'AlamofireImage', '~> 3.3'
    pod "ForecastIO"
    pod 'Cosmos', '~> 16.0'
    post_install do |installer|
        installer.pods_project.build_configurations.each do |config|
            config.build_settings.delete('CODE_SIGNING_ALLOWED')
            config.build_settings.delete('CODE_SIGNING_REQUIRED')
        end
    end
    pod 'NotificationBannerSwift'
    pod 'DropDown'
    
end
