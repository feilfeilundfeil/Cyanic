//
//  ThrottleType.swift
//  Cyanic
//
//  Created by Julio Miguel Alorro on 3/10/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import struct RxSwift.RxTimeInterval

/**
 Represents the kind of throttling option available for SingleSectionComponentViewController
*/
public enum ThrottleType {

    /**
     Changes in State are ignored until a specified time interval has passed, the time interval is reset
     when changes in State occur within the time interval.
    */
    case debounce(RxTimeInterval)

    /**
     Changes in State are ignored until a specified time interval has passed.
    */
    case throttle(RxTimeInterval)

    /**
     Changes in State are immediately emitted.
    */
    case none
}
