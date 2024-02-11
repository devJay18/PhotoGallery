//
//  CoreDataManager.swift
//  PhotoGallery
//
//  Created by Apple on 10/02/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    // MARK: All Properties
    let persistentContainer : NSPersistentContainer
    static let shared = CoreDataManager()
    private init() {
        persistentContainer = NSPersistentContainer(name: "PhotoGallery")
        persistentContainer.loadPersistentStores {(description, error) in
            if let error = error {
                fatalError("Failed to Store \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Function for save Image
    func saveData(photoModel: Photos) {
        let employee = ImageEntity(context: persistentContainer.viewContext)
        employee.imageUrl = photoModel.url
        employee.isLike = photoModel.isLike ?? false
        employee.title = photoModel.title
        employee.imageDescription = photoModel.description
        employee.imageId = Int32(photoModel.id ?? 0)
        do {
            print("DataPath : ",FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save employee data\(error)")
        }
    }
    
    // MARK: Function for get Image
    func getAllData() -> [ImageEntity] {
        let fetchRequest : NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Error occured while fetching data\(error.localizedDescription)")
            return []
        }
    }
    func isDataBaseEmpty() -> Bool {
        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ImageEntity")
            let count  = try persistentContainer.viewContext.count(for: fetchRequest)
            return count == 0
        } catch {
            return true
        }
    }
    func deleteRecordById(imageId: Int32, callback: (Bool) -> Void) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ImageEntity")
        fetchRequest.predicate = NSPredicate(format: "imageId == %@", "\(imageId)")
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            if let recordToDelete = results.first {
                persistentContainer.viewContext.delete(recordToDelete)
                // Save the changes
                try persistentContainer.viewContext.save()
                debugPrint("Record deleted Id: \(imageId)")
                callback(true)
            } else {
                debugPrint("Record not found: \(imageId)")
                callback(false)
            }
        } catch {
            debugPrint("Error deleting record: \(error)")
            callback(false)
        }
    }
    func clearDataBase() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistentContainer.viewContext.execute(batchDeleteRequest)
            try persistentContainer.viewContext.save()
            debugPrint("Core data, Delete all Data Successfully")
        } catch {
            debugPrint("Error deleting all data: \(error)")
        }
    }
    func updateLikeInDB(
        imageId: Int,
        isForLike: Bool = false,
        isForDislike: Bool = false,
        completion: (Bool) -> Void
    ) {
        // Get object from DB through image id
        if let data = self.fetchRecordByImageId(imageId: "\(imageId)") {
            if isForLike {
                data.isLike = true
            } else if isForDislike {
                data.isLike = false
            } else {
                data.isLike.toggle()
            }
            do {
                try persistentContainer.viewContext.save()
                debugPrint("Like/dislike Status updated")
                completion(true)
            } catch {
                debugPrint("Error:", error)
                completion(false)
            }
        }
    }
    func fetchRecordByImageId(imageId: String) -> ImageEntity? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ImageEntity")
        fetchRequest.predicate = NSPredicate(format: "imageId == %@", "\(imageId)")
        do {
            // Fetch the records that match the predicate
            let records = try persistentContainer.viewContext.fetch(fetchRequest)
            return records.first as? ImageEntity
        } catch {
            debugPrint("Error fetching record: \(error)")
            return nil
        }
    }
}

