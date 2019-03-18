//
//  SelectableComponent.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/5/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

/**
 Selectable is a protocol adopted by Components that want to utilize the collectionView(collectionView:didSelectItemAt:)
 method in BaseComponentVC.
*/
public protocol Selectable {

    /**
     Code block executed when collectionView(collectionView:didSelectItemAt:) method is called by the UICollectionView.
    */
    func onSelect()

}
