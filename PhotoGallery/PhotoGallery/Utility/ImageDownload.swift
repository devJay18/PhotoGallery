//
//  ImageDownload.swift
//  PhotoGallery
//
//  Created by apple on 10/02/24.
//

import Foundation
import UIKit

private var activityIndicatorAssociationKey: UInt8 = 0

let imageCache = NSCache<AnyObject, AnyObject>()

enum ImageSize {
    case original
    case thumbnail
}

extension UIImageView {
    
    func setImage(withImageId imageId: String, placeholderImage: UIImage, size: ImageSize = .original) {
        
        
        var urlString: String!
        urlString = imageId
        cacheImage(urlString: urlString, placeholder: placeholderImage)
    }
    
    var activityIndicator: UIActivityIndicatorView! {
        get {
            return objc_getAssociatedObject(self, &activityIndicatorAssociationKey) as? UIActivityIndicatorView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &activityIndicatorAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    
    func cacheImage(urlString: String, placeholder: UIImage) {
        
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        let urlwithPercent = urlString.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        if urlString != "" {
            var urlRequest = URLRequest(url: URL(string: urlwithPercent!)!)
            
            //common headers
            urlRequest.setValue(ContentType.ENUS.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptLangauge.rawValue)
            urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
            urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            
            self.image = placeholder
            URLSession.shared.dataTask(with: urlRequest) {data, _, _ in
                if data != nil {
                    DispatchQueue.main.async {
                        let imageToCache = UIImage(data: data!)
                        if imageToCache != nil {
                            imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                            self.image = imageToCache
                        }
                    }
                }
            }.resume()
        }
    }
}
enum ContentType: String {
    case json            = "application/json"
    case multipart       = "multipart/form-data"
    case ENUS            = "en-us"
}
enum HTTPHeaderField: String {
    case authentication  = "Authorization"
    case contentType     = "Content-Type"
    case acceptType      = "Accept"
    case acceptEncoding  = "Accept-Encoding"
    case acceptLangauge  = "Accept-Language"
}
