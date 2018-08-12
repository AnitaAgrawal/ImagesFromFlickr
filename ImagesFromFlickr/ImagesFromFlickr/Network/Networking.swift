//
//  Networking.swift
//  ImagesFromFlickr
//
//  Created by Anita Agrawal on 07/08/18.
//  Copyright © 2018 Anita Agrawal. All rights reserved.
//

import Foundation
import UIKit

/**
 *This class takes care of server calls, getting photos for searched string.
 */

typealias CompletionHandler = (_ result:Result) -> Void

enum HTTPMethod: String {
    case get = "get"
    case post = "post"
    case put = "put"
    case delete = "delete"
}
/** Status code
- 1xx: Informational - Request received, continuing process

- 2xx: Success - The action was successfully received,
understood, and accepted

- 3xx: Redirection - Further action must be taken in order to
complete the request

- 4xx: Client Error - The request contains bad syntax or cannot
be fulfilled

- 5xx: Server Error - The server failed to fulfill an apparently
valid request
*/
enum ErrorHandling: Error {
    case noInternetConnection
    case dataFoundNil
    case jsonSerializationFailed
    case internalServerError
    case clientError
    case temporarilyUnavailable
}

enum Result {
    case success([String: Any])
    case failure(ErrorHandling)
}

class ConnectionManager {
    static var manager:RequestState = .live
    
    class func makeHTTPRequest(url:String, apiMethod : HTTPMethod = .get, queryParameters:[String:Any], bodyParameters:[String:Any], completionHandler:@escaping CompletionHandler) -> URLSessionDataTask? {
        
        var path = "\(APIKeys.BaseURL)\(url)&api_key=\(APIKeys.ApiKey)&format=json&nojsoncallback=1&safe_search=1"
        
        queryParameters.forEach { (arg) in
            let (key, value) = arg
            path.append("&\(key)=\(value)")
        }
        
        guard let pathEncodedString = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let pathURL = URL(string: pathEncodedString) else {
            return nil
        }
        //Enabling Network Activity indicator on Status bar
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let task = manager.session.dataTask(with: pathURL) { (data, response, error) in
            //Disabling Network Activity indicator on Status bar, after getting response
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                if error?.localizedDescription == "cancelled" {//old request has been cancelled as new request had been initiated
                    return
                }
                completionHandler(Result.failure(ErrorHandling.internalServerError))
                return
            }
            if (400...499).contains(httpResponse.statusCode) {
                completionHandler(Result.failure(ErrorHandling.clientError))
                return
            } else if (500...599).contains(httpResponse.statusCode) {
                completionHandler(Result.failure(ErrorHandling.internalServerError))
                return
            }
            if error != nil {
                completionHandler(Result.failure(ErrorHandling.temporarilyUnavailable))
            }
            guard let data = data else {
                completionHandler(Result.failure(ErrorHandling.dataFoundNil))
                return
            }
            
            do {
                guard let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    completionHandler(Result.failure(ErrorHandling.jsonSerializationFailed))
                    return
                }
                completionHandler(Result.success(jsonResponse))
            } catch {
                print("didnt work")
                completionHandler(Result.failure(ErrorHandling.jsonSerializationFailed))
            }
        }
        return task
    }
}
