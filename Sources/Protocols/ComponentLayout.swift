//
//  Cyanic
//  Created by Julio Miguel Alorro on 09.02.19.
//  Licensed under the MIT license. See LICENSE file
//

import LayoutKit
import RxSwift

/**
 A ComponentLayout is simply a Layout that is customized for Cyanic.

 A ComponentLayout calculates the size and location of the subviews in a given CGRect. The subviews are styled based on the
 data of the Component that owns this ComponentLayout
*/
public protocol ComponentLayout: class, Layout {}

public extension ComponentLayout {

    /**
     The String identifier of the ComponentLayout used for viewReuseId in LayoutKit
    */
    static var identifier: String {
        return String(describing: self)
    }

}
