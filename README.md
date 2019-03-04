FFUFComponents
======================================

## TODO
- Create a Composite ViewModel that is able to manage other ViewModels (who have their own state)
- Update the documentation of each file
- Refactor Components into structs [✅ 01.03.2019]
- Create Stencil templates for said structs to generate default values for properties [✅ 01.03.2019 but could still be refined]
- Create the "Changeable" protocol and have these structs conform to it [✅ 01.03.2019]
    - Changeable protocol allows structs to be mutated (copied) in place
- Create the Stencil template containing the logic to generate extensions for BaseComponentsVC
- Create a UITableView subclass with identical functionality as the BaseComponentsVC
- Create a Run Script Phase in the FFUFComponents target  that refereshes the AutoEquatable and AutoHashables of the basic Components  that come with this framework
- Refine the README.md to fully explain what the architecture is and the best practices.

## Architecture

- When building a component based screen. The following is a general view of how the architecture should be created:

    - ViewModel
    - State
    - BaseComponentVC

