//
//  Cyanic
//  Created by Julio Miguel Alorro on 31.10.19.
//  Licensed under the MIT license. See LICENSE file
//

import CoreGraphics

/**
 CellSize is an enum that defines the sizing for a CollectionComponentViewController
 */
public enum CellSize {

    /**
     Configures the UICollectionViewCell size to have the width of the UICollectionView and the height computed by the
     ComponentLayout that represents the cell.
    */
    case list

    /**
     Configures the UICollectionViewCell size to be the associated CGSize.
    */
    case exactly(CGSize)

}
