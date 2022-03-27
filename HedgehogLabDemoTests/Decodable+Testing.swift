//
//  Decodable+Testing.swift
//  HedgehogLabDemoTests
//
//  Created by Stoyan Stoyanov on 25/03/22.
//

import Foundation

public extension Decodable {
    
    /// Parses a JSON file that is part of the testing bundle in to the type
    /// that the function is called on.
    ///
    /// Parameters:
    ///   - fileName: The name of the JSON file to be parsed.
    ///   - dateDecodingStrategy: The date decoding strategy to use.
    ///   - keyDecodingStrategy: The key decoding strategy to use.
    ///   - dataDecodingStrategy: The data decoding strategy to use.
    ///
    /// - Throws: The error produced attempting to locate or decode the
    /// specified JSON file.
    ///
    /// - Returns: An instance of the receiving type parsed from the JSON in the
    /// file with the given name.
    static func from(fileName: String, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? = nil, dataDecodingStrategy: JSONDecoder.DataDecodingStrategy? = nil) throws -> Self {
        let bundle = Bundle(for: BundleClass.self)
        guard let fileURL = bundle.url(forResource: fileName, withExtension: "json") else {
            throw NSError(domain: "HedgehogLabDemoTests",
                          code: 0,
                          userInfo: [NSLocalizedDescriptionKey: "No file found named \(fileName).json in bundle at \(bundle.bundleURL)"])
        }
        let decoder = JSONDecoder()
        if let dateDecodingStrategy = dateDecodingStrategy {
            decoder.dateDecodingStrategy = dateDecodingStrategy
        }
        if let keyDecodingStrategy = keyDecodingStrategy {
            decoder.keyDecodingStrategy = keyDecodingStrategy
        }
        if let dataDecodingStrategy = dataDecodingStrategy {
            decoder.dataDecodingStrategy = dataDecodingStrategy
        }
        return try decoder.decode(Self.self, from: Data(contentsOf: fileURL))
    }
}

private final class BundleClass {}

