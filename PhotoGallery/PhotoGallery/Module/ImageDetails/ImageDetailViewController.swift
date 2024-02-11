//
//  ImageDetailViewController.swift
//  PhotoGallery
//
//  Created by apple on 10/02/24.
//

import UIKit

protocol PhotoDetailDelegate {
     func deletePhoto(imageId: Int)
     func saveToGallery(imageUrl: String)
}

class ImageDetailViewController: UIViewController {
    
    // MARK: All Outlets
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    // MARK: All Properties
    var data: Photos?
    var delegate: PhotoDetailDelegate?
    var recordId: Int = 0
    
    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setData()
        self.navigationItem.title = "Detail View"
    }
    
    // MARK: Custom Functions
    func setupUI() {
        imgView.layer.cornerRadius = 10
        btnDelete.layer.cornerRadius = 8
        btnDownload.layer.cornerRadius = 8
    }
    
    func setData() {
        if let data = data {
            imgView.setImage(withImageId: data.url ?? "", placeholderImage: #imageLiteral(resourceName: "placeholder"), size: .original)
            lblTitle.text = data.title
            lblDescription.text = data.description
        }
    }
    
    @IBAction func tapDownload(sender: UIButton) {
        delegate?.saveToGallery(imageUrl: data?.url ?? "")
    }
    
    @IBAction func tapDelete(sender: UIButton) {
        // To Delete the image
        delegate?.deletePhoto(imageId: recordId)
    }
}
