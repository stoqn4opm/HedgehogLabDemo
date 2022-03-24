//
//  PhotoCollectionViewCell.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 24/03/22.
//

import Foundation
import UIKit

// MARK: - Class Definition

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
}

// MARK: - Populate With Data

extension PhotoCollectionViewCell {
    
    func populate(from data: Photo) {
        imageView.image = data.asImage
        imageView.backgroundColor = .green
    }
}
