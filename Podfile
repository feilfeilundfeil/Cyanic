platform :ios, '10.0'

use_frameworks!

def pods
  pod 'RxSwift'
  pod 'RxDataSources'
  pod 'LayoutKit', :git => 'https://github.com/hooliooo/LayoutKit.git'
  pod 'Sourcery'
end

target 'Cyanic' do
  pods
end

target 'Tests' do
  pod 'Cyanic'
  pod 'Quick'
  pod 'Nimble'
end

target 'Example' do
  pod 'SideMenu'
  pod 'Alacrity'
  pod 'Kio'
end
