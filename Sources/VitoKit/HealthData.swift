//
//  File.swift
//  
//
//  Created by Andreas Ink on 6/11/22.
//

import SwiftUI
import Foundation

// Stores health data and it's context
public struct HealthData: Identifiable, Codable, Hashable, Sendable {
    
    public init(id: String, type: DataType, title: String, text: String, date: Date, endDate: Date, data: Double, risk: Int, dataPoints: [HealthDataPoint], context: String = "") {
        self.id = id
        self.type = type
        self.title = title
        self.text = text
        self.date = date
        self.endDate = endDate
        self.data = data
        self.risk = risk
        self.dataPoints = dataPoints
        self.context = context
    }
    
    public var id: String
    public var type: DataType
    public var title: String
    public var text: String
    public var date: Date
    public var endDate: Date?
    public var data: Double
    public var risk: Int
    public var dataPoints: [HealthDataPoint]
    public var context: String
    
    
}
public enum DataType: String, Codable, CaseIterable, Sendable {
    
    case HRV = "HRV"
    case Health = "Health"
    case Feeling = "Feeling"
    case Risk = "Risk"
    
}
public struct HealthDataPoint: Hashable, Codable {
    public init(date: Date, value: Double) {
        self.date = date
        self.value = value
    }
    public var date: Date
    public var value: Double
   
}

public struct Risk: Hashable {
    public init(id: String, risk: CGFloat, explanation: [Explanation]) {
        self.id = id
        self.risk = risk
        self.explanation = explanation
    }
    public var id: String
    public var risk: CGFloat
    public var explanation: [Explanation]
}
