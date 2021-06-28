//
//  Created by Dorian Grolaux on 03/06/2021.
//

import Foundation

extension RandomAccessCollection {
    func insertionIndex(for predicate: (Element) -> Bool) -> Index {
        var slice : SubSequence = self[...]
        
        while !slice.isEmpty {
            let middle = slice.index(slice.startIndex, offsetBy: slice.count / 2)
            if predicate(slice[middle]) {
                slice = slice[index(after: middle)...]
            } else {
                slice = slice[..<middle]
            }
        }
        return slice.startIndex
    }
}

extension Array where Element: Comparable {
    mutating func insertSorted(_ element: Element) {
        insert(element, at: insertionIndex(for: { element < $0 }))
    }
}

extension Array {
    mutating func insertSorted(_ element: Element,
                               using predicate: (Element) -> Bool) {
        insert(element, at: insertionIndex(for: predicate))
    }
}
