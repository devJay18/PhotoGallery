//
//  ImageEntity+CoreDataProperties.swift
//  PhotoGallery
//
//  Created by apple on 11/02/24.
//
//

import Foundation
import CoreData


extension ImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged public var imageId: Int32
    @NSManaged public var imageUrl: String?
    @NSManaged public var isLike: Bool
    @NSManaged public var title: String?
    @NSManaged public var imageDescription: String?

}

extension ImageEntity : Identifiable {

}
