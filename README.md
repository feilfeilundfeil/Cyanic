# Cyanic

Cyanic is an iOS framework created at [Feil, Feil, & Feil GmbH](https://ffuf.de/en/)  in response to a need for state-driven UI. It borrows heavily
from the concepts of Airbnb's [MvRx](https://github.com/airbnb/MvRx) framework (which our Android developers use) to create a very similar
code base with Android thereby unifying the business logic in both platforms. We use this framework to create complex, performant, and reactive
screens in our projects.

Cyanic is a Swift only framework. There are no plans to make it compatible with Objective-C.

## Installation
### [CocoaPods](http://cocoapods.org/)

Requirements:
* Swift 5.0+
* iOS 10.0+

1. Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):
    ```rb
    pod 'Cyanic', :git => 'https://github.com/feilfeilundfeil/Cyanic.git'
    pod 'CommonWidgets', :git => 'https://github.com/feilfeilundfeil/CommonWidgets.git'
    pod 'LayoutKit', :git => 'https://github.com/hooliooo/LayoutKit.git'
    ```

2. Integrate your dependencies using frameworks: add `use_frameworks!` to your Podfile. 
3. Run `pod install`.

## Documentation

Check out our [wiki](https://github.com/feilfeilundfeil/Cyanic/wiki) for full documentation. 

## A Simple Example

A very simple example with expandable functionality:

```swift
struct YourState: ExpandableState {
    
    enum Section: String, CaseIterable {
        case first
        case second
    }

    static var `default`: YourState { 
        return YourState(
            text: "Hello, World!",
            expandableDict: YourState.Section.allCases.map { $0.rawValue }
                .reduce(into: [String: Bool](), { (current: inout [String: Bool], id: String) -> Void in
                    current[id] = false
                }
        ) 
    } 

    var text: String
    var expandableDict: [String: Bool]
}

class YourViewModel: ViewModel<YourState> {
    func showCyanic() {
        self.setState { $0.text = "Hello, Cyanic!" }
    }
}

class YourComponentViewController: ComponentViewController {
    
    private let viewModel: YourViewModel = YourViewModel(initialState: YourState.default)
    
    override var viewModels: [AnyViewModel] {
        return [self.viewModel.asAnyViewModel]
    }
    
    override func buildComponents(_ componentsController: inout ComponentsController) {
        withState(self.viewModel) { (state: YourState) -> Void in
            componentsController.staticTextComponent {
                $0.id = "title"
                $0.text = state.text
            }
            
            componentsController.buttonComponent {
                $0.id = "button"
                $0.onTap = { [weak self]
                    self?.viewModel.showCyanic()
                }
            }
            
            let firstExpandableID: String = YourState.Section.first.rawValue
            
            let yourExpandable = components.expandableComponent { [weak self] in
                guard let s = self else { return }
                $0.id = firstExpandableID
                $0.contentLayout = LabelContentLayout(text: Text.unattributed("Hello, World!"))
                $0.isExpanded = state.expandableDict[firstExpandableID] ?? false
                $0.setExpandableState = self.viewModel.setExpandableState
                $0.backgroundColor = UIColor.lightGray
                $0.height = 55.0
            }
            
            // These ButtonComponents will only show up when yourExpandable is expanded.
            if yourExpandable.isExpanded {
                for number in 1...5 {
                    componentsController.buttonComponent {
                        $0.id = "button\(number)"
                        $0.title = "\(number)"
                        $0.onTap = { [weak self]
                            print("Hello, World from Button \(number)")
                        }
                    }
                }
            }
        }
    }
}
```

## Contributors

* Julio Alorro (julio.alorro@ffuf.de)
* Jonas Bark (jonas.bark@ffuf.de)
