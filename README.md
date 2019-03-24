# FFUFComponents
* * *

## TODO
- Create a BaseComponentVC subclasses that handle one, two, three ViewModels [✅ 11.03.2019]
- Update the documentation of each file [✅  05.03.2019]
- Refactor Components into structs [✅ 01.03.2019]
- Create Stencil templates for said structs to generate default values for properties [✅ 01.03.2019]
- Create the "Copyable" protocol and have these structs conform to it [✅ 01.03.2019]
    - Copyable protocol allows structs to be mutated (copied) in place
- Create the Sourcery template containing the logic to generate extensions for ComponentsArray [✅ 13.03.2019]
- Create unit tests for BaseViewModel [✅ 17.03.2019]
- Create unit tests for StateStore [✅ 22.03.2019]
- Create unit tests for BaseComponentVC and BaseStateListeningVC [✅ 24.03.2019]
- Change ComponentLayout subclasses to use the Component struct as the argument in initializer [✅ 22.03.2019]
- Refactor Sourcery template to autogenerate the layout property of Components [✅ 01.03.2019]
- Create a UITableView subclass with identical functionality as the BaseComponentsVC
- Refine the README.md to fully explain what the architecture is and the best practices.

## Architecture
* * *
## Core Concepts

### State
- State is a struct that contains properties related to rendering your screen
 
### ViewModel
- ViewModel contains the business logic necessary to render your screen. ViewModels own state and its state can be observed
    
### BaseComponentVC
- BaseComponentVC is the UIViewController that functions as both a UICollectionViewDataSource and UICollectionViewDelegateFlowLayout

### Component
- A data model representing content in one UICollectionViewCell displayed on the BaseComponentVC. It contains UI properties and closures/functions related to user interaction


