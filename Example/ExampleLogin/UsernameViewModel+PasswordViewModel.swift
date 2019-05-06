//
//  UsernameViewModel+PasswordViewModel.swift
//  Example
//
//  Created by Julio Miguel Alorro on 3/27/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Cyanic

public final class UsernameViewModel: ExampleViewModel<UsernameState> {

    public func setUserName(_ userName: String) {
        self.setState(with: { $0.userName = userName })
    }

}

public final class PasswordViewModel: ExampleViewModel<PasswordState> {

    public func setPassword(_ password: String) {
        self.setState(with: { $0.password = password })
    }

}
