//
//  DummyPhotoRepository.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 24/03/22.
//

import Foundation
import UIKit


// MARK: - Default Photo Repository

final class DummyPhotoRepository: PhotoRepository {
    func fetchMostPopular(withCompletion completion: (Result<UIImage, Error>) -> Void) {
        
    }
    
    
    func fetchMostPopular(withCompletion completion: (Result<[Data], Error>) -> Void) {
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
