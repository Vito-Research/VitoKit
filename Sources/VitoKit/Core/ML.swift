//
//  SwiftUIView.swift
//  
//
//  Created by Andreas Ink on 6/16/22.
//

import SwiftUI
import CreateML
import TabularData

public class ML {
    
    public init() {}
    // Classifies data based on context, returns an accuracy score of the model
    public func classifier(_ data: [HealthData]) throws -> Double? {
        
        // Prepare df with columns
        let date = Column(name: "Date", contents: data.map{$0.date})
        let values = Column(name: "Data", contents: data.map{$0.data})
        let context = Column(name: "Context", contents: data.map{$0.context})
        var df = DataFrame()
        df.append(column: date)
        df.append(column: values)
        df.append(column: context)
        
        
        // Create model with df as input and target columm as Context
        let model = try MLRandomForestClassifier(trainingData: df, targetColumn: "Context")
        
        // Calcluate and return accuracy
        let trainingError = model.trainingMetrics.classificationError
        let trainingAccuracy = (1.0 - trainingError) * 100
        return trainingAccuracy
    }
    
}

