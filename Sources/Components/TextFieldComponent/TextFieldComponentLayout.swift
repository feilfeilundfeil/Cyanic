//
//  TextFieldComponentLayout.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 4/9/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class LayoutKit.InsetLayout
import class LayoutKit.SizeLayout
import class UIKit.UITextField
import class UIKit.UIView
import struct CoreGraphics.CGSize
import struct UIKit.UIEdgeInsets
import RxSwift
import RxCocoa

open class TextFieldComponentLayout: InsetLayout<UIView>, ComponentLayout {

    public init(component: TextFieldComponent) {
        let insets: UIEdgeInsets = component.insets

        let serialDisposable: SerialDisposable = SerialDisposable()
        let disposeBag: DisposeBag = DisposeBag()

        serialDisposable.disposed(by: disposeBag)

        let size: CGSize = component.size

        let textFieldLayout: SizeLayout<UITextField> = SizeLayout<UITextField>(
            minWidth: size.width,
            maxWidth: size.width,
            minHeight: size.height,
            maxHeight: size.height,
            alignment: component.alignment,
            flexibility: component.flexibility,
            viewReuseId: "\(TextFieldComponentLayout.identifier)SizeLayout",
            viewClass: component.textFieldType,
            config: { (textField: UIView) -> Void in
                guard let textField = textField as? UITextField else { return }
                component.style.applyStyle(to: textField)

                textField.text = component.text
                textField.placeholder = component.placeholder

                let disposables: [Disposable] = [
                    textField.rx
                        .controlEvent([UIControl.Event.editingChanged])
                        .map({ (_: Void) -> UITextField in return textField })
                        .debounce(0.5, scheduler: MainScheduler.instance)
                        .bind(onNext: component.textDidChange)
                ]

                let compositeDisposable: CompositeDisposable = CompositeDisposable(disposables: disposables)
                serialDisposable.disposable = compositeDisposable
            }
        )

        self.disposeBag = disposeBag
        super.init(
            insets: insets,
            alignment: component.alignment,
            flexibility: component.flexibility,
            viewReuseId: "\(TextFieldComponentLayout.identifier)InsetLayout",
            sublayout: textFieldLayout,
            config: { (view: UIView) -> Void in
                view.backgroundColor = component.backgroundColor
            }
        )
    }

    public let disposeBag: DisposeBag

}
