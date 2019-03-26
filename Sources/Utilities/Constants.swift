//
//  Constants.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 2/11/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UIScreen
import struct CoreGraphics.CGFloat
import struct Foundation.UUID

internal enum Constants {
    internal static var screenWidth: CGFloat { return UIScreen.main.bounds.width }
    internal static var invalidID: String = UUID().uuidString
}
