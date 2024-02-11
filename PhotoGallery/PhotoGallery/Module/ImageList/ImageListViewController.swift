//
//  ImageListViewController.swift
//  PhotoGallery
//
//  Created by apple on 10/02/24.
//

import UIKit
import Photos

class ImageListViewController: UIViewController {
    
    // MARK: All Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: All Properties
    var refreshControl = UIRefreshControl()
    var viewModel: ImageListViewModel = ImageListViewModel()

    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        tableViewSetup()
        refreshControlUI()
        self.navigationItem.title = "Images List"
    }
    
    // MARK: Custom Functions
    func setupData() {
        if CoreDataManager.shared.isDataBaseEmpty() {
            getImageDataApiCalling()
        } else {
            viewModel.getDataFromDB {
                print("reload")
                tableView.reloadData()
            }
        }
    }
    func getImageDataApiCalling() {
        viewModel.getImageDataApiCalling { isSuccess in
            if isSuccess {
                DispatchQueue.main.async {
                    print("reload")
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func refreshControlUI() {
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.tintColor = .lightGray
    }
    
    @objc func refresh(_ sender: AnyObject) {
        print("refresh")
        // Here we clear the DB and get new data from API
        CoreDataManager.shared.clearDataBase()
        getImageDataApiCalling()
        refreshControl.endRefreshing()
    }
    
    func tableViewSetup(){
        tableView.addSubview(refreshControl)
        tableView.register(UINib(nibName: "ImageListTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageListTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func tapLiked(sender: UIButton) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "LikedImagesViewController") as! LikedImagesViewController
        self.navigationController?.pushViewController(view,animated: true)
        view.viewModel.arrLikedImages = viewModel.getLikedImagesRecord()
        print("DataPath : ",FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }
    @objc func btnLikeAction(_ sender: UIButton) {
        print("like sender.tag", sender.tag)
        updateLikeInDB(index: sender.tag)
    }
    func updateLikeInDB(index: Int,
                        isForLike: Bool = false,
                        isForDislike: Bool = false) {
        CoreDataManager.shared.updateLikeInDB(
            imageId: viewModel.arrImageResponseModel?[index].id ?? 0,
            isForLike: isForLike,
            isForDislike: isForDislike,
            completion: { isUpdated in
                if isUpdated {
                    if isForLike {
                        viewModel.arrImageResponseModel?[index].isLike = true
                    } else if isForDislike {
                        viewModel.arrImageResponseModel?[index].isLike = false
                    } else {
                        viewModel.arrImageResponseModel?[index].isLike?.toggle()
                    }
                    tableView.reloadData()
                }
            }
        )
    }
}

// MARK: Table View Delegate and Data Source Methods
extension ImageListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrImageResponseModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageListTableViewCell", for: indexPath) as! ImageListTableViewCell
        cell.selectionStyle = .none
        // Updating tags of cell's button
        cell.btnLike.tag = indexPath.row
        cell.leftButtonUnlike.tag = indexPath.row
        cell.rightButtonLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(self.btnLikeAction(_:)), for: .touchUpInside)
        // Action event of swipe gesture's buttons
        cell.rightLikeDidTapped = {
            print("right", indexPath.row)
            self.updateLikeInDB(index: indexPath.row, isForLike: true)
        }
        cell.leftUnlikeDidTapped = {
            print("left", indexPath.row)
            self.updateLikeInDB(index: indexPath.row, isForDislike: true)
        }
        // Data configuration of cell
        if let data = viewModel.arrImageResponseModel?[indexPath.row] {
            cell.configureData(data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        if let data = viewModel.arrImageResponseModel?[indexPath.row] {
            view.data = data
            view.recordId = indexPath.row
            view.delegate = self
        }
        view.delegate = self
        self.navigationController?.pushViewController(view,animated: true)
    }
}
// MARK: Implementation of Protocol's Methods
// For perform the delete and save actions by Protocol (Delegates)
extension ImageListViewController: PhotoDetailDelegate {
    func deletePhoto(imageId: Int) {
        CoreDataManager.shared.deleteRecordById(
            imageId: Int32(viewModel.arrImageResponseModel?[imageId].id ?? 0)) { isRecordDeleted in
                if isRecordDeleted {
                    viewModel.arrImageResponseModel?.remove(at: imageId)
                    tableView.reloadData()
                    DispatchQueue.main.async {
                        self.showAlertController(
                            title: "Deleted",
                            message: "The image has been deleted successfully!"
                        ) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
    }
    
    func saveToGallery(imageUrl: String) {
        // To download the image and save in gallery
        APIClient.sharedInstance.loadImage(from: imageUrl) { image in
            UIImageWriteToSavedPhotosAlbum(image ?? UIImage(), nil, nil, nil)
            DispatchQueue.main.async {
                self.showAlertController(
                    title: "Success",
                    message: "The image has been downloaded successfully!"
                ) { }
            }
        }
    }
}
