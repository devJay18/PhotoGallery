//
//  ImagesResponseModel.swift
//  PhotoGallery
//
//  Created by Apple on 10/02/24.
//

import Foundation

// MARK: - ImagesResponseModel
struct ImagesResponseModel: Codable {
    var success: Bool?
    var totalPhotos: Int?
    var message: String?
    var offset, limit: Int?
    var photos: [Photos]?

    enum CodingKeys: String, CodingKey {
        case success
        case totalPhotos = "total_photos"
        case message, offset, limit, photos
    }
}

// MARK: - Photo
struct Photos: Codable {
    var url: String?
    var user: Int?
    var title: String?
    var id: Int?
    var description: String?
    var isLike: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case url
        case user
        case title, id, description
    }
}
