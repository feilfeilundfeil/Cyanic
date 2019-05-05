//
//  TextFieldComponentLayout.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 4/9/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import LayoutKit
import UIKit
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
            config: { (view: UIView) -> Void in
                guard let view = view as? UITextField else { return }
                component.configuration(view)

                view.text = component.text
                view.placeholder = component.placeholder

                let disposables: [Disposable] = [
                    view.rx.text.orEmpty
                        .map({ (_: String) -> UITextField in
                            return view
                        })
                        .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
                        .bind(
                            onNext: { (view: UITextField) -> Void in
                                component.textDidChange(view)
                            }
                        )
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
