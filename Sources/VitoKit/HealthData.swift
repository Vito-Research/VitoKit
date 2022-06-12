//
//  File.swift
//  
//
//  Created by Andreas Ink on 6/11/22.
//

import Foundation

public struct HealthData: Identifiable, Codable, Hashable, Sendable {
    
    var id: String
    var type: DataType
    var title: String
    var text: String
    var date: Date
    var endDate: Date?
    var data: Double

    
    
}
public enum DataType: String, Codable, CaseIterable {
    
    case HRV = "HRV"
    case Health = "Health"
    case Feeling = "Feeling"
    case Risk = "Risk"
    
}
