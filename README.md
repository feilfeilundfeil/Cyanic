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
FFUFComponents is an iOS framework created at Feil, Feil, & Feil GmbH (FFUF) in response to a need for state-driven UI. It borrows heavily
from the concepts of Airbnb's [MvRx](https://github.com/airbnb/MvRx) framework (which our Android developers use) to create a very similar
code base with Android thereby unifying the business logic in both platforms. We use this framework to create complex, performant, and reactive
screens in our projects.

FFUFComponents is a Swift only framework. There are no plans to make it compatible with Objective-C.

## Core Concepts
* * *
### State
* * *
State is a protocol that should be adopted by structs only to enforce value semantics on your screen State. It is fundamentally immutable
(even though its properties are declared as `var`, the State struct, when accessed, is immutable. Only the ViewModel that manages it, 
can mutate it).
 
### ViewModel
* * *
We understand that ViewModel can mean so many different things, but within this framework, ViewModels are State managers, which
in turn means they are business logic controllers. We kept the name ViewModel to keep the terminology similar with our Android developers
who use [MvRx](https://github.com/airbnb/MvRx). With that said, ViewModel is a generic class that manages a single State struct that is
initialized with an `initialState`. ViewModels have all the functionality necessary to manage its State and its State is accessible.

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

`setState` makes use of the `inout` keyword to pass the mutable State struct by reference and if the State's properties are declared as `var`, it
will be changed.

**Subscribing to State**
There are three ways to subscribe to State:

The `invalidate` method in `BaseStateListeningVC` and `BaseComponentVC` is called any their viewModel(s)' State changes. You
may get the current State in the method by doing the following:

```
override func invalidate() {
    withState(yourViewModel) { (currentState: YourState) -> Void in
        ... your logic here ...
    }
}

```
If you want a more granular scope, you may target properties from State specifically with the following:

**NOTE**: we recommend using type annotations here due to the fact that the compiler may not be able to infer types.

```
// Not so verbose
yourViewModel.selectSubscribe(to: \YourState.foo) { (foo: String) -> Void in 
    ... your logic here ...
}

// Verbose
yourViewModel.selectSubscribe(
    to: \YourState.foo, 
    onNewValue: { (foo: String) -> Void in 
        ... your logic here ...
    }
)

// Two properties
yourViewModel.selectSubscribe(
    keyPath1: \YourState.foo,
    keyPath2: \YourState.bar,
    onNewValue: { // will be called if both properties / either property change
        ... your logic here ...
    }
)

// Three properties
yourViewModel.selectSubscribe(
    keyPath1: \YourState.foo,
    keyPath2: \YourState.bar,
    keyPath3: \YourState.baz,
    onNewValue: { // will be called if any of the properties change
    ... your logic here ...
    }
)

// Subscribing to an Async property
yourViewModel.asyncSubscribe(
    to: \YourState.asyncProperty,
    onSuccess: {
        ... your logic here if successful ...
    },
    onFailure: {
        ... you logic here if failed ...
    }
)

```

### BaseStateListeningVC
* * *
BaseStateListeningVC is the base class for UIViewControllers that wish to use the Rx functionality of the framework. We tried to be as
flexible as possible and the only method with custom logic is **viewDidLoad** where we set up the RxSwift functionality for you 🙌

A very basic example:

```
class YourVC: BaseStateListeningVC {
    ... other things ...
    
    override var viewModels: [AnyViewModel] { // any viewModels here will have their state observed by YourVC.
        return [
            yourViewModel.asAnyViewModel,
            yourOtherViewModel.asAnyViewModel
        ]
    }
    
    override func invalidate() {
        ... your logic here for state changes ...
    }

}

```

**NOTE**: invalidate is called once when the BaseStateListeningVC's viewDidLoad is called then after that, on very State change.

## FFUFComponents on UICollectionView
* * *
### BaseComponentVC
- BaseComponentVC is the UIViewController that functions as both a UICollectionViewDataSource and UICollectionViewDelegateFlowLayout

### Component
- A data model representing content in one UICollectionViewCell displayed on the BaseComponentVC. It contains UI properties and closures/functions related to user interaction


