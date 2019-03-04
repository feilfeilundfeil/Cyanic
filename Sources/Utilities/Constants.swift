//
//  Constants.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 2/11/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import class UIKit.UIScreen
import struct CoreGraphics.CGFloat

internal enum Constants {
    internal static var screenWidth: CGFloat {
        print(UIScreen.main.bounds.width)
        return UIScreen.main.bounds.width
    }
}
