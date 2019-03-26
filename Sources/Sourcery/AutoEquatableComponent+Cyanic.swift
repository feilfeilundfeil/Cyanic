// Generated using Sourcery 0.16.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable private_over_fileprivate
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
    guard lhs.backgroundColor == rhs.backgroundColor else { return false }
    guard lhs.chevronSize == rhs.chevronSize else { return false }
    guard lhs.isExpanded == rhs.isExpanded else { return false }
    guard lhs.id == rhs.id else { return false }
    guard lhs.width == rhs.width else { return false }
    guard lhs.height == rhs.height else { return false }
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