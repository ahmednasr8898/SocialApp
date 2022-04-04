//
//  HomeTableViewCell.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/7/20.
//
import UIKit
import Kingfisher
import FirebaseAuth

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postUIView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var numOfLoveLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var descriptionPostLabel: UILabel!
    var addLoveToPost: (()->())?
    var whoLovePost: (()->())?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loveButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpDesign()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToWhoLovePost))
        postUIView.addGestureRecognizer(tapGesture)
    }
    @objc func goToWhoLovePost() {
        whoLovePost?()
    }
    
    func setUpDesign(){
        postUIView.backgroundColor = .white
        postUIView.layer.cornerRadius = 10.0
        postUIView.layer.shadowColor = UIColor.gray.cgColor
        postUIView.layer.shadowOffset = CGSize(width: 0.0, height: 3)
        postUIView.layer.shadowRadius = 2.0
        postUIView.layer.shadowOpacity = 0.7
        userImageView.layer.cornerRadius = 40
        userImageView.clipsToBounds = true
    }
    var getPhotoImagePost: PostsModel!{
        didSet{
            guard let photo = getPhotoImagePost else { return }
            //download photos using kingfisher
            self.postImageView.kf.indicatorType = .activity
            if let url = URL(string: photo.imagePost){
                self.postImageView.kf.setImage(with: url)
            }
        }
    }
    
    @IBAction func didPressedOnLoveButton(_ sender: UIButton) {
        addLoveToPost?()
    }
}
