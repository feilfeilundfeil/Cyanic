//
//  SelectableComponent.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/5/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Foundation

/**
 Selectable is a protocol adopted by Components that want to utilize the collectionView(collectionView:didSelectItemAt:) method in
 BaseComponentVC.
*/
protocol Selectable {

    /**
     Code block executed when collectionView(collectionView:didSelectItemAt:) method is called by the UICollectionView.
    */
    func onSelect()

}
