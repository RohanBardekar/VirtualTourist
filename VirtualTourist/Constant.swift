//
//  Constant.swift
//  VirtualTourist
//
//  Created by Rohan Bardekar on 18/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import Foundation

struct Flickr {
    
    static let ApiKey = "e4126fc50e2d2fa94e5d441c0fc5c3d8"
    static let ApiSecret = "82be7f90f9760fd7"
    static let UrlForSearch = "flickr.photos.search"
    static let Scheme = "https"
    static let Host = "api.flickr.com"
    static let Path = "/services/rest/"
}

struct Identifier {
    
    static let photoCollection = "photoCollection"
    static let photoViewCell = "PhotoViewCell"
}

struct ReuseId {
    
    static let pin = "pin"
}

struct ImageName {
    
    static let flickr = "flickr"
}

struct Constant {
    
    static let id = "id"
    static let urlM = "url_m"
    static let region = "region"
    static let format = "pin == %@"
    static let pinError = "Could not find entity Pin"
    static let photoError = "Could not find entity Photo"
    static let pin = "Pin"
    static let photo = "Photo"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let latitudeDelta = "latitudeDelta"
    static let longitudeDelta = "longitudeDelta"

}

struct ParameterKey {
    
    static let method = "method"
    static let APIKey = "api_key"
    static let safeSearch = "safe_search"
    static let latitude = "lat"
    static let longitude = "lon"
    static let radius = "radius"
    static let format = "format"
    static let extras = "extras"
    static let page = "page"
    static let perPage = "per_page"
    static let noJSONCallback = "nojsoncallback"
    
}

struct ParameterValue {
    
    static let safeSearch = "1"
    static let radius = "5"
    static let extras = "url_m"
    static let json = "json"
    static let disableJSONCallback = "1"
}

struct ResponseKey {
   
    static let stat = "stat"
    static let photo = "photo"
    static let photos = "photos"
    static let id = "id"
    static let mediumURL = "url_m"
    static let pages = "pages"
    static let perPage = "perpage"
}

struct NetworkError {
    
    static let base = "Error in fetching Flickr photos"
    static let flickr = "Error in retrieving photos from Flickr"
    static let parsing = "Error parsing photos"
    static let download = "Error to download photos from Flickr"
    static let status = "Status error in getting Flickr photo"
    static let statusCompletion = "Status code error from Flickr"
    static let numberPage = "Error parsing photos for page number"
  
}

struct ResponseValue {
    
    static let ok = "ok"
}

struct Animation {
    
    struct TimeDuration {
        static let medium = 0.5
    }
}

struct ButtonTitle {
    
    static let deletePhoto = "Delete Selected Images"
    static let newCollection = "New Collection"
}

struct Error {
    
    static let request = "Error on the request: "
    static let data = "No data returned by the request"
    static let statusCode = "Request returned a status code other than 2xx"
    static let pin = "Failed to acquire pin value for photo search"
    static let cell = "Failed to configure cell"
    static let pinCompletion = "Failed to complete photo search with pin"
    static let pageCompletion = "Failed to complete photo search with page"
    static let serialize = "Serialization from JSON failed"
    static let getImage = "Failed to  get the image in cell"
}






