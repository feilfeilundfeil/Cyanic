//
//  ThrottleType.swift
//  FFUFComponents
//
//  Created by Julio Miguel Alorro on 3/10/19.
//  Copyright © 2019 Feil, Feil, & Feil  GmbH. All rights reserved.
//

import struct RxSwift.RxTimeInterval

/**
 Represents the kind of throttling option available for BaseComponentVC
*/
public enum ThrottleType {

    /**
     Changes in the State of the BaseComponentVC are ignored until a specified time interval has passed, the time interval is reset
     for changes that happen within the time interval.
    */
    case debounce(RxTimeInterval)

    /**
     Changes in the State of the BaseComponentVC are ignored until a specified time interval has passed.
    */
    case throttle(RxTimeInterval)
}
