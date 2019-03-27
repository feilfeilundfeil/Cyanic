//
//  ViewModelA.swift
//  Example
//
//  Created by Julio Miguel Alorro on 3/27/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Cyanic

class ViewModelA: ViewModel<StateA> {

    func addButtonTapped() {
        self.setState(with: { $0.isTrue = true } )
    }

    func otherButtonTapped() {
        self.setState(with: { $0.isTrue = false } )
    }

}
class ViewModelB: ViewModel<StateB> {
    func addButtonTapped() {
        self.setState(with: { $0.isTrue = false })
    }

    func otherButtonTapped() {
        self.setState(with: { $0.isTrue = true })
    }
}
