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
        userImageView.layer.cornerRadius =  40
        userImageView.clipsToBounds = true
    }
}
