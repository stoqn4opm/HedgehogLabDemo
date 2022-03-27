//
//  PhotoCollectionViewCell.swift
//  HedgehogLabDemo
//
//  Created by Stoyan Stoyanov on 24/03/22.
//

import Foundation
import UIKit
import ServiceLayer

// MARK: - Class Definition

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    private var photo: Photo?
}

// MARK: - Populate With Data

extension PhotoCollectionViewCell {
    
    func populate(from photo: Photo, graphicRepresentation: (@escaping (UIImage?) -> ()) -> ()) {
        self.photo = photo
        
        graphicRepresentation { [weak self] image in
            guard self?.photo == photo else { return }
            self?.imageView.image = image
        }
        
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.borderWidth = 3
    }
}
