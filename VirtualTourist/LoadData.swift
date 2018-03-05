//
//  LoadData.swift
//  VirtualTourist
//
//  Created by Rohan Bardekar on 18/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import Foundation

final class DataLoader {
    
    var session = URLSession.shared
    
    func taskOnGetRequest(parameters: [String:AnyObject], getRequestCompletionHandler: @escaping (_ result: [String:AnyObject]?, _ error: String?) -> Void) -> URLSessionDataTask {
        
        let requestParameter = parameters
        let request = NSMutableURLRequest(url: flickrURLBuilder(requestParameter, withPathExtension: nil))
    
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                
                getRequestCompletionHandler(nil, error)
            }
            
            guard (error == nil) else {
                sendError(Error.request + error!.localizedDescription)
                return
            }
            
            guard let data = data else {
                sendError(Error.data)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(Error.statusCode)
                return
            }
            
           self.convertDataCompletionHandler(data, dataCompletionHandler: getRequestCompletionHandler)
        }
        
        task.resume()
        return task
    }
    
    private func flickrURLBuilder(_ parameters: [String:AnyObject], withPathExtension: String?) -> URL {
        
        var components = URLComponents()
        components.scheme = Flickr.Scheme
        components.host = Flickr.Host
        components.path = Flickr.Path + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        
        return components.url!
    }
    
    func getFlickrImages(_ photo: Photo?, getFlickrImageCompletionHandler: @escaping (_ success: Bool, _ errorString: String?, _ imageData: Data?) -> Void) -> URLSessionTask {
        
        let flickrURL = photo?.stringURL
        let requestURL = URL(string: flickrURL!)
        let request = URLRequest(url: requestURL!)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                
                getFlickrImageCompletionHandler(false, error.localizedDescription, nil)
            }
            else {
                
                getFlickrImageCompletionHandler(true, nil, data)
            }
        }
        
        task.resume()
        return task
    }
    
    func getPhotosUsingFlickr(_ pin: Pin?, getFlikerPhotosCompletionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        guard pin != nil else {
            getFlikerPhotosCompletionHandler(false, Error.pinCompletion)
            return
        }
        
        let parameters: [String:AnyObject]? = [
            
            ParameterKey.method: Flickr.UrlForSearch as AnyObject,
            ParameterKey.APIKey: Flickr.ApiKey as AnyObject,
            ParameterKey.safeSearch: ParameterValue.safeSearch as AnyObject,
            ParameterKey.latitude: pin?.coordinate.latitude as AnyObject,
            ParameterKey.longitude: pin?.coordinate.longitude as AnyObject,
            ParameterKey.radius: ParameterValue.radius as AnyObject,
            ParameterKey.extras: ParameterValue.extras as AnyObject,
            ParameterKey.format: ParameterValue.json as AnyObject,
            ParameterKey.noJSONCallback: ParameterValue.disableJSONCallback as AnyObject
        ]
        
        var numberOfPagesFromRequest: Int?
        var totalNumberOfPages: Int?
        
        let _ = taskOnGetRequest(parameters: parameters!) { (results, error) in
            
            
            guard let photosDictionary = results?[ResponseKey.photos] as? [String:AnyObject], let numberOfPages = photosDictionary[ResponseKey.pages] as? Int, let totalPerPage = photosDictionary[ResponseKey.perPage] as? Int else {
                print(NetworkError.numberPage)
                getFlikerPhotosCompletionHandler(false, NetworkError.download)
                return
            }
            
            guard let status = results?[ResponseKey.stat] as? String, status == ResponseValue.ok else {
                print(NetworkError.status)
                getFlikerPhotosCompletionHandler(false, NetworkError.statusCompletion)
                return
            }
            
            guard (error == nil) else {
                print(NetworkError.base)
                getFlikerPhotosCompletionHandler(false, NetworkError.flickr)
                return
            }
            
            numberOfPagesFromRequest = numberOfPages
            totalNumberOfPages = Int(totalPerPage)
            let numberOfPhotos = min(totalNumberOfPages!, 21)
            let pageLimit = min(numberOfPagesFromRequest!, 50)
            let randomPage = Int(arc4random_uniform(UInt32(pageLimit))) + 1
            self.getPhotosUsingPage(pin, randomPage: randomPage, perPage: numberOfPhotos, getPagePhotoCompletionHandler: getFlikerPhotosCompletionHandler)
        }
    }
    
    private func getPhotosUsingPage(_ pin: Pin?, randomPage: Int?, perPage: Int?, getPagePhotoCompletionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        guard pin != nil else {
            getPagePhotoCompletionHandler(false, Error.pageCompletion)
            return
        }
        
        let parameters: [String:AnyObject]? = [
            
            ParameterKey.method: Flickr.UrlForSearch as AnyObject,
            ParameterKey.APIKey: Flickr.ApiKey as AnyObject,
            ParameterKey.safeSearch: ParameterValue.safeSearch as AnyObject,
            ParameterKey.latitude: pin?.coordinate.latitude as AnyObject,
            ParameterKey.longitude: pin?.coordinate.longitude as AnyObject,
            ParameterKey.radius: ParameterValue.radius as AnyObject,
            ParameterKey.extras: ParameterValue.extras as AnyObject,
            ParameterKey.format: ParameterValue.json as AnyObject,
            ParameterKey.noJSONCallback: ParameterValue.disableJSONCallback as AnyObject,
            ParameterKey.page: randomPage as AnyObject,
            ParameterKey.perPage: perPage as AnyObject
        ]
        
        let _ = self.taskOnGetRequest(parameters: parameters!) { (results, error) in
            
            guard let status = results?[ResponseKey.stat] as? String, status == ResponseValue.ok else {
                print(NetworkError.status)
                getPagePhotoCompletionHandler(false, NetworkError.statusCompletion)
                return
            }
            
            guard (error == nil) else {
                print(NetworkError.base)
                getPagePhotoCompletionHandler(false, error)
                return
            }
            
            guard let photosDictionary = results?[ResponseKey.photos] as? [String:AnyObject], let photoArrayDictionary = photosDictionary[ResponseKey.photo] as? [[String:AnyObject]] else {
                print(NetworkError.parsing)
                getPagePhotoCompletionHandler(false, NetworkError.download)
                return
            }
            
            for photoDictionary in photoArrayDictionary {
                let photo = Photo(dictionary: photoDictionary, context: AppDelegate.coreDataStack.context)
                photo.pin = pin
            }
            
            getPagePhotoCompletionHandler(true, nil)
        }
    }
    
    private func convertDataCompletionHandler(_ data: Data, dataCompletionHandler: (_ result: [String:AnyObject]?, _ error: String?) -> Void) {
        
        var parsedResult: [String:AnyObject]?
        do {
            
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
        }
        catch {
            
            dataCompletionHandler(nil, Error.serialize)
        }
        
        dataCompletionHandler(parsedResult, nil)
    }
   
    class func sharedInstance() -> DataLoader {
        
        struct Singleton {
            
            static var sharedInstance = DataLoader()
        }
        
        return Singleton.sharedInstance
    }
}
