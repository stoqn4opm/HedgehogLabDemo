//
//  FileSystemRawDataAccessor.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 26/03/22.
//

import Foundation
import ServiceLayer

struct FileSystemRawDataAccessor: RawDataAccessor {
    func store(data: Data, forKey: String, withCompletion completion: @escaping (Error?) -> ()) {
        #warning("IMPLEMENT")
    }
    
    func read(forKey: String, withCompletion completion: @escaping (Result<Data, Error>) -> ()) {
        #warning("IMPLEMENT")
    }
}
