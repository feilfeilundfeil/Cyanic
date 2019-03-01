//
//  ComponentLayout.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/9/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import protocol LayoutKit.Layout
import class RxSwift.DisposeBag

/**
 A ComponentLayout is simply a Layout with a disposeBag to properly deallocate Rx related subscriptions.
 A ComponentLayout calculates the size and location of the subviews in a given CGRect. The subviews are styled based on the
 data of the Component that owns this ComponentLayout
*/
public protocol ComponentLayout: class, Layout {

    /**
     The DisposeBag to deallocate any subscriptions tied to the lifetime of this ComponentLayout instance.
    */
    var disposeBag: DisposeBag { get }

}

public extension ComponentLayout {

    /**
     The String identifier of the ComponentLayout used for viewReuseId in LayoutKit
    */
    static var identifier: String {
        return String(describing: self)
    }

}
