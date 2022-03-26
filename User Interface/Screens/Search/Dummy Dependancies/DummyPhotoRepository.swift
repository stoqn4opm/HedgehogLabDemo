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
    func fetchMostPopular(inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ()) {
        
    }
    
    func search(searchQuery: String, inSize size: Photo.Size, page: Int, withCompletion completion: @escaping (Result<[RawPhoto], Error>) -> ()) {
        
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
