//
//  Cyanic
//  Created by Julio Miguel Alorro on 16.05.19.
//  Licensed under the MIT license. See LICENSE file
//

import LayoutKit

/**
 The TextViewComponentLayout is a ComponentLayout that is a subclass of SizeLayout<UIView>.
 Used to create, size, and arrange the subviews associated with TextViewComponent.
 */
public final class TextViewComponentLayout: SizeLayout<UIView>, ComponentLayout {

    /**
     Initializer.
     - Parameters:
        - component: The StaticTextComponent whose properties define the UI characters of the subviews to be created.
     */
    public init(component: TextViewComponent, width: CGFloat) {

        let textLayout: TextViewLayout<UITextView> = TextViewLayout<UITextView>(
            text: Text.unattributed(component.text),
            font: component.font,
            lineFragmentPadding: 0,
            textContainerInset: component.textContainerInset,
            layoutAlignment: component.alignment,
            flexibility: component.flexibility,
            viewReuseId: "\(TextViewComponentLayout.identifier)TextView",
            viewClass: component.textViewType,
            config: { (view: UITextView) -> Void in
                view.backgroundColor = component.backgroundColor
                view.isEditable = true
                view.isUserInteractionEnabled = true
                view.isScrollEnabled = true
                component.configuration(view)

                view.delegate = component.delegate
                guard let delegate = component.delegate as? CyanicTextViewDelegateProxy else { return }
                delegate.shouldBeginEditing = component.shouldBeginEditing
                delegate.didBeginEditing = component.didBeginEditing
                delegate.shouldEndEditing = component.shouldEndEditing
                delegate.didEndEditing = component.didEndEditing
                delegate.maximumCharacterCount = component.maximumCharacterCount
                delegate.didChange = component.didChange
                delegate.didChangeSelection = component.didChangeSelection
                delegate.shouldInteractWithURLInCharacterRange = component.shouldInteractWithURLInCharacterRange
                delegate
                    .shouldInteractWithTextAttachmentInCharacterRange = component
                        .shouldInteractWithTextAttachmentInCharacterRange
            }
        )

        let insetLayout: InsetLayout<UIView> = InsetLayout<UIView>(
            insets: component.insets,
            sublayout: textLayout
        )

        super.init(
            minWidth: width,
            maxWidth: width,
            minHeight: component.height,
            maxHeight: component.height,
            viewReuseId: "\(TextViewComponentLayout.identifier)Size",
            sublayout: insetLayout,
            config: {
                $0.backgroundColor = component.backgroundColor
            }
        )
    }
}
