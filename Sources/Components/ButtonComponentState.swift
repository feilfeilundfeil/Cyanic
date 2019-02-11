//
//  ButtonComponentState.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/10/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import RxCocoa

public class ButtonComponentState: StateType {

    public let title: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    public let color: BehaviorRelay<UIColor> = BehaviorRelay<UIColor>(value: UIColor.clear)
    public let isEnabled: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: true)

    public static func == (lhs: ButtonComponentState, rhs: ButtonComponentState) -> Bool {
        return lhs.title.value == rhs.title.value &&
            lhs.color.value == rhs.color.value &&
            lhs.isEnabled.value == rhs.isEnabled.value
    }

    public override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        hasher.combine(self.title.value)
        hasher.combine(self.color.value)
        hasher.combine(self.isEnabled.value)
    }

}
