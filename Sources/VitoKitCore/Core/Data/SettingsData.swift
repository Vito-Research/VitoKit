//
//  File.swift
//
//
//  Created by Andreas Ink on 6/23/22.
//

import Foundation

public struct SettingsData: Codable {
    public init() {}
    public var share: Bool = false
    public var backgroundMode: Bool = true
    public var notifications: Bool = true
    public var sleepSchedule: [SleepData] = [SleepData()]
}

public struct SleepData: Codable {
    public init() {}
    public var day: String = "All"
    public var startDate: String = "10:00 PM"
    public var endDate: String = "7:00 AM"
}
