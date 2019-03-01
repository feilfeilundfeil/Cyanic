//
//  StaticSpacingComponentLayout.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Foundation
import RxSwift
import LayoutKit

public final class StaticSpacingComponentLayout: SizeLayout<UIView>, ComponentLayout {

    public init(height: CGFloat, backgroundColor: UIColor) {
        super.init(
            minWidth: Constants.screenWidth,
            maxWidth: Constants.screenWidth,
            minHeight: height, maxHeight: height,
            alignment: Alignment.center,
            flexibility: Flexibility.inflexible,
            viewReuseId: StaticSpacingComponentLayout.identifier,
            sublayout: nil,
            config: { (view: UIView) -> Void in
                view.backgroundColor = backgroundColor
            }
        )
    }

    public let disposeBag: DisposeBag = DisposeBag()
}
