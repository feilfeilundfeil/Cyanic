// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable all
fileprivate func compareOptionals<T>(lhs: T?, rhs: T?, compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    switch (lhs, rhs) {
        case let (lValue?, rValue?):
            return compare(lValue, rValue)
        case (nil, nil):
            return true
        default:
            return false
    }
}

fileprivate func compareArrays<T>(lhs: [T], rhs: [T], compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (idx, lhsItem) in lhs.enumerated() {
        guard compare(lhsItem, rhs[idx]) else { return false }
    }

    return true
}

// MARK: - AutoEquatableComponent
// MARK: - ButtonComponent AutoEquatableComponent
extension ButtonComponent: Equatable {}
public func == (lhs: ButtonComponent, rhs: ButtonComponent) -> Bool {
    guard lhs.type == rhs.type else { return false }
    guard lhs.title == rhs.title else { return false }
    guard lhs.font == rhs.font else { return false }
    guard lhs.backgroundColor == rhs.backgroundColor else { return false }
    guard lhs.id == rhs.id else { return false }
    guard lhs.width == rhs.width else { return false }
    guard lhs.height == rhs.height else { return false }
    return true
}
// MARK: - ChildVCComponent AutoEquatableComponent
extension ChildVCComponent: Equatable {}
public func == (lhs: ChildVCComponent, rhs: ChildVCComponent) -> Bool {
    guard lhs.name == rhs.name else { return false }
    guard lhs.description == rhs.description else { return false }
    guard lhs.id == rhs.id else { return false }
    guard lhs.width == rhs.width else { return false }
    guard lhs.height == rhs.height else { return false }
    return true
}
// MARK: - ExpandableComponent AutoEquatableComponent
extension ExpandableComponent: Equatable {}
public func == (lhs: ExpandableComponent, rhs: ExpandableComponent) -> Bool {
    guard lhs.contentLayout == rhs.contentLayout else { return false }
    guard lhs.backgroundColor == rhs.backgroundColor else { return false }
    guard lhs.accessoryViewSize == rhs.accessoryViewSize else { return false }
    guard lhs.isExpanded == rhs.isExpanded else { return false }
    guard lhs.id == rhs.id else { return false }
    guard lhs.width == rhs.width else { return false }
    guard lhs.height == rhs.height else { return false }
    return true
}
// MARK: - SizedComponent AutoEquatableComponent
extension SizedComponent: Equatable {}
public func == (lhs: SizedComponent, rhs: SizedComponent) -> Bool {
    guard lhs.backgroundColor == rhs.backgroundColor else { return false }
    guard lhs.id == rhs.id else { return false }
    guard lhs.width == rhs.width else { return false }
    guard lhs.height == rhs.height else { return false }
    return true
}
// MARK: - StaticLabelComponent AutoEquatableComponent
extension StaticLabelComponent: Equatable {}
public func == (lhs: StaticLabelComponent, rhs: StaticLabelComponent) -> Bool {
    guard lhs.text == rhs.text else { return false }
    guard lhs.font == rhs.font else { return false }
    guard lhs.backgroundColor == rhs.backgroundColor else { return false }
    guard lhs.numberOfLines == rhs.numberOfLines else { return false }
    guard lhs.lineBreakMode == rhs.lineBreakMode else { return false }
    guard lhs.id == rhs.id else { return false }
    guard lhs.width == rhs.width else { return false }
    return true
}
// MARK: - StaticSpacingComponent AutoEquatableComponent
extension StaticSpacingComponent: Equatable {}
public func == (lhs: StaticSpacingComponent, rhs: StaticSpacingComponent) -> Bool {
    guard lhs.backgroundColor == rhs.backgroundColor else { return false }
    guard lhs.id == rhs.id else { return false }
    guard lhs.width == rhs.width else { return false }
    guard lhs.height == rhs.height else { return false }
    return true
}
// MARK: - StaticTextComponent AutoEquatableComponent
extension StaticTextComponent: Equatable {}
public func == (lhs: StaticTextComponent, rhs: StaticTextComponent) -> Bool {
    guard lhs.text == rhs.text else { return false }
    guard lhs.font == rhs.font else { return false }
    guard lhs.backgroundColor == rhs.backgroundColor else { return false }
    guard lhs.lineFragmentPadding == rhs.lineFragmentPadding else { return false }
    guard lhs.id == rhs.id else { return false }
    guard lhs.width == rhs.width else { return false }
    return true
}
// MARK: - TextFieldComponent AutoEquatableComponent
extension TextFieldComponent: Equatable {}
public func == (lhs: TextFieldComponent, rhs: TextFieldComponent) -> Bool {
    guard lhs.placeholder == rhs.placeholder else { return false }
    guard lhs.backgroundColor == rhs.backgroundColor else { return false }
    guard lhs.editingChangeDelay == rhs.editingChangeDelay else { return false }
    guard lhs.maximumCharacterCount == rhs.maximumCharacterCount else { return false }
    guard lhs.id == rhs.id else { return false }
    guard lhs.width == rhs.width else { return false }
    guard lhs.height == rhs.height else { return false }
    return true
}
// MARK: - TextViewComponent AutoEquatableComponent
extension TextViewComponent: Equatable {}
public func == (lhs: TextViewComponent, rhs: TextViewComponent) -> Bool {
    guard lhs.backgroundColor == rhs.backgroundColor else { return false }
    guard lhs.id == rhs.id else { return false }
    guard lhs.width == rhs.width else { return false }
    guard lhs.height == rhs.height else { return false }
    return true
}
