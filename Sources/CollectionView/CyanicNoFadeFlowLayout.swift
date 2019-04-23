//
//  CyanicNoFadeFlowLayout.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 4/11/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UICollectionViewFlowLayout
import class UIKit.UICollectionViewLayoutAttributes
import struct Foundation.IndexPath

/**
 The default behavior for UICollectionViewFlowLayout when its UICollectionView updates its cell  is to show a "flash",
 sometimes this behaviour is acceptable and other times it isn't. This UICollectionViewFlowLayout will keep the alpha
 of updated UICollectionViewCells therefore eliminating the "flash".

 **Caveats**

 This shouldn't be used with the ExpandableComponent or any SingleSectionComponentViewController where the elements
 are changing. It makes the animation look broken
*/
open class CyanicNoFadeFlowLayout: UICollectionViewFlowLayout {

    override open func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes: UICollectionViewLayoutAttributes? = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        attributes?.alpha = 1.0
        return attributes
    }

    override open func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes: UICollectionViewLayoutAttributes? = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        attributes?.alpha = 1.0
        return attributes
    }

}
