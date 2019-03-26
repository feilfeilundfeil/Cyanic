//
//  CGSize+Cyanic.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 3/5/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import struct CoreGraphics.CGSize

extension CGSize: Hashable {

    public func hash(into hasher: inout Hasher) {
        self.height.hash(into: &hasher)
        self.width.hash(into: &hasher)
    }

}
