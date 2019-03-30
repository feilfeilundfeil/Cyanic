platform :ios, '10.0'

def pods
  use_frameworks!

  pod 'RxSwift'
  pod 'RxDataSources'
  pod 'LayoutKit', :git => 'https://github.com/hooliooo/LayoutKit.git'
  pod 'Kio'
  pod 'Alacrity'
  pod 'CommonWidgets', :git => 'https://github.com/feilfeilundfeil/CommonWidgets.git'
  pod 'Sourcery'

end

target 'Cyanic' do
  pods
end

target 'Tests' do
  pods
  pod 'Quick'
  pod 'Nimble'
end

target 'Example' do
  pods
  pod 'SideMenu'
end
