//
//  Cyanic
//  Created by Julio Miguel Alorro on 11.02.19.
//  Licensed under the MIT license. See LICENSE file
//

import CoreGraphics
import Foundation
import UIKit

public enum Constants {
    internal static var screenWidth: CGFloat { return UIScreen.main.bounds.width }
    internal static var bundleIdentifier: String { return Bundle.main.bundleIdentifier ?? "de.ffuf.Cyanic" }
    public static var invalidID: String = UUID().uuidString
}
