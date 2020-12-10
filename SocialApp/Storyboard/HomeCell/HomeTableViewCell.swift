//
//  HomeTableViewCell.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/7/20.
//
import UIKit
import Kingfisher
import FirebaseDatabase
class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postUIView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var numOfLoveLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var descriptionPostLabel: UILabel!
    
    let ref = Database.database().reference()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpDesign()
    }
    func setUpDesign(){
        postUIView.backgroundColor = .white
        postUIView.layer.cornerRadius = 10.0
        postUIView.layer.shadowColor = UIColor.gray.cgColor
        postUIView.layer.shadowOffset = CGSize(width: 0.0, height: 3)
        postUIView.layer.shadowRadius = 2.0
        postUIView.layer.shadowOpacity = 0.7
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    var getPhoto: PostsModel!{
        didSet{
            guard let photo = getPhoto else { return }
            //download photos using kingfisher
            self.postImageView.kf.indicatorType = .activity
            if let url = URL(string: photo.imagePostL){
                self.postImageView.kf.setImage(with: url)
            }
        }
    }
}
