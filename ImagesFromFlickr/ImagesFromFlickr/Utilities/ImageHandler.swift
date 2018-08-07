//
//  ImageHandler.swift
//  ImagesFromFlickr
//
//  Created by Anita Agrawal on 07/08/18.
//  Copyright © 2018 Anita Agrawal. All rights reserved.
//

import Foundation
import UIKit

class ImageHandler {
    static func getImageFromCache(imageName: String) -> UIImage? {
        guard let directoryPath =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        let imageURL = directoryPath.appendingPathComponent(imageName.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "/", with: "_"))
        
        return UIImage.init(contentsOfFile: imageURL.path)
    }
    
    static func saveImageToCache(imageName: String, image: UIImage) {
        guard let directoryPath =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        
//        let filename = imageName.appending(".jpg")
//        let filepath = directoryPath.appending(imageName)
//        print(filepath)
        let url = directoryPath.appendingPathComponent(imageName.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "/", with: "_"))
        print(url)
        do {
            try UIImageJPEGRepresentation(image, 1.0)?.write(to: url, options: .atomic)
        } catch {
            debugPrint(error)
            debugPrint("file cant not be save at path \(directoryPath), with error : \(error)");
        }
    }
}


