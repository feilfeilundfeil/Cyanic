//
//  ButtonComponentVM.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/10/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class ButtonComponentVM<T>: ViewModel {

    public required init(model: T) {
        self.model = model
    }

    public let model: T

    open var title: String {
        fatalError("Override")
    }

    open var color: UIColor {
        fatalError("Override")
    }

    open var isEnabled: Bool {
        fatalError("Override")
    }

    open var description: String {
        return String(describing: self.model)
    }

    open var cachedHeight: CGFloat?

}
