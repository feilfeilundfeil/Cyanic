// Generated using Sourcery 0.15.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable all


// MARK: - AutoHashable for classes, protocols, structs
// MARK: - ButtonComponent AutoHashable
extension ButtonComponent: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.type.hash(into: &hasher)
        self.title.hash(into: &hasher)
        self.height.hash(into: &hasher)
        self.backgroundColor.hash(into: &hasher)
        self.id.hash(into: &hasher)
    }
}
// MARK: - ChildVCComponent AutoHashable
extension ChildVCComponent: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.height.hash(into: &hasher)
        self.id.hash(into: &hasher)
    }
}
// MARK: - ExpandableComponent AutoHashable
extension ExpandableComponent: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.id.hash(into: &hasher)
        self.contentLayout.hash(into: &hasher)
        self.backgroundColor.hash(into: &hasher)
        self.height.hash(into: &hasher)
        self.chevronSize.hash(into: &hasher)
        self.isExpanded.hash(into: &hasher)
    }
}
// MARK: - StaticSpacingComponent AutoHashable
extension StaticSpacingComponent: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.id.hash(into: &hasher)
        self.height.hash(into: &hasher)
        self.backgroundColor.hash(into: &hasher)
    }
}
// MARK: - StaticTextComponent AutoHashable
extension StaticTextComponent: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.id.hash(into: &hasher)
        self.text.hash(into: &hasher)
        self.font.hash(into: &hasher)
        self.backgroundColor.hash(into: &hasher)
        self.lineFragmentPadding.hash(into: &hasher)
    }
}

// MARK: - AutoHashable for Enums []
