// Generated using Sourcery 0.16.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable all
// MARK: - AutoHashableComponent
// MARK: - ButtonComponent AutoHashableComponent
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
// MARK: - ChildVCComponent AutoHashableComponent
extension ChildVCComponent: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.name.hash(into: &hasher)
        self.description.hash(into: &hasher)
        self.id.hash(into: &hasher)
        self.width.hash(into: &hasher)
        self.height.hash(into: &hasher)
    }
}
// MARK: - ExpandableComponent AutoHashableComponent
extension ExpandableComponent: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.contentLayout.hash(into: &hasher)
        self.backgroundColor.hash(into: &hasher)
        self.chevronSize.hash(into: &hasher)
        self.isExpanded.hash(into: &hasher)
        self.id.hash(into: &hasher)
        self.width.hash(into: &hasher)
        self.height.hash(into: &hasher)
    }
}
// MARK: - StaticSpacingComponent AutoHashableComponent
extension StaticSpacingComponent: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.backgroundColor.hash(into: &hasher)
        self.id.hash(into: &hasher)
        self.width.hash(into: &hasher)
        self.height.hash(into: &hasher)
    }
}
// MARK: - StaticTextComponent AutoHashableComponent
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
// MARK: - TextFieldComponent AutoHashableComponent
extension TextFieldComponent: Hashable {
    public func hash(into hasher: inout Hasher) {
        self.placeholder.hash(into: &hasher)
        self.backgroundColor.hash(into: &hasher)
        self.id.hash(into: &hasher)
        self.width.hash(into: &hasher)
        self.height.hash(into: &hasher)
    }
}
