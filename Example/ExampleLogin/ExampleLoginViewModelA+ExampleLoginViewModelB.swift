//
//  ExampleLoginViewModelA+ExampleLoginViewModelB.swift
//  Example
//
//  Created by Julio Miguel Alorro on 3/27/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Cyanic

public final class ExampleLoginViewModelA: ExampleViewModel<ExampleLoginStateA> {

    public func secondButtonTapped() {
        self.setState(with: { $0.isTrue = true } )
    }

    public func thirdButtonTapped() {
        self.setState(with: { $0.isTrue = false } )
    }

    public func setUserName(_ userName: String) {
        self.setState(with: { $0.userName = userName })
    }

}

public final class ExampleLoginViewModelB: ExampleViewModel<ExampleLoginStateB> {

    public func secondButtonTapped() {
        self.setState(with: { $0.isTrue = false })
    }

    public func thirdButtonTapped() {
        self.setState(with: { $0.isTrue = true })
    }

    public func setPassword(_ password: String) {
        self.setState(with: { $0.password = password })
    }
}
