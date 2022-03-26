//
//  DummyPhotoRepository.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 24/03/22.
//

import Foundation
import UIKit
import ServiceLayer

// MARK: - Default Photo Repository

final class DummyPhotoRepository: PhotoRepository {
    func fetchMostPopular(page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ()) {
        
    }
    
    func search(searchQuery: String, page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ()) {
        
        //
        //        let images = UIImage(na)
        //
        //        image1,
        //        image2,
        //        image3,
        //        image4,
        //        image5,
        //        image6,
        //        image7,
                
                completion(.success([]))

    }
}
