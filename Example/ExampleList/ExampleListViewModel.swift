//
//  ExampleViewModel.swift
//  Example
//
//  Created by Julio Miguel Alorro on 3/27/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Cyanic

public final class ExampleListViewModel: ExampleViewModel<ExampleListState> {

    // MARK: Methods
    func buttonWasTapped() {
        self.setState { $0.hasTextInTextField = !$0.hasTextInTextField }
    }

}
