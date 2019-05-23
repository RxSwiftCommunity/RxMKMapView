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

private struct BoxedHashable<T: NSObjectProtocol>: Hashable {
    public let value: T

    public init(_ value: T) {
        self.value = value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value.hash)
    }

    public static func == (lhs: BoxedHashable, rhs: BoxedHashable) -> Bool {
        return lhs.value.isEqual(rhs.value)
    }
}

private struct Entry<T> {
    public var prev: T?
    public var next: T?

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
        var entries = [BoxedHashable<T>: Entry<T>]()

        for item in previous {
            var entry = entries[BoxedHashable(item)] ?? Entry()
            entry.prev = item
            entries[BoxedHashable(item)] = entry
        }

        for item in next {
            var entry = entries[BoxedHashable(item)] ?? Entry()
            entry.next = item
            entries[BoxedHashable(item)] = entry
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
