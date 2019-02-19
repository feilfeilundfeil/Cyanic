// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable all


// MARK: - AutoHashable for classes, protocols, structs
// MARK: - ButtonComponent AutoHashable
extension ButtonComponent: Hashable {
    open func hash(into hasher: inout Hasher) {
        type.hash(into: &hasher)
        title.hash(into: &hasher)
        id.hash(into: &hasher)
        height.hash(into: &hasher)
        backgroundColor.hash(into: &hasher)
    }
}
// MARK: - ExpandableComponent AutoHashable
extension ExpandableComponent: Hashable {
    public func hash(into hasher: inout Hasher) {
        text.hash(into: &hasher)
        font.hash(into: &hasher)
        height.hash(into: &hasher)
        isExpanded.hash(into: &hasher)
        id.hash(into: &hasher)
    }
}
// MARK: - StaticSpacingComponent AutoHashable
extension StaticSpacingComponent: Hashable {
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
        backgroundColor.hash(into: &hasher)
        height.hash(into: &hasher)
    }
}
// MARK: - StaticTextComponent AutoHashable
extension StaticTextComponent: Hashable {
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
        text.hash(into: &hasher)
        font.hash(into: &hasher)
        backgroundColor.hash(into: &hasher)
        lineFragmentPadding.hash(into: &hasher)
    }
}

// MARK: - AutoHashable for Enums []
