//
//  ComponentResult.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/16/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import Foundation

public enum ComponentResult {
    case component(() -> AnyComponent?)
    case components(() -> [AnyComponent?])
}
