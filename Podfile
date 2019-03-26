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

target 'Cyanic' do
  pods
end

target 'Tests' do
  pods
  pod 'Quick'
  pod 'Nimble'
  pod 'RxTest'
end

target 'Example' do
  pods
  pod 'SideMenu'
end
