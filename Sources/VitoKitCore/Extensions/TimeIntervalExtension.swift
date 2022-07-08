//
//  File.swift
//
//
//  Created by Andreas Ink on 6/12/22.
//

import Foundation

// Subtracts time from a date
public extension TimeInterval {
    static let hour = -60 * 60.0
    static let day = -86400.0
    static let month = -2_629_743.83
    static let year = -2_629_743.83 * 12
}
