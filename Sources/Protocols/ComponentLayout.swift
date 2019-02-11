//
//  ComponentLayout.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/9/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import protocol LayoutKit.Layout
import class RxSwift.DisposeBag
import class UIKit.UIView
import struct CoreGraphics.CGFloat

/**
 A ComponentLayout's purpose is to create UIViews necessary of the Component and define its size, location and UI properties such as
 text and/or color. This means that the data binding occurs on this data structure.

 A ComponentLayout contains a DisposeBag which allows Rx related features such as data binding (subscriptions) to work and be
 disposed of properly
*/
public protocol ComponentLayout: class, Layout {

    var disposeBag: DisposeBag { get }

}

public extension ComponentLayout {

    static var identifier: String {
        return String(describing: self)
    }

}
