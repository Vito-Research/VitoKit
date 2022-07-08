//
//  File.swift
//
//
//  Created by Andreas Ink on 6/21/22.
//

import SwiftUI

public class Fitbit: ObservableObject {
    var session = URLSession.shared
    @AppStorage("accessToken") var accessToken: String?

    public init() {}

    func getHRV(start: String, end: String) async throws -> HRVQuery? {
        if let accessToken = accessToken {
            var request = URLRequest(url: URL(string: "https://api.fitbit.com/1/user/-/hrv/date/\(start)/\(end).json")!)
            //
            print("ACCESS TOKEN")
            print(accessToken)
            request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            // request.setValue("application/json", forHTTPHeaderField: "Accept")
            print(request)
            let res = try await session.upload(
                for: request,
                from: Data()
            )
            print(res.1)
            let jsonDecoder = JSONDecoder()
            print(String(data: res.0, encoding: .utf8)!)
            // print(try? jsonDecoder.decode(FitbitData.self, from: res.0))
            return try jsonDecoder.decode(HRVQuery.self, from: res.0)
        } else {
            // fatalError()
            print("YIKES")
            return nil
        }
    }

    func getO2(start: String, end: String) async throws -> RRQuery? {
        if let accessToken = accessToken {
            var request = URLRequest(url: URL(string: "https://api.fitbit.com/1/user/-/spo2/date/\(start)/\(end).json")!)
            //
            print("ACCESS TOKEN")
            print(accessToken)
            request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            // request.setValue("application/json", forHTTPHeaderField: "Accept")
            print(request)
            let res = try await session.upload(
                for: request,
                from: Data()
            )
            print(res.1)
            let jsonDecoder = JSONDecoder()
            print(String(data: res.0, encoding: .utf8)!)
            // print(try? jsonDecoder.decode(FitbitData.self, from: res.0))
            return try jsonDecoder.decode(RRQuery.self, from: res.0)
        } else {
            // fatalError()
            print("YIKES")
            return nil
        }
    }

    func getRR(start: String, end: String) async throws -> [O2Query]? {
        if let accessToken = accessToken {
            var request = URLRequest(url: URL(string: "https://api.fitbit.com/1/user/-/spo2/date/\(start)/\(end).json")!)
            //
            print("ACCESS TOKEN")
            print(accessToken)
            request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            // request.setValue("application/json", forHTTPHeaderField: "Accept")
            print(request)
            let res = try await session.upload(
                for: request,
                from: Data()
            )
            print(res.1)
            let jsonDecoder = JSONDecoder()
            print(String(data: res.0, encoding: .utf8)!)
            // print(try? jsonDecoder.decode(FitbitData.self, from: res.0))
            return try jsonDecoder.decode([O2Query].self, from: res.0)
        } else {
            // fatalError()
            print("YIKES")
            return nil
        }
    }

    func getHeartrate(start: String, end: String) async throws -> FitbitData? {
        if let accessToken = accessToken {
            var request = URLRequest(url: URL(string: "https://api.fitbit.com/1/user/-/activities/heart/date/\(start)/\(end).json")!)
            //
            print("ACCESS TOKEN")
            print(accessToken)
            request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            // request.setValue("application/json", forHTTPHeaderField: "Accept")
            print(request)
            let res = try await session.upload(
                for: request,
                from: Data()
            )
            print(res.1)
            let jsonDecoder = JSONDecoder()
            print(String(data: res.0, encoding: .utf8)!)
            // print(try? jsonDecoder.decode(FitbitData.self, from: res.0))
            return try jsonDecoder.decode(FitbitData.self, from: res.0)
        } else {
            // fatalError()
            print("YIKES")
            return nil
        }
    }

    func authorizeFitbit(_ data: Data, to url: URL, type _: String = "POST") async throws -> (Data, URLResponse) {
        var request = URLRequest(url: url)
        //

        return try await session.upload(
            for: request,
            from: data
        )
    }
}
