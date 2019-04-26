//
//  Size.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 4/14/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import CoreGraphics

/**
 In cases where ComponentViewController is a childViewController, it is sometimes necessary to have an exact size.
 This enum allows the the programmer to specify if there's an exact size for the ComponentViewController or if it
 should be taken cared of by UIKit.
*/
public enum Size {
    /**
     Size is defined by UIKit automatically. It is calculated by taking the UICollectionView's frame.
    */
    case automatic

    /**
     Size is defined by a constant value.
    */
    case exactly(CGSize)
}
