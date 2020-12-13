//
//  HomeTableViewCell.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/7/20.
//
import UIKit
import Kingfisher
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
class HomeTableViewCell: UITableViewCell {
    
    //MARK:- check if current user love post (love button is red and in selected mode)
    
    @IBOutlet weak var postUIView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var numOfLoveLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var descriptionPostLabel: UILabel!
    @IBOutlet weak var whoLovePostButton: UIButton!
    
    let ref = Database.database().reference()
    let storage = Storage.storage().reference()
    var postID: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpDesign()
        loveButton.addTarget(self, action: #selector(loveButtonPressed(sender:)), for: .touchUpInside)
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
    var getPhotoPostPublisherProfile: PostsModel!{
        didSet{
            guard let photo = getPhotoPostPublisherProfile else { return }
            //download photos using kingfisher
            self.userImageView.kf.indicatorType = .activity
            if let url = URL(string: photo.postPublisherProfile){
                self.userImageView.kf.setImage(with: url)
            }
        }
    }
    @IBAction func loveButtonPressed(sender: UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            //love is red
            sender.setImage(UIImage(named: "like"), for: .normal)
            //append 1 to love score in database and labelLove
            guard let postID = postID, let userID = Auth.auth().currentUser?.uid else {return}
            getCurrentUserInformation { (name, profilePictureUrl) in
                self.ref.child("AllPosts").child(postID).child("WhoLovePost").child(Auth.auth().currentUser!.uid).setValue(["UserID": userID, "Name": name, "profilePicture": profilePictureUrl])
                self.getNumberOfLove { (countOfLove) in
                    let newCount = countOfLove + 1
                    self.numOfLoveLabel.text = String(newCount)
                    self.ref.child("AllPosts").child(postID).updateChildValues(["Love": newCount])
                }
            }
        }else{
            //love is white
            sender.setImage(UIImage(named: "unlike"), for: .normal)
            //remove 1 to love score in database and labelLove
            guard let postID = postID, let userID = Auth.auth().currentUser?.uid else {return}
            self.ref.child("AllPosts").child(postID).child("WhoLovePost").child(userID).removeValue()
            self.getNumberOfLove { (countOfLove) in
                let newCount = countOfLove - 1
                self.numOfLoveLabel.text = String(newCount)
                self.ref.child("AllPosts").child(postID).updateChildValues(["Love": newCount])
            }
        }
    }
    func getNumberOfLove(comlation: @escaping (_ numberOFLove: Int)->Void){
        guard let postID = self.postID else {return}
        ref.child("AllPosts").child(postID).observeSingleEvent(of: .value) { (dataSnapshot) in
            if let value = dataSnapshot.value as? [String: Any]{
                guard let numOfLove = value["Love"] as? Int else {return}
                comlation(numOfLove)
            }
        }
    }
    func getCurrentUserInformation(complation: @escaping (_ name: String,_ profilePictureUrl: String)-> Void){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        ref.child("Users").child(userID).child("PersonalInformation").observeSingleEvent(of: .value) { (datasnap) in
            if let value = datasnap.value as? [String: Any] {
                guard let name = value["name"] as? String, let profilePicture = value["ProfilePicture"] as? String else {return}
                complation(name, profilePicture)
            }
        }
    }
    func checkCurrentUserLovePost(complation: @escaping (_ found: Bool)->Void){
        self.ref.child("AllPosts").child(self.postID!).child("WhoLovePost").observe(.childAdded){ snap in
            if let value = snap.value as? [String: Any]{
                guard let userID = value["UserID"] as? String, let currentUserID = Auth.auth().currentUser?.uid else {return}
                if currentUserID == userID{
                    print("I foi=unded", userID)
                    complation(true)
                }else{
                    complation(false)
                }
            }
        }
    }
}
