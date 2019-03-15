platform :ios, '10.0'

def pods
  use_frameworks!

  pod 'RxSwift'
  pod 'RxDataSources'
  pod 'LayoutKit', :git => 'git@github.com:hooliooo/LayoutKit.git'
  pod 'Kio'
  pod 'Alacrity'
  pod 'FFUFWidgets', :git => 'git@bitbucket.org:FFUF/ffuf-ios-widgets.git'
  pod 'Sourcery'

end

target 'FFUFComponents' do
  pods
end

target 'Tests' do
  pods
  pod 'Quick'
  pod 'Nimble'
end

target 'Example' do
  pods
end
