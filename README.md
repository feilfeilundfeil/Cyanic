## TODO
- Create a ComponentViewController subclasses that handle one, two, three ViewModels [✅ 11.03.2019] (Deprecated)
- Update the documentation of each file [✅  05.03.2019]
- Refactor Components into structs [✅ 01.03.2019]
- Create Stencil templates for said structs to generate default values for properties [✅ 01.03.2019]
- Create the "Copyable" protocol and have these structs conform to it [✅ 01.03.2019]
    - Copyable protocol allows structs to be mutated (copied) in place
- Create the Sourcery template containing the logic to generate extensions for ComponentsArray [✅ 13.03.2019]
- Create unit tests for BaseViewModel [✅ 17.03.2019]
- Create unit tests for StateStore [✅ 22.03.2019]
- Create unit tests for ComponentViewController and CyanicViewController [✅ 24.03.2019]
- Change ComponentLayout subclasses to use the Component struct as the argument in initializer [✅ 22.03.2019]
- Refactor Sourcery template to autogenerate the layout property of Components [✅ 01.03.2019]
- Create a UITableView subclass with identical functionality as the ComponentViewController
- Refine the README.md to fully explain what the architecture is and the best practices. [✅ 25.03.2019]

# Cyanic

Cyanic is an iOS framework created at Feil, Feil, & Feil GmbH (FFUF) in response to a need for state-driven UI. It borrows heavily
from the concepts of Airbnb's [MvRx](https://github.com/airbnb/MvRx) framework (which our Android developers use) to create a very similar
code base with Android thereby unifying the business logic in both platforms. We use this framework to create complex, performant, and reactive
screens in our projects.

Cyanic is a Swift only framework. There are no plans to make it compatible with Objective-C.

## Installation
### [CocoaPods](http://cocoapods.org/)

1. Add the following to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html):
    ```rb
    pod 'Cyanic'
    pod 'CommonWidgets', :git => 'https://github.com/feilfeilundfeil/CommonWidgets.git'
    pod 'LayoutKit', :git => 'https://github.com/hooliooo/LayoutKit.git'
    ```

2. Integrate your dependencies using frameworks: add `use_frameworks!` to your Podfile. 
3. Run `pod install`.

## Documentation

Check out our [wiki](https://github.com/feilfeilundfeil/Cyanic/wiki) for full documentation. 

## A Simple Example

** Under Construction **

## Contributors

* Julio Alorro (julio.alorro@ffuf.de)
* Jonas Bark (jonas.bark@ffuf.de)
