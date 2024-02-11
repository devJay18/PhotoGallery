
//
// ImageListViewModel.swift
// PhotoGallery
//
// Created by apple on 10/02/24.
//

import Foundation

class ImageListViewModel {
    
    // MARK: All Properties
    var offset: Int = 0
    var arrImageResponseModel: [Photos]?
    
    // MARK: Custom Functions
    func getImageDataApiCalling(isSuccess: @escaping (Bool) -> Void) {
        APIClient.sharedInstance.getImageDataApiCalling(
            url: APIEndPoints.getImageData.rawValue,
            offset: offset,
            method: .get
        ) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let imageData):
                self.arrImageResponseModel = imageData.photos
                self.saveAllDataIntoDB(records: self.arrImageResponseModel ?? [])
                isSuccess(true)
            case .failure(let failure):
                debugPrint("failure\(failure)")
                isSuccess(false)
            }
        }
    }
    func saveAllDataIntoDB(records: [Photos]) {
        records.forEach { data in
            CoreDataManager.shared.saveData(photoModel: data)
        }
    }
    func getDataFromDB(callBack: (() -> Void)) {
        arrImageResponseModel = []
        let data = CoreDataManager.shared.getAllData()
        data.forEach { record in
            arrImageResponseModel?.append(
                    Photos(url: record.imageUrl,
                           title: record.title,
                           id: Int(record.imageId),
                           description: record.imageDescription,
                           isLike: record.isLike)
                )
        }
        // Callback for refresh the list after fetch data from DB
        callBack()
    }
    func getLikedImagesRecord() -> [Photos] {
        var arrLikedImages = [Photos]()
        arrLikedImages = arrImageResponseModel?.filter { $0.isLike == true } ?? []
        return arrLikedImages
    }
}
