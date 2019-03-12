# FFUFComponents
* * *

## TODO
- Create a BaseComponentVC subclasses that handle one, two, three ViewModels [✅ 11.03.2019]
- Update the documentation of each file [✅  05.03.2019]
- Refactor Components into structs [✅ 01.03.2019]
- Create Stencil templates for said structs to generate default values for properties [✅ 01.03.2019 but could still be refined]
- Create the "Copyable" protocol and have these structs conform to it [✅ 01.03.2019]
    - Copyable protocol allows structs to be mutated (copied) in place
- Create the Stencil template containing the logic to generate extensions for BaseComponentsVC
- Create a UITableView subclass with identical functionality as the BaseComponentsVC
- Create a Run Script Phase in the FFUFComponents target  that refereshes the AutoEquatable and AutoHashables of the basic Components  that come with this framework
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


