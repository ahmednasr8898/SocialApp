//
//  WhoLovePostTableViewCell.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/12/20.
//
import UIKit
import Kingfisher
class WhoLovePostTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var getPhoto: WhoLovePostModel!{
        didSet{
            guard let photo = getPhoto else { return }
            //download photos using kingfisher
            self.userImageView.kf.indicatorType = .activity
            if let url = URL(string: photo.profilePicture){
                self.userImageView.kf.setImage(with: url)
            }
        }
    }
}
