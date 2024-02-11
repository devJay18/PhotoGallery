//
//  LikedImageTableViewCell.swift
//  PhotoGallery
//
//  Created by apple on 11/02/24.
//

import UIKit

class LikedImageTableViewCell: UITableViewCell {

    // MARK: All Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgUrl: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgUrl.layer.cornerRadius = 8
        imgUrl.contentMode = .scaleToFill
    }
    func configureData(_ data: Photos) {
        lblTitle.text = data.title
        self.imgUrl.setImage(withImageId: data.url ?? "", placeholderImage: #imageLiteral(resourceName: "placeholder"), size: .original)
    }
    
}
