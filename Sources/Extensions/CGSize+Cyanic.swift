//
//  Cyanic
//  Created by Julio Miguel Alorro on 05.03.19.
//  Licensed under the MIT license. See LICENSE file
//

import CoreGraphics

extension CGSize: Hashable {

    public func hash(into hasher: inout Hasher) {
        self.height.hash(into: &hasher)
        self.width.hash(into: &hasher)
    }

}
