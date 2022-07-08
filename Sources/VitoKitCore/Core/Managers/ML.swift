//
//  SwiftUIView.swift
//
//
//  Created by Andreas Ink on 6/16/22.
//
#if targetEnvironment(simulator)

#else

    import CreateML
    import SwiftUI
    import TabularData

    public class ML {
        public init() {}

        public func exportAsCSV(_ data: [HealthData]) {
            do {
                let df = try DataFrame(csvData: JSONEncoder().encode(data))
                try df.writeCSV(to: getDocumentsDirectory().appendingPathComponent("HealthData.csv"))
            } catch {}
        }

        // Classifies data based on context, returns an accuracy score of the model
        public func classifier(_ data: [HealthData]) throws -> Double? {
            // Prepare df with columns
            let date = Column(name: "Date", contents: data.map { $0.date })
            let values = Column(name: "Data", contents: data.map { $0.data })
            let context = Column(name: "Context", contents: data.map { $0.context })
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

        public func getDocumentsDirectory() -> URL {
            // find all possible documents directories for this user
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

            // just send back the first one, which ought to be the only one
            return paths[0]
        }
    }

#endif
