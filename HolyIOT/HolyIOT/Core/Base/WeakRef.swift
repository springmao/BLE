//
//  WeakRef.swift
//  HolyIOT
//
//  Created by Nikita Vashchenko on 11.02.18.
//

import Foundation

/**
Wrapper for weak referenced value
*/

class WeakRef<T> where T: AnyObject {

    private(set) weak var value: T?

    init(value: T?) {
        self.value = value
    }
}
