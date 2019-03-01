//
//  ButtonComponent2.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/27/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import LayoutKit
import Alacrity

// sourcery: AutoButtonComponentType,AutoEquatable,AutoHashable,
public struct ButtonComponent2: ButtonComponentType {

// sourcery:inline:auto:ButtonComponent2.AutoButtonComponentType
    public var type: ButtonLayoutType = ButtonLayoutType.system

    public var title: String = ""

    public var height: CGFloat = 44.0

    public var insets: UIEdgeInsets = UIEdgeInsets.zero

    public var backgroundColor: UIColor = UIColor.clear

    public var alignment: Alignment = ButtonLayoutDefaults.defaultAlignment

    public var flexibility: Flexibility = ButtonLayoutDefaults.defaultFlexibility

    public var style: AlacrityStyle<UIButton> = AlacrityStyle<UIButton> { _ in }

    public var onTap: () -> Void = { print("Hello World \(#file)") }

    public let disposeBag: DisposeBag = DisposeBag()

    public var layout: ComponentLayout { fatalError() }

    public let cellType: ComponentCell.Type = ComponentCell.self
// sourcery:end
}
