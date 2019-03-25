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

# FFUFComponents
* * *
FFUFComponents is an iOS framework from Feil, Feil, & Feil GmbH that was created in response to a need for state-driven UI. It borrows heavily
from the concepts of Airbnb's [MvRx](https://github.com/airbnb/MvRx) framework (which our Android developers use) to create a very similar
code base with Android thereby unifying the business logic in both platforms. We use this framework to create complex, performant, and reactive
screens in our project.

FFUFComponents is a Swift only framework.

## Core Concepts
* * *
### State
* * *
State is a protocol that should be adopted by structs only to enforce value semantics on your screen State. It is fundamentally immutable
(even though its properties are declared as `var`, the State struct, when accessed, is immutable. Only the ViewModel that manages it, 
can mutate it).
 
### ViewModel
* * *
We understand that ViewModel can mean so many different things. But within this framework, ViewModels are State managers which
in turn means they are business logic controllers. We kept the name ViewModel to keep the terminology similar with our Android developers
who use [MvRx](https://github.com/airbnb/MvRx). With that said, ViewModel is a generic class that manages a single State struct that is
initialized with an `initialState`. ViewModel all the functionality necessary to manage its State and its State is accessible.

**Accessing ViewModel's State**
A ViewModel's State can be accessed with the following methods:

*ViewModel's `setState` method*   

```
yourViewModel.withState { (state: YourState) -> Void in
    ... your logic here ...
}
```
It is run asynchronously on a background thread. All setState closures are run before any withState closures to ensure you have the latest
State in all your reads. For example:

```
// state.foo == "Hi"

yourViewModel.withState { (state: YourState) -> Void in
    print(state.foo) 
}

yourViewModel.setState { (state: inout YourState) -> Void in
    state.foo = "Hello, World!"
}

yourViewModel.withState { (state: YourState) -> Void in
    print(state.foo)
}
// "Hello, World!"
// "Hello, World!"
```
*Global `withState` function*
```
withState(yourViewModel) { (state: YourState) -> Void in
    ... your logic here ...
}
```
Unlike the ViewModel's `withState` method, this one is run synchronously on the current thread.

You can also access multiple States using the other global `withState` overloads:
```
withState(yourViewModel, yourOtherViewModel) { ... }

withState(yourViewModel, yourOtherViewModel, yourThirdViewModel) { ... }

withState(yourViewModel, yourOtherViewModel, yourThirdViewModel, yourFourthViewModel) { ... }
```

**Mutating State**
The ViewModel is the only object capable of mutating its State by calling its `setState` method.  The following mutates the underlying
State in a background thread:

```
yourViewModel.setState { (currentState: inout YourState) -> Void in
    ... your mutation logic here ...
}
```

`setState` makes use of the `inout` keyword to pass the State struct by reference and if the State's properties are declared as `var`, it
will be changed.

**Subscribing to State**
There are three ways to subscribe to State.


### BaseComponentVC
- BaseComponentVC is the UIViewController that functions as both a UICollectionViewDataSource and UICollectionViewDelegateFlowLayout

### Component
- A data model representing content in one UICollectionViewCell displayed on the BaseComponentVC. It contains UI properties and closures/functions related to user interaction


