// Generated using Sourcery 0.16.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable all


// MARK: - AutoHashable for classes, protocols, structs
// MARK: - ButtonComponentType AutoHashable
extension ButtonComponent: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.type.hash(into: &hasher)
        self.title.hash(into: &hasher)
        self.backgroundColor.hash(into: &hasher)
        self.id.hash(into: &hasher)
        self.width.hash(into: &hasher)
        self.height.hash(into: &hasher)
    }
}
// MARK: - ChildVCComponentType AutoHashable
extension ChildVCComponent: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.name.hash(into: &hasher)
        self.description.hash(into: &hasher)
        self.id.hash(into: &hasher)
        self.width.hash(into: &hasher)
        self.height.hash(into: &hasher)
    }
}
// MARK: - ExpandableComponentType AutoHashable
extension ExpandableComponent: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.backgroundColor.hash(into: &hasher)
        self.chevronSize.hash(into: &hasher)
        self.isExpanded.hash(into: &hasher)
        self.id.hash(into: &hasher)
        self.width.hash(into: &hasher)
        self.height.hash(into: &hasher)
    }
}
// MARK: - StaticSpacingComponentType AutoHashable
extension StaticSpacingComponent: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.backgroundColor.hash(into: &hasher)
        self.id.hash(into: &hasher)
        self.width.hash(into: &hasher)
        self.height.hash(into: &hasher)
    }
}
// MARK: - StaticTextComponentType AutoHashable
extension StaticTextComponent: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.text.hash(into: &hasher)
        self.font.hash(into: &hasher)
        self.backgroundColor.hash(into: &hasher)
        self.lineFragmentPadding.hash(into: &hasher)
        self.id.hash(into: &hasher)
        self.width.hash(into: &hasher)
    }
}

// MARK: - AutoHashable for Enums []
