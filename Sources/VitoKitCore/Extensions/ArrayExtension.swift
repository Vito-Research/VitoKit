//
//  SwiftUIView.swift
//
//
//  Created by Andreas Ink on 6/13/22.
//

import Foundation

public extension Array {
    // Slices into a dict based on date components
    func sliced(by dateComponents: Set<Calendar.Component>, for key: KeyPath<Element, Date>) -> [Date: [Element]] {
        let initial: [Date: [Element]] = [:]

        let groupedByDateComponents = reduce(into: initial) { acc, cur in

            let components = Calendar.current.dateComponents(dateComponents, from: cur[keyPath: key])
            let date = Calendar.current.date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }

        return groupedByDateComponents
    }
}

// Allows dict to be used in ForEach
public extension RandomAccessCollection {
    func indexed() -> [(offset: Int, element: Element)] {
        Array(enumerated())
    }
}
