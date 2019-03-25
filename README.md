## TODO
- Create a BaseComponentVC subclasses that handle one, two, three ViewModels [✅ 11.03.2019] (Deprecated)
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
        withState(yourViewModel, yourOtherViewModel) { // Call this method if you want to read the States.
            ... your logic here for state changes ...
        }
    }

}

```

**NOTE**: `invalidate` is called once when the BaseStateListeningVC's `viewDidLoad` is called then after that, on very State change.

## FFUFComponents on UICollectionView
* * *
Set up for implementing the reactive UICollectionView provided by FFUFComponents is a little more complex than setting up 
BaseStateListeningVC. But we will continue to work hard on making it as simple as possible. The following literature breaks down each
unit in implementing BaseComponentVC correctly as well as some convenience with the help of [Sourcery](https://github.com/krzysztofzablocki/Sourcery) 🌈. 

### ComponentCell
* * *
ComponentCell is a UICollectionViewCell that leverages the power of [LayoutKit](https://github.com/linkedin/LayoutKit). It simply calls the 
necessary logic to be performant on the main thread. You probably won't need to subclass this.

### ComponentLayout
* * *
ComponentLayout is an protocol that conforms to Layout from [LayoutKit](https://github.com/linkedin/LayoutKit). Any custom layout you define
must conform to this to be usable by a Component. Please read up on how to use LayoutKit [here](https://layoutkit.org). It's super easy to
pick up, more performant than AutoLayout, and calculations can be done in a background thread. 

The ComponentLayout defines what subviews are displayed on the ComponentCell. It sizes and places those subviews, and it styles
those subviews based on the Component's properties.

### Component
* * *
A Component is the UI specific data model that defines the characteristics of the content to be displayed on the ComponentCell. Components
are created in the `buildComponents` method of BaseComponentVC.
    Some requirements when creating custom Components:
        * Must have a unique `id`
        * Must be `Hashable` (for the diffing aspect of the framework). The Component protocol already conforms to Hashable.

### BaseComponentVC
* * *
BaseComponentVC is a subclass of BaseStateListeningVC that has additional set up code so that it is geared towards managing
a UICollectionView. In addition to calling `invalidate` when its viewModels' States change, it will also call another method called
`buildComponents` which recreates the UICollectionView's data source and is diffed by [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources) diffing algorithm. Components are created inside the `buildComponents` method where State(s) from the ViewModel(s) can
be read.

```
class YourComponentVC: BaseComponentVC {

    ... other stuff ...
    
    override var viewModels: [AnyViewModel] {
        return [
            yourViewModel
        ]
    }

    override func buildComponents(_ componentsController: inout ComponentsController) { 
    // This is called in a background thread 
        withState(yourViewModel) { (currentState: YourState) -> Void in
            componentsController.staticTextComponent {
                $0.id = "First static component"
                $0.text = Text.unattributed("Hello, World")
            }
            
            componentsController.buttonComponent {
                let id: String = "Button"
                $0.id = id
                $0.title = Text.unattributed(id)
                $0.height = 44.0
                $0.onTap = { print("Hello World, \(id)") }
            }
            
            if currentState.baz { // YourState.baz is a Bool
                componentsController.staticTextComponent { // This will only show when state.baz == true
                    $0.id = "Super secret text"
                    $0.text = Text.unattributed("Hello, World. I'm only shown sometimes")
                }
            }
            
        }
    }
}

```

