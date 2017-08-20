//
//  Diff.swift
//  RxMKMapView
//
//  Created by Mikko Välimäki on 08/08/2017.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import Foundation
import MapKit

public struct Diff<T: NSObjectProtocol> {
    public let removed: [T]
    public let added: [T]
}

fileprivate struct BoxedHashable<T: NSObjectProtocol>: Hashable {

    public let value: T

    public init(_ value: T) {
        self.value = value
    }

    public var hashValue: Int {
        return self.value.hash
    }

    public static func ==(lhs: BoxedHashable, rhs: BoxedHashable) -> Bool {
        return lhs.value.isEqual(rhs.value)
    }
}

fileprivate struct Entry<T> {
    public let prev: T?
    public let next: T?

    func isRemoval() -> Bool {
        return prev != nil && next == nil
    }
    func isAddition() -> Bool {
        return prev == nil && next != nil
    }
    func value() -> T {
        return (prev ?? next)!
    }
}

public extension Diff {
    
    static func calculateFrom(previous: [T], next: [T]) -> Diff<T> {
        
        var entries = Dictionary<BoxedHashable<T>, Entry<T>>()

        for item in previous {
            let entry = entries[BoxedHashable(item)]
            entries[BoxedHashable(item)] = Entry(prev: item, next: entry?.next)
        }

        for item in next {
            let entry = entries[BoxedHashable(item)]
            entries[BoxedHashable(item)] = Entry(prev: entry?.prev, next: item)
        }

        var removed: [T] = []
        var added: [T] = []

        for (_, value) in entries {
            if value.isAddition() {
                added.append(value.value())
            } else if value.isRemoval() {
                removed.append(value.value())
            } // else no change
        }

        return Diff(removed: removed, added: added)
    }
}
