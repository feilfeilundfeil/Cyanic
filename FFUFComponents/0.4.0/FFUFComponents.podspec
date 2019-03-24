Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.name         = "FFUFComponents"
  spec.version      = "0.4.0"
  spec.summary      = "FFUFComponents is a MvRx-inspired framework that aims to build a reactive UI in a UICollectionView / UITableView."

  spec.homepage     = "https://bitbucket.org/FFUF/ffuf-ios-components/src/master/"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.author             = { "Julio Alorro" => "julio.alorro@ffuf.de" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.ios.deployment_target = "10.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.source       = { :git => "git@bitbucket.org:FFUF/ffuf-ios-components.git", :tag => spec.version }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.source_files  = "Sources/**/*.swift", "Sources/Components/**/*.swift"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.requires_arc = true
  spec.swift_version = "4.2"

  spec.dependency "RxSwift"
  spec.dependency "RxDataSources"
  spec.dependency "LayoutKit"
  spec.dependency "Kio"
  spec.dependency "Alacrity"
  spec.dependency "FFUFWidgets"
  spec.dependency "Sourcery"

end
