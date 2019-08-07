//
//  Cyanic
//  Created by Julio Miguel Alorro on 05.03.19.
//  Licensed under the MIT license. See LICENSE file
//

/**
 Selectable is a protocol adopted by Components that want to utilize the collectionView(collectionView:didSelectItemAt:)
 method in SingleSectionComponentViewController.
*/
public protocol Selectable {

    /**
     Code block executed when collectionView(collectionView:didSelectItemAt:) method is called by the UICollectionView.
    */
    func onSelect()

}
