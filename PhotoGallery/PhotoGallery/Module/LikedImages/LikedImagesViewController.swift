//
//  LikedImagesViewController.swift
//  PhotoGallery
//
//  Created by apple on 10/02/24.
//

import UIKit

class LikedImagesViewController: UIViewController {

    // MARK: All Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: All Properties
    var viewModel = LikedImagesViewModel()
    
    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        self.navigationItem.title = "Liked Images"
    }
        
    // MARK: Custom Functions
    func tableViewSetup() {
        tableView.register(UINib(nibName: "LikedImageTableViewCell", bundle: nil), forCellReuseIdentifier: "LikedImageTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: Table View Delegate and Data Source Methods
extension LikedImagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrLikedImages.count == 0 ? 1 : viewModel.arrLikedImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikedImageTableViewCell", for: indexPath) as! LikedImageTableViewCell
        if viewModel.arrLikedImages.count == 0 {
            cell.imgUrl.isHidden = true
            cell.lblTitle.text = "No Liked Images"
            cell.lblTitle.textAlignment = .center
        } else {
            cell.selectionStyle = .none
            cell.configureData(viewModel.arrLikedImages[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

