//
//  Cyanic
//  Created by Julio Miguel Alorro on 09.04.19.
//  Licensed under the MIT license. See LICENSE file
//

import LayoutKit
import UIKit
import RxSwift
import RxCocoa

open class TextFieldComponentLayout: InsetLayout<UIView>, ComponentLayout {

    public init(component: TextFieldComponent, width: CGFloat) { // swiftlint:disable:this function_body_length
        let insets: UIEdgeInsets = component.insets

        let serialDisposable: SerialDisposable = SerialDisposable()
        let disposeBag: DisposeBag = DisposeBag()

        serialDisposable.disposed(by: disposeBag)

        let size: CGSize = CGSize(width: width, height: component.height)

        let textFieldLayout: SizeLayout<UITextField> = SizeLayout<UITextField>(
            minWidth: size.width,
            maxWidth: size.width,
            minHeight: size.height,
            maxHeight: size.height,
            alignment: component.alignment,
            flexibility: component.flexibility,
            viewReuseId: "\(TextFieldComponentLayout.identifier)SizeLayout",
            viewClass: component.textFieldType,
            config: { (view: UIView) -> Void in
                guard let view = view as? UITextField else { return }
                component.configuration(view)

                view.text = component.text
                view.placeholder = component.placeholder

                let disposables: [Disposable] = [
                    view.rx.controlEvent([UIControl.Event.editingChanged])
                        .map({ () -> UITextField in
                            return view
                        })
                        .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
                        .bind(
                            onNext: { (view: UITextField) -> Void in
                                component.editingChanged(view)
                            }
                        )
                ]

                let compositeDisposable: CompositeDisposable = CompositeDisposable(disposables: disposables)
                serialDisposable.disposable = compositeDisposable
                view.delegate = component.delegate

                guard let delegate = component.delegate as? CyanicTextFieldDelegateProxy else { return }
                delegate.shouldBeginEditing = component.shouldBeginEditing
                delegate.didBeginEditing = component.didBeginEditing
                delegate.shouldEndEditing = component.shouldEndEditing
                delegate.didEndEditing = component.didEndEditing
                delegate.maximumCharacterCount = component.maximumCharacterCount
                delegate.shouldClear = component.shouldClear
                delegate.shouldReturn = component.shouldReturn
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
