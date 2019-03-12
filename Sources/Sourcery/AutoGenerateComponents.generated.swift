// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

public extension ComponentsArray {

    /**
      Generates a ButtonComponent instance and configures its properties with the given closure. You must provide a
      unique id in the configuration block, otherwise it will force a fatalError.
      - Parameters:
        - configuration: The closure that mutates the mutable ButtonComponent.
        - mutableComponent: The ButtonComponent instance to be mutated/configured.
      - Returns:
        ButtonComponent
    */
    @discardableResult
    mutating func buttonComponent(configuration: (_ mutableComponent: inout ButtonComponent) -> Void) -> ButtonComponent {
        var mutableComponent: ButtonComponent = ButtonComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard self.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }
        self.add(mutableComponent)
        return mutableComponent
    }

    /**
      Generates a StaticSpacingComponent instance and configures its properties with the given closure. You must provide a
      unique id in the configuration block, otherwise it will force a fatalError.
      - Parameters:
        - configuration: The closure that mutates the mutable StaticSpacingComponent.
        - mutableComponent: The StaticSpacingComponent instance to be mutated/configured.
      - Returns:
        StaticSpacingComponent
    */
    @discardableResult
    mutating func staticSpacingComponent(configuration: (_ mutableComponent: inout StaticSpacingComponent) -> Void) -> StaticSpacingComponent {
        var mutableComponent: StaticSpacingComponent = StaticSpacingComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard self.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }
        self.add(mutableComponent)
        return mutableComponent
    }

    /**
      Generates a StaticTextComponent instance and configures its properties with the given closure. You must provide a
      unique id in the configuration block, otherwise it will force a fatalError.
      - Parameters:
        - configuration: The closure that mutates the mutable StaticTextComponent.
        - mutableComponent: The StaticTextComponent instance to be mutated/configured.
      - Returns:
        StaticTextComponent
    */
    @discardableResult
    mutating func staticTextComponent(configuration: (_ mutableComponent: inout StaticTextComponent) -> Void) -> StaticTextComponent {
        var mutableComponent: StaticTextComponent = StaticTextComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard self.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }
        self.add(mutableComponent)
        return mutableComponent
    }
}
