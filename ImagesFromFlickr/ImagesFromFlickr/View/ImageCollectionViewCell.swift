//
//  ImageCollectionViewCell.swift
//  ImagesFromFlickr
//
//  Created by Anita Agrawal on 07/08/18.
//  Copyright © 2018 Anita Agrawal. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var flickrImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        flickrImageView.image = nil
    }
    
    func updateCellWithDetails(photoURL: String) {
        flickrImageView.isHidden = true
        flickrImageView.loadImageFrom(urlStr: photoURL)
    }
}
