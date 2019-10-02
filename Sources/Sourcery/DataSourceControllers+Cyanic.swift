// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable all
public extension ComponentsController {

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
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }
        self.add(mutableComponent)
        return mutableComponent
    }

    /**
        Generates a ChildVCComponent instance and configures its properties with the given closure. You must provide a
        unique id in the configuration block, otherwise it will force a fatalError.
        - Parameters:
            - configuration: The closure that mutates the mutable ChildVCComponent.
            - mutableComponent: The ChildVCComponent instance to be mutated/configured.
        - Returns:
            ChildVCComponent
    */
    @discardableResult
    mutating func childVCComponent(configuration: (_ mutableComponent: inout ChildVCComponent) -> Void) -> ChildVCComponent {
        var mutableComponent: ChildVCComponent = ChildVCComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }
        guard ComponentStateValidator.validateChildVCComponent(mutableComponent)
            else { fatalError("You did not configure all required variables in this component") }
        self.add(mutableComponent)
        return mutableComponent
    }

    /**
        Generates a ExpandableComponent instance and configures its properties with the given closure. You must provide a
        unique id in the configuration block, otherwise it will force a fatalError.
        - Parameters:
            - configuration: The closure that mutates the mutable ExpandableComponent.
            - mutableComponent: The ExpandableComponent instance to be mutated/configured.
        - Returns:
            ExpandableComponent
    */
    @discardableResult
    mutating func expandableComponent(configuration: (_ mutableComponent: inout ExpandableComponent) -> Void) -> ExpandableComponent {
        var mutableComponent: ExpandableComponent = ExpandableComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }
        guard ComponentStateValidator.validateExpandableComponent(mutableComponent)
            else { fatalError("You did not configure all required variables in this component") }
        self.add(mutableComponent)
        return mutableComponent
    }

    /**
        Generates a SizedComponent instance and configures its properties with the given closure. You must provide a
        unique id in the configuration block, otherwise it will force a fatalError.
        - Parameters:
            - configuration: The closure that mutates the mutable SizedComponent.
            - mutableComponent: The SizedComponent instance to be mutated/configured.
        - Returns:
            SizedComponent
    */
    @discardableResult
    mutating func sizedComponent(configuration: (_ mutableComponent: inout SizedComponent) -> Void) -> SizedComponent {
        var mutableComponent: SizedComponent = SizedComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }
        self.add(mutableComponent)
        return mutableComponent
    }

    /**
        Generates a StaticLabelComponent instance and configures its properties with the given closure. You must provide a
        unique id in the configuration block, otherwise it will force a fatalError.
        - Parameters:
            - configuration: The closure that mutates the mutable StaticLabelComponent.
            - mutableComponent: The StaticLabelComponent instance to be mutated/configured.
        - Returns:
            StaticLabelComponent
    */
    @discardableResult
    mutating func staticLabelComponent(configuration: (_ mutableComponent: inout StaticLabelComponent) -> Void) -> StaticLabelComponent {
        var mutableComponent: StaticLabelComponent = StaticLabelComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
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
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
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
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }
        self.add(mutableComponent)
        return mutableComponent
    }

    /**
        Generates a TextFieldComponent instance and configures its properties with the given closure. You must provide a
        unique id in the configuration block, otherwise it will force a fatalError.
        - Parameters:
            - configuration: The closure that mutates the mutable TextFieldComponent.
            - mutableComponent: The TextFieldComponent instance to be mutated/configured.
        - Returns:
            TextFieldComponent
    */
    @discardableResult
    mutating func textFieldComponent(configuration: (_ mutableComponent: inout TextFieldComponent) -> Void) -> TextFieldComponent {
        var mutableComponent: TextFieldComponent = TextFieldComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }
        self.add(mutableComponent)
        return mutableComponent
    }

    /**
        Generates a TextViewComponent instance and configures its properties with the given closure. You must provide a
        unique id in the configuration block, otherwise it will force a fatalError.
        - Parameters:
            - configuration: The closure that mutates the mutable TextViewComponent.
            - mutableComponent: The TextViewComponent instance to be mutated/configured.
        - Returns:
            TextViewComponent
    */
    @discardableResult
    mutating func textViewComponent(configuration: (_ mutableComponent: inout TextViewComponent) -> Void) -> TextViewComponent {
        var mutableComponent: TextViewComponent = TextViewComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }
        self.add(mutableComponent)
        return mutableComponent
    }
}

public extension SectionController {

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
    mutating func buttonComponent(for supplementaryView: SectionController.SupplementaryView, configuration: (_ mutableComponent: inout ButtonComponent) -> Void) -> ButtonComponent {
        var mutableComponent: ButtonComponent = ButtonComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }

        switch supplementaryView {
            case .header:
                self.headerComponent = mutableComponent.asAnyComponent
            case .footer:
                self.footerComponent = mutableComponent.asAnyComponent
        }

