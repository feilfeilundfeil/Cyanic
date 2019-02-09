//
//  ViewModel.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/9/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

/**
 The ViewModel is simply a type.
 A ViewModel acts as a wrapper around a model class, only exposing information from the model relevant to the component.
 It transforms the model's exposed properties into UI friendly data.

 May have read related observables.

 For example

 ```
 class Pokemon {
    let id: Int
 }

 class PokemonVM: ViewModel  {
    private let model: Pokemon

    var id: String {
        switch self.model.id {
            case 1...9:
                return "00\(self.model.id)"

            case 10...99:
                return "0\(self.model.id)"

            default:
                return self.model.id
        }
    }
 }

 ```
*/
public protocol ViewModel: CustomStringConvertible {}
