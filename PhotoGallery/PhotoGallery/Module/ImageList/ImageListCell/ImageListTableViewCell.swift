//
//  ImageListTableViewCell.swift
//  PhotoGallery
//
//  Created by apple on 10/02/24.
//

import UIKit


class ImageListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgUrl: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var leftButtonUnlike: UIButton!
    @IBOutlet weak var rightButtonLike: UIButton!
    
    var leftUnlikeDidTapped: () -> Void = {}
    var rightLikeDidTapped: () -> Void = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        imgUrl.layer.cornerRadius = 8
        imgUrl.contentMode = .scaleToFill
        self.addSwipeGesture()
    }
    
    func addSwipeGesture() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action:#selector(swipe(sender: )))
        leftSwipe.direction = .left
        self.mainView.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action:#selector(swipe(sender: )))
        rightSwipe.direction = .right
        self.mainView.addGestureRecognizer(rightSwipe)
    }
    
    @objc func swipe(sender:AnyObject)
    {
        let swipeGesture: UISwipeGestureRecognizer = sender as! UISwipeGestureRecognizer
        if(swipeGesture.direction == .left) {
            var frame: CGRect = self.mainView.frame
            frame.origin.x = -leftButtonUnlike.frame.width
            self.mainView.frame = frame
        }
        else if(swipeGesture.direction == .right) {
            var frame:CGRect = self.mainView.frame
            frame.origin.x = +rightButtonLike.frame.width
            self.mainView.frame = frame
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.frameUpdate()
        }
    }
    
    func frameUpdate() {
        self.mainView.frame.origin.x = 5
        self.layoutIfNeeded()
    }

    func configureData(_ data: Photos) {
        lblTitle.text = data.title
        self.imgUrl.setImage(withImageId: data.url ?? "", placeholderImage: #imageLiteral(resourceName: "placeholder"), size: .original)
        btnLike.setImage(UIImage(named: (data.isLike ?? false) ? "Like_ip" : "heart"), for: .normal)
    }
    
    @IBAction func likeImage(_ sender: UIButton) {
        self.frameUpdate()
        rightLikeDidTapped()
    }
    
    @IBAction func UnlikeImage(_ sender: UIButton) {
        self.frameUpdate()
        leftUnlikeDidTapped()
    }
}

