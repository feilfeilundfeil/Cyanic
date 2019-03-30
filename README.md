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
* * *
Cyanic is an iOS framework created at Feil, Feil, & Feil GmbH (FFUF) in response to a need for state-driven UI. It borrows heavily
from the concepts of Airbnb's [MvRx](https://github.com/airbnb/MvRx) framework (which our Android developers use) to create a very similar
code base with Android thereby unifying the business logic in both platforms. We use this framework to create complex, performant, and reactive
screens in our projects.

Cyanic is a Swift only framework. There are no plans to make it compatible with Objective-C.

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

The `invalidate` method in `CyanicViewController` and `ComponentViewController` is called any their viewModel(s)' State changes. You
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

## Core Concepts of implementing a UICollectionView powered by Cyanic
* * *
Set up for implementing the reactive UICollectionView provided by Cyanic is exteremly simple! All you have to do is define a `.sourcery.yml` and input the
following configuration (assuming you're in the root directory of your project):
```
sources:
    - Pods/Cyanic/Sources/Protocols
templates:
    - Pods/Cyanic/Templates
output:
    YOUR_PROJECT/PATH_TO_DIRECTORY_FOR_GENERATED_FILES
args:
    "project": "YOUR_PROJECT_NAME"
```

This will allow you to use our built-in [Sourcery](https://github.com/krzysztofzablocki/Sourcery) 🌈 templates and generate your files
whenever you run `Pods/Sourcery/bin/sourcery` in your terminal.

### ComponentCell
* * *
ComponentCell is a UICollectionViewCell subclass that leverages the power of [LayoutKit](https://github.com/linkedin/LayoutKit). It simply calls the
takes a ComponentLayout, tells it to perform size and arrangement calculations in a background thread then tells it to make the subviews in its `contentView` on the
main thread asynchronously. You probably won't need to subclass this.

### ComponentLayout
* * *
ComponentLayout is an protocol that conforms to Layout from [LayoutKit](https://github.com/linkedin/LayoutKit). Any custom layout you define
must conform to this protocol to be usable by a Component. Please read up on how to use LayoutKit [here](https://layoutkit.org). It's super easy to
pick up, more performant than AutoLayout, and size calculations can be done in a background thread. 

The ComponentLayout defines what subviews are displayed on the ComponentCell. It sizes and arranges those subviews within a root UIView
(in our case, the `contentView` of ComponentCell), and it styles those subviews based on the Component's properties. It also defines the size of the `contentView`
in the ComponentCell.

### Component
* * *
A Component is the UI specific data model that defines the characteristics of the content to be displayed on the ComponentCell. Components
are created in the `buildComponents` method of ComponentViewController and added to the mutable `ComponentsController`.

Some requirements when creating custom Components:
* Must have a unique `id`.
* Must be `Hashable` (for the diffing aspect of the framework). The Component protocol already conforms to Hashable.

### ComponentViewController
* * *
ComponentViewController is a subclass of CyanicViewController that has additional set up code so that it is geared towards managing
a UICollectionView. In addition to calling `invalidate` when its viewModels' States change, it will also call another method called
`buildComponents` which recreates the UICollectionView's data source and is diffed by [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources) diffing algorithm. Components are created inside the `buildComponents` method where State(s) from the ViewModel(s) can
be read.

Some additional functionality:
* Reads each Component's ComponentLayout and sizes each cell accordingly.
* If the Component adopts `Selectable`, ComponentViewControllers will call `onSelect` when `collectionView(collectionView:didSelectItemAt:)`  is called.

A super simple example.

```
class YourComponentVC: ComponentViewController {

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
## Other Core Concepts
* * *
### CyanicViewController
* * *
CyanicViewController is the base class for UIViewControllers that wish to use the Rx functionality of the framework. We tried to be as
flexible as possible and the only method with custom logic is **viewDidLoad** where we set up the RxSwift functionality for you 🙌

A very basic example:

```
class YourVC: CyanicViewController {
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

**NOTE**: `invalidate` is called once when the CyanicViewController's `viewDidLoad` is called then after that, on every State change.

### Using [Sourcery](https://github.com/krzysztofzablocki/Sourcery) 🌈 to automatically generate your Components
* * *
Here at FFUF, we use Sourcery to generate our Components and ComponentsController extensions! So we can automate a lot of the
boring Component creation process including the Equatable/Hashable implementations. We achieve this by making use of annotations.

These are the templates we use:

* [AutoEquatableComponent.stencil](https://bitbucket.org/FFUF/ffuf-ios-components/src/master/Templates/AutoEquatableComponent.stencil)

* [AutoHashableComponent.stencil](https://bitbucket.org/FFUF/ffuf-ios-components/src/master/Templates/AutoHashableComponent.stencil)

* [AutoGenerateComponent.stencil](https://bitbucket.org/FFUF/ffuf-ios-components/src/master/Templates/AutoGenerateComponent.stencil)

* [AutoGenerateComponentExtensions.swifttemplate](https://bitbucket.org/FFUF/ffuf-ios-components/src/master/Templates/AutoGenerateComponentExtensions.swifttemplate)

We generally use the following process:

**Step One:** 

Create a protocol that conforms to Component (in this case we use StaticHeightComponent. StaticHeightComponent is a protocol that 
conforms to Component and has an additional property called height.) 
Annotate it with AutoEquatable, AutoHashable, and Component.  (These will be read by Sourcery)

In this example, we are creating defaultValue for `foo`, we're opting out of Equatable and Hashable for `nonHashableProperty`, and we exclude
`description` from code generation.
```
// sourcery: AutoEquatable,AutoHashable
// sourcery: Component = YourComponent
protocol YourComponentType: StaticHeightComponent, CustomStringConvertible {
    
    // sourcery: defaultValue = UIColor.clear
    var backgroundColor: UIColor { get set }
    
    // sourcery: defaultValue = ""Hello World!""
    var foo: String { get set }
    
    // sourcery: skipHashing, skipEquality
    // sourcery: defaultValue = ""This" as Any"
    var nonHashableProperty: Any { get set }
    
}

extension YourComponentType { // You can also define other protocols
    
    // sourcery: isExcluded
    var description: String {
        return "Hello World"
    }

}
```

**Step Two:** 

Create the struct that conforms to `YourComponentType`. Annotate it with AutoGenerateComponent, AutoGenerateComponentExtension, and
ComponentLayout.

```
// sourcery: AutoGenerateComponent,AutoGenerateComponentExtension
// sourcery: ComponentLayout = YourComponentLayout
struct YourComponent: YourComponentType {
}
```

**Step Three:** 

Create the custom ComponentLayout and implement your view logic inside the initializer

```
class YourComponentLayout: SizeLayout<UIView>, ComponentLayout {

    init(component: YourComponent) {
        ... implement your sizing, arrangement and view binding logic in the intializer ...
        ... You can look at how the ButtonComponentLayout was implemented for an example ...
    }

}
```
**Step Four:** 

In your terminal, navigate to the root directory of your project and run `Pods/Sourcery/bin/sourcery`. Assuming no error occurred,
Sourcery will generate the following:

In `YourComponent.swift`
```
// sourcery: AutoGenerateComponent,AutoGenerateComponentExtension
// sourcery: ComponentLayout = YourComponentLayout
struct YourComponent: YourComponentType {

// sourcery:inline:auto:YourComponent.AutoGenerateComponent
    /**
    Work around Initializer because memberwise initializers are all or nothing
    - Parameters:
    - id: The unique identifier of the YourComponent.
    */
    internal init(id: String) {
    self.id = id
    }

    internal var id: String

    internal var width: CGFloat = 0.0

    internal var height: CGFloat = 44.0

    // sourcery: skipHashing, skipEquality 
    internal var layout: ComponentLayout { return YourComponentLayout(component: self) }

    internal var backgroundColor: UIColor = UIColor.clear

    internal var foo: String = "Hello World!"

    // sourcery: skipHashing, skipEquality 
    internal var nonHashableProperty: Any = "This" as Any

    internal var identity: YourComponent { return self }
// sourcery:end
}
```

In your `AutoEquatable.generated.swift` file (generated in your directory, you may have to drag it into your workspace if it doesn't exist there)
```
... other stuff ...
// MARK: - YourComponent AutoEquatable
extension YourComponent: Equatable {}
public func == (lhs: YourComponent, rhs: YourComponent) -> Bool {
    guard lhs.backgroundColor == rhs.backgroundColor else { return false }
    guard lhs.foo == rhs.foo else { return false }
    guard lhs.description == rhs.description else { return false }
    guard lhs.id == rhs.id else { return false }
    guard lhs.width == rhs.width else { return false }
    guard lhs.height == rhs.height else { return false }
    return true
}
```
In your `AutoHashable.generated.swift` file: (generated in your directory, you may have to drag it into your workspace if it doesn't exist there)
```
... other stuff ...

// MARK: - YourComponentType AutoHashable
extension YourComponent: Hashable {
    internal func hash(into hasher: inout Hasher) {
        self.backgroundColor.hash(into: &hasher)
        self.foo.hash(into: &hasher)
        self.description.hash(into: &hasher)
        self.id.hash(into: &hasher)
        self.width.hash(into: &hasher)
        self.height.hash(into: &hasher)
    }
}
```

In your `AutoGenerateComponentExtensions.generated.swift` file: (generated in your directory, you may have to drag it into your workspace if it doesn't exist there)

```
public extension ComponentsController {
    
    ... other stuff ...
    
    /**
     Generates a YourComponent instance and configures its properties with the given closure. You must provide a
     unique id in the configuration block, otherwise it will force a fatalError.
     - Parameters:
         - configuration: The closure that mutates the mutable YourComponent.
         - mutableComponent: The YourComponent instance to be mutated/configured.
     - Returns:
         YourComponent
    */
    @discardableResult
    mutating func yourComponent(configuration: (_ mutableComponent: inout YourComponent) -> Void) -> YourComponent {
        var mutableComponent: YourComponent = YourComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        mutableComponent.width = self.width
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }
        self.add(mutableComponent)
        return mutableComponent
    }  
    
    ... other stuff ...

}
```

[Sourcery](https://github.com/krzysztofzablocki/Sourcery) 🌈 helps greatly with the boilerplate code when creating custom Components but is completely optional. You can even define your own templates!

### Cyanic-specific Sourcery annotations
* * *
* **isExcluded**: will be excluded out of the auto generation of properties from the `AutoGenerateComponent` template.
* **defaultValue**: specifies the defaultValue of the property for code generation via the `AutoGenerateComponent` template.
* **isWeak**: specifies that the property will be labeled `weak` for code generation via the `AutoGenerateComponent` template.
* **isLazy**: specifies that the property will be labeled `lazy` for code generation via the `AutoGenerateComponent` template.
* **isLayout**: specifies that the property is the `ComponentLayout` for code generation via the `AutoGenerateComponent` template.
* **Component**: specifies the type name of the Component whose properties will be Equatable and Hashable via the `AutoEquatableComponent` and 
`AutoHashableComponent` template.
* **RequiredVariables**: specifies that the Component has additional required variables that must be mutabled to be considered valid. Used by the `AutoGenerateComponentExtensions` swifttemplate.
* **AutoGenerateComponent**: specifies that the custom Component will have generated properties via its custom ComponentType protocol
* **AutoEquatableComponent**: specifies that the custom Component will have a generated implementation of Equatable.
* **AutoHashableComponent**: specifies that the custom Component will have a generated implementation of Hashable.
* **AutoGenerateComponentExtensions**: specifies that the custom Component will have a generated implementation of a factory method as an extension to `ComponentsController`.

