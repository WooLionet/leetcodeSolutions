//
//  XCTest+Exstension.swift
//  leetCodeSolutionsUnitTest
//
//  Created by  Pavel Himach on 01/02/2019.
//  Copyright © 2019  Pavel Himach. All rights reserved.
//

import XCTest

extension XCTest {
    func loadTestData<K: Hashable&Decodable, T: Decodable>() -> [K: T] {
        guard let shortClassName = self.className.split(separator: ".").last,
            shortClassName.suffix(4) == "Test" else {
            assertionFailure()
            return [K: T]()
        }
        let folderName = String(shortClassName.dropLast(4))
        guard !folderName.isEmpty else {
                assertionFailure()
                return [K: T]()
        }
        let fileName = "\(shortClassName)Data"
        let bundle = Bundle(for: self.classForCoder)
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {
            assertionFailure("\"\(fileName).json\" doesn't exist")
            return [K: T]()
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let decoder = JSONDecoder()
            if K.self == String.self || K.self == Int.self {
                let result = try decoder.decode([K: T].self, from: data)
                return result
            } else {
                let result = try decoder.decode([String: T].self, from: data)
                var ktResult = [K: T]()
                for (key, value) in result {
                    guard let kData = "[\"\(key)\"]".data(using: .utf8) else {
                        throw DecodingError.valueNotFound(K.self, .init(codingPath: [], debugDescription: "no data for key string"))
                    }
                    let kKey = try decoder.decode(K.self, from: kData)
                    ktResult[kKey] = value
                }
                return ktResult
            }

        } catch {
            assertionFailure(error.localizedDescription)
        }

        return [K: T]()
    }
}

protocol CodableEnum: RawRepresentable, Codable, CaseIterable {}

extension CodableEnum where RawValue == String {

    static func dataCorrupted() -> DecodingError {
        return DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "cant get case name from container"))
    }

    static func valueNotFound(_ value: String) -> DecodingError {
        return DecodingError.valueNotFound(self,
                                           .init(codingPath: [],
                                                 debugDescription: "can't decode string to enum value: \(value)"))
    }

    init(from decoder: Decoder) throws {
        guard let string = try decoder.singleValueContainer().decode([String].self).first else {
            throw Self.dataCorrupted()
        }

        for value in Self.allCases where value.rawValue == string {
            self = value
            return
        }
        throw Self.valueNotFound(string)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(self.rawValue)
    }
}
