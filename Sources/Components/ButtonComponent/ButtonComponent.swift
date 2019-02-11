//
//  ButtonComponent.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/10/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import LayoutKit
import Alacrity
import RxSwift
import RxCocoa

open class ButtonComponent<T>: Component {

    public init(model: BehaviorRelay<T>, viewModelType: ButtonComponentVM<T>.Type) {
        let disposeBag: DisposeBag = DisposeBag()
        let state: ButtonComponentState = ButtonComponentState()
        self.disposeBag = disposeBag
        self.viewModel = viewModelType.init(model: model.value)
        self.identity = state

        let viewModel: Observable<ButtonComponentVM<T>> = model
            .map { (currentValue: T) -> ButtonComponentVM<T> in
                return viewModelType.init(model: currentValue)
            }

        viewModel
            .map { (currentViewModel: ButtonComponentVM<T>) -> String in
                return currentViewModel.title
            }
            .bind(to: state.title)
            .disposed(by: disposeBag)

        viewModel
            .map { (currentViewModel: ButtonComponentVM<T>) -> UIColor in
                return currentViewModel.color
            }
            .bind(to: state.color)
            .disposed(by: disposeBag)

        viewModel
            .map { (currentViewModel: ButtonComponentVM<T>) -> Bool in
                return currentViewModel.isEnabled
            }
            .bind(to: state.isEnabled)
            .disposed(by: disposeBag)
    }

    public var viewModel: ViewModel
    public let identity: StateType
    public let cellType: ConfigurableCell.Type = ConfigurableCell.self
    public let disposeBag: DisposeBag

    open var layout: ComponentLayout {
        fatalError("Override")
    }

}