        return mutableComponent
    }

    /**
        Generates a ChildVCComponent instance and configures its properties with the given closure. You must provide a
        unique id in the configuration block, otherwise it will force a fatalError.
        - Parameters:
            - configuration: The closure that mutates the mutable ChildVCComponent.
            - mutableComponent: The ChildVCComponent instance to be mutated/configured.
        - Returns:
            ChildVCComponent
    */
    @discardableResult
    mutating func childVCComponent(for supplementaryView: SectionController.SupplementaryView, configuration: (_ mutableComponent: inout ChildVCComponent) -> Void) -> ChildVCComponent {
        var mutableComponent: ChildVCComponent = ChildVCComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }
        guard ComponentStateValidator.validateChildVCComponent(mutableComponent)
            else { fatalError("You did not configure all required variables in this component") }

        switch supplementaryView {
            case .header:
                self.headerComponent = mutableComponent.asAnyComponent
            case .footer:
                self.footerComponent = mutableComponent.asAnyComponent
        }

        return mutableComponent
    }

    /**
        Generates a ExpandableComponent instance and configures its properties with the given closure. You must provide a
        unique id in the configuration block, otherwise it will force a fatalError.
        - Parameters:
            - configuration: The closure that mutates the mutable ExpandableComponent.
            - mutableComponent: The ExpandableComponent instance to be mutated/configured.
        - Returns:
            ExpandableComponent
    */
    @discardableResult
    mutating func expandableComponent(for supplementaryView: SectionController.SupplementaryView, configuration: (_ mutableComponent: inout ExpandableComponent) -> Void) -> ExpandableComponent {
        var mutableComponent: ExpandableComponent = ExpandableComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }
        guard ComponentStateValidator.validateExpandableComponent(mutableComponent)
            else { fatalError("You did not configure all required variables in this component") }

        switch supplementaryView {
            case .header:
                self.headerComponent = mutableComponent.asAnyComponent
            case .footer:
                self.footerComponent = mutableComponent.asAnyComponent
        }

        return mutableComponent
    }

    /**
        Generates a SizedComponent instance and configures its properties with the given closure. You must provide a
        unique id in the configuration block, otherwise it will force a fatalError.
        - Parameters:
            - configuration: The closure that mutates the mutable SizedComponent.
            - mutableComponent: The SizedComponent instance to be mutated/configured.
        - Returns:
            SizedComponent
    */
    @discardableResult
    mutating func sizedComponent(for supplementaryView: SectionController.SupplementaryView, configuration: (_ mutableComponent: inout SizedComponent) -> Void) -> SizedComponent {
        var mutableComponent: SizedComponent = SizedComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }

        switch supplementaryView {
            case .header:
                self.headerComponent = mutableComponent.asAnyComponent
            case .footer:
                self.footerComponent = mutableComponent.asAnyComponent
        }

        return mutableComponent
    }

    /**
        Generates a StaticLabelComponent instance and configures its properties with the given closure. You must provide a
        unique id in the configuration block, otherwise it will force a fatalError.
        - Parameters:
            - configuration: The closure that mutates the mutable StaticLabelComponent.
            - mutableComponent: The StaticLabelComponent instance to be mutated/configured.
        - Returns:
            StaticLabelComponent
    */
    @discardableResult
    mutating func staticLabelComponent(for supplementaryView: SectionController.SupplementaryView, configuration: (_ mutableComponent: inout StaticLabelComponent) -> Void) -> StaticLabelComponent {
        var mutableComponent: StaticLabelComponent = StaticLabelComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }

        switch supplementaryView {
            case .header:
                self.headerComponent = mutableComponent.asAnyComponent
            case .footer:
                self.footerComponent = mutableComponent.asAnyComponent
        }

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
    mutating func staticSpacingComponent(for supplementaryView: SectionController.SupplementaryView, configuration: (_ mutableComponent: inout StaticSpacingComponent) -> Void) -> StaticSpacingComponent {
        var mutableComponent: StaticSpacingComponent = StaticSpacingComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }

        switch supplementaryView {
            case .header:
                self.headerComponent = mutableComponent.asAnyComponent
            case .footer:
                self.footerComponent = mutableComponent.asAnyComponent
        }

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
    mutating func staticTextComponent(for supplementaryView: SectionController.SupplementaryView, configuration: (_ mutableComponent: inout StaticTextComponent) -> Void) -> StaticTextComponent {
        var mutableComponent: StaticTextComponent = StaticTextComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }

        switch supplementaryView {
            case .header:
                self.headerComponent = mutableComponent.asAnyComponent
            case .footer:
                self.footerComponent = mutableComponent.asAnyComponent
        }

        return mutableComponent
    }

    /**
        Generates a TextFieldComponent instance and configures its properties with the given closure. You must provide a
        unique id in the configuration block, otherwise it will force a fatalError.
        - Parameters:
            - configuration: The closure that mutates the mutable TextFieldComponent.
            - mutableComponent: The TextFieldComponent instance to be mutated/configured.
        - Returns:
            TextFieldComponent
    */
    @discardableResult
    mutating func textFieldComponent(for supplementaryView: SectionController.SupplementaryView, configuration: (_ mutableComponent: inout TextFieldComponent) -> Void) -> TextFieldComponent {
        var mutableComponent: TextFieldComponent = TextFieldComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }

        switch supplementaryView {
            case .header:
                self.headerComponent = mutableComponent.asAnyComponent
            case .footer:
                self.footerComponent = mutableComponent.asAnyComponent
        }

        return mutableComponent
    }

    /**
        Generates a TextViewComponent instance and configures its properties with the given closure. You must provide a
        unique id in the configuration block, otherwise it will force a fatalError.
        - Parameters:
            - configuration: The closure that mutates the mutable TextViewComponent.
            - mutableComponent: The TextViewComponent instance to be mutated/configured.
        - Returns:
            TextViewComponent
    */
    @discardableResult
    mutating func textViewComponent(for supplementaryView: SectionController.SupplementaryView, configuration: (_ mutableComponent: inout TextViewComponent) -> Void) -> TextViewComponent {
        var mutableComponent: TextViewComponent = TextViewComponent(id: Constants.invalidID)
        configuration(&mutableComponent)
        guard ComponentStateValidator.hasValidIdentifier(mutableComponent)
            else { fatalError("You must have a unique identifier for this component") }

        switch supplementaryView {
            case .header:
                self.headerComponent = mutableComponent.asAnyComponent
            case .footer:
                self.footerComponent = mutableComponent.asAnyComponent
        }

        return mutableComponent
    }
}
// swiftlint:enable all
