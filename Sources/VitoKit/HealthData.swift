//
//  File.swift
//  
//
//  Created by Andreas Ink on 6/11/22.
//

@preconcurrency import Foundation

// Stores health data and it's context
public struct HealthData: Identifiable, Codable, Hashable, Sendable {
    
    public init(id: String, type: DataType, title: String, text: String, date: Date, endDate: Date, data: Double, risk: Int) {
        self.id = id
        self.type = type
        self.title = title
        self.text = text
        self.date = date
        self.endDate = endDate
        self.data = data
        self.risk = risk
    }
    
    public var id: String
    public var type: DataType
    public var title: String
    public var text: String
    public var date: Date
    public var endDate: Date?
    public var data: Double
    public var risk: Int

    
    
}
public enum DataType: String, Codable, CaseIterable, Sendable {
    
    case HRV = "HRV"
    case Health = "Health"
    case Feeling = "Feeling"
    case Risk = "Risk"
    
}
