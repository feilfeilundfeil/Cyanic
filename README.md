FFUFComponents
======================================

## Architecture

- When building a component based screen. The following is a general view of how the architecture should be created:

    - BaseCollectionVC
        - [AnyComponents] array
            - YourComponents wrapped in an AnyComponent class
                - identity => the state of your component
                - cellType => the ConfigurableCell.Type used as the root UIView for the Component
                - layout => the Layout, which contains information on what subviews are created and their defined size, location, and appearance (data binding). May contain user input related observables which are relayed to the Component, the Component then writes it to the identity.
                - viewModel => the ViewModel, which acts as a wrapper around the model to be presented. Only exposes the data needed from the model. May contain read related observables on the model

