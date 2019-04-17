//
//  ComponentLayout.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 2/9/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class RxSwift.DisposeBag
import protocol LayoutKit.Layout

/**
 A ComponentLayout is simply a Layout that is customized for Cyanic.

 A ComponentLayout calculates the size and location of the subviews in a given CGRect. The subviews are styled based on the
 data of the Component that owns this ComponentLayout
*/
public protocol ComponentLayout: class, Layout {}

public extension ComponentLayout {

    /**
     The String identifier of the ComponentLayout used for viewReuseId in LayoutKit
    */
    static var identifier: String {
        return String(describing: self)
    }

}
