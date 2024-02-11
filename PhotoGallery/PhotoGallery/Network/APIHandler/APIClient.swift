//
//  APIHandler.swift
//  PhotoGallery
//
//  Created by apple on 10/02/24.
//

import Foundation
import UIKit

class APIClient {
    
    static let sharedInstance = APIClient()
    
    // MARK: Get Forecast Details API
    func getImageDataApiCalling(
        url: String,
        offset: Int, // For offset the data records in image API response
        method: APIMethod,
        completion: @escaping(Result<ImagesResponseModel, Error>) -> Void
    ) {
        var urlBuilder = URLComponents(string: url)
        urlBuilder?.queryItems = [
            URLQueryItem(name: "offset", value: "\(offset)")
        ]
        guard let url = urlBuilder?.url else { return }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Call dataTask method
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let imagesResponse = try JSONDecoder().decode(ImagesResponseModel.self, from: data)
                    debugPrint("Success: Get Image API Response")
                    completion(.success(imagesResponse))
                } catch let error {
                    debugPrint("Error: \(error)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    // MARK: To download and Convert Image URL to UIImage type
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to load image:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Invalid image data")
                completion(nil)
            }
        }
        task.resume()
    }
}
