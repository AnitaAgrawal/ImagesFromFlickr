//
//  UtilityExtensions.swift
//  ImagesFromFlickr
//
//  Created by Anita Agrawal on 07/08/18.
//  Copyright © 2018 Anita Agrawal. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageFrom(urlStr: String) {
        guard let url = URL(string: urlStr) else {
            return
        }
        
        DispatchQueue.global().async {[weak self] in
            do {
                if let image = ImageHandler.getImageFromCache(imageName: urlStr) {
                    DispatchQueue.main.async {[weak self] in
                        self?.image = image
                        self?.isHidden = false
                    }
                }else {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async {[weak self] in
                        guard let image = UIImage(data: data) else {return}
                        
                        self?.image = image
                        ImageHandler.saveImageToCache(imageName: urlStr, image: image)
                        self?.isHidden = false
                    }
                }
                
            } catch  {
                print("Error occurred during image download")
            }
        }
    }
}

