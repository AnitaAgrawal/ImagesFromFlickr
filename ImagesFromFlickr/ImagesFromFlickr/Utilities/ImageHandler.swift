//
//  ImageHandler.swift
//  ImagesFromFlickr
//
//  Created by Anita Agrawal on 07/08/18.
//  Copyright © 2018 Anita Agrawal. All rights reserved.
//

import Foundation
import UIKit
/**
 * This Struct is used to save and retrieve images in Documents directory.
 * This will help in image cache to improve the performance.
*/
struct ImageHandler {
    static func getImageFromCache(imageName: String) -> UIImage? {
        guard let imageURL = getImagePathFor(imageName: imageName) else {return nil}
        return UIImage(contentsOfFile: imageURL.path)
    }
    
    static func saveImageToCache(imageName: String, image: UIImage) {
        guard let imageURL = getImagePathFor(imageName: imageName) else {return}
        do {
            try UIImageJPEGRepresentation(image, 1.0)?.write(to: imageURL, options: .atomic)
        } catch {
            debugPrint("file cant not be save at path \(imageURL), with error : \(error)");
        }
    }
    
    private static func getImagePathFor(imageName: String) -> URL? {
        guard let directoryPath =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        let imageURL = directoryPath.appendingPathComponent(imageName.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "/", with: "_"))
        return imageURL
    }
}
