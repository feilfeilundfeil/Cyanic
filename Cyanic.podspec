Pod::Spec.new do |spec|

  spec.name                  = "Cyanic"
  spec.version               = "0.4.8"
  spec.summary               = "Cyanic is a MvRx-inspired framework that aims to build a reactive UI in a UICollectionView."

  spec.description           = <<-DESC
                               Cyanic is a MvRx-inspired framework that aims to build reactive UI in a UICollectionView.
                               It borrows heavily from MvRx in terms of API and structure while falling within the constraints of
                               Swift and iOS development. It leverages RxSwift to have reactive functionality, LayoutKit to have
                               performance close to manual layout when sizing and arranging subviews, and Sourcery fast creation of
                               custom components. It uses an Model-View-ViewModel (MVVM) style of architecture.
                               DESC

  spec.homepage              = "https://github.com/feilfeilundfeil/Cyanic"
  spec.license               = { :type => "MIT", :file => "LICENSE" }
  spec.authors               =  "Feil, Feil, & Feil GmbH", "Julio Alorro", "Jonas Bark"
  spec.ios.deployment_target = "10.0"
  spec.source                = { :git => "https://github.com/feilfeilundfeil/Cyanic.git", :tag => spec.version }
  spec.source_files          = "Sources/**/*.swift", "Sources/Components/**/*.swift"
  spec.resources             = ["Templates/*"]
  spec.requires_arc          = true
  spec.swift_version         = "5.0"

  spec.dependency "LayoutKit"
  spec.dependency "RxDataSources"
  spec.dependency "RxSwift"
  spec.dependency "Sourcery"

  spec.dependency "Kio"
  spec.dependency "Alacrity"
  spec.dependency "CommonWidgets"

  spec.test_spec "Tests" do |test_spec|
    test_spec.source_files = "Tests/*.swift"
    test_spec.dependency "Quick"
    test_spec.dependency "Nimble"
  end

end
