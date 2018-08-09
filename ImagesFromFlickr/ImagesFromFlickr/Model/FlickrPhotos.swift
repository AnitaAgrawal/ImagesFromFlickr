//
//  FlickrPhotos.swift
//  ImagesFromFlickr
//
//  Created by Anita Agrawal on 07/08/18.
//  Copyright © 2018 Anita Agrawal. All rights reserved.
//

import Foundation

class FlickrPhotos {
    private var task: URLSessionDataTask?
    //photos is a 2D array where the count of photos is number of sections
    //the count of inner array elements will be the number of items in that section.
    var photos: [[PhotoDetails]] = []
    var page = 0
    var pages = 0
    var perpage = 30 // setting per page item limit. It's multiple of three for 3 columns in one row.
    var total = 0
    var searchStr = "kittens" {
        didSet{
            //Resetting all the properties wheneven a new search string comes
            page = 0
            pages = 0
            photos.removeAll()
            total = 0
            
        }
    }
    
    func getPhotos(completionHandler: @escaping (Bool)->Void) {
        // Cancelling the already running task as we dont need it anymore since the new request has arrived.
        // This will eliminate the duplication and also prevent from displaying wrong data
        if let task = self.task {
            task.cancel()
        }
        
        task = ConnectionManager.makeHTTPRequest(url: APIEndPoints.Search, queryParameters: [APIConstants.page: "\(page + 1)", APIConstants.per_page: "\(perpage)","text":searchStr.isEmpty ? "kitten" : searchStr], bodyParameters: [:], successHandler: { (responseObject) in
            print(responseObject)
                        
            guard let photosObj = responseObject[APIConstants.photos] as? [String: Any] else {return completionHandler(false)}
            self.page = photosObj[APIConstants.page] as? Int ?? 0
            self.pages = photosObj[APIConstants.pages] as? Int ?? 0
            self.perpage = photosObj[APIConstants.perpage] as? Int ?? 30
            self.total = Int(photosObj[APIConstants.total] as? String ?? "0")!
            guard let photosArray = photosObj[APIConstants.photo] as? [[String:Any]] else {return completionHandler(false)}
            // If the photos array is empty or less than page value, then adding an empty array into it, so that in the next line we can access it.
            if (self.photos.count == 0) || (self.photos.count < self.page) {
                self.photos.append([])
            }
            self.photos[self.page - 1] = PhotoDetails.makeArrayOfPhotoDetailsModelFrom(photoDetailsArray: photosArray)
             completionHandler(true)
        }) { (error) in
            print(error?.localizedDescription ?? "Error occurred")
             completionHandler(false)
        }
        task?.resume()
    }
}

//This Struct will hold the details of each photo object, which will be used to form imageURL.
struct PhotoDetails {
    var id = ""
    var owner = ""
    var secret = ""
    var server = ""
    var farm = 0
    var title = "title"
    var ispublic = true
    var isfriend = false
    var isfamily = false
    
    init(photoDetails: [String: Any]) {
        self.id = photoDetails[APIConstants.id] as? String ?? ""
        self.owner = photoDetails[APIConstants.owner] as? String ?? ""
        self.secret = photoDetails[APIConstants.secret] as? String ?? ""
        self.server = photoDetails[APIConstants.server] as? String ?? ""
        self.farm = photoDetails[APIConstants.farm] as? Int ?? 0
        self.title = photoDetails[APIConstants.title] as? String ?? ""
        self.ispublic = photoDetails[APIConstants.ispublic] as? Bool ?? true
        self.isfriend = photoDetails[APIConstants.isfriend] as? Bool ?? false
        self.isfamily = photoDetails[APIConstants.isfamily] as? Bool ?? false
    }
    
    static func makeArrayOfPhotoDetailsModelFrom(photoDetailsArray: [[String: Any]]) -> [PhotoDetails] {
        var photoArr = [PhotoDetails]()
        for photo in photoDetailsArray {
            let photoDetails = PhotoDetails(photoDetails: photo)
            photoArr.append(photoDetails)
        }
        return photoArr
    }
    
    func getImageUrlString() -> String {
        let urlStr = "https://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
        return urlStr
    }
}
