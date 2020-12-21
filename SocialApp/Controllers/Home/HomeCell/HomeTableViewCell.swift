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
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
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
}
extension HomeTableViewCell{
    @IBAction func loveButtonPressed(sender: UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            //append 1 to love score in database and labelLove
            guard let postID = postID, let userID = Auth.auth().currentUser?.uid, let personLikePostID = ref.childByAutoId().key else {return}
            self.ref.child("AllPosts").child(postID).updateChildValues(["WhoLovePost/\(personLikePostID)" : userID], withCompletionBlock: { (error, dataSnap) in
                if error == nil{
                    self.ref.child("AllPosts").child(postID).observeSingleEvent(of: .value) { (dataSnapshot) in
                        if let value = dataSnapshot.value as? [String: Any]{
                            guard let whoLovePost = value["WhoLovePost"] as? [String: Any] else {return}
                            let count = whoLovePost.count
                            self.numOfLoveLabel.text = String(count)
                            self.ref.child("AllPosts").child(postID).updateChildValues(["Love": count])
                            //love button is red
                            sender.setImage(UIImage(named: "like"), for: .normal)
                            sender.isSelected = true
                            sender.isEnabled = true
                        }
                    }
                }
            })
        }else{
            //remove 1 to love score in database and labelLove
            guard let postID = postID, let userID = Auth.auth().currentUser?.uid else {return}
            ref.child("AllPosts").child(postID).observeSingleEvent(of: .value) { (dataSnap) in
                if let value = dataSnap.value as? [String: Any]{
                    guard let whoLovePost = value["WhoLovePost"] as? [String: Any] else {return}
                    for (id,val) in whoLovePost{
                        if val as? String == userID{
                            self.ref.child("AllPosts").child(postID).child("WhoLovePost").child(id).removeValue { (error, dataSnap) in
                                if error == nil{
                                    self.ref.child("AllPosts").child(postID).observeSingleEvent(of: .value) {
                                        (dataSnapshot) in
                                        if let value = dataSnapshot.value as? [String: Any]{
                                            if let whoLovePost = value["WhoLovePost"] as? [String: Any] {
                                            let count = whoLovePost.count
                                            self.numOfLoveLabel.text = String(count)
                                            self.ref.child("AllPosts").child(postID).updateChildValues(["Love": count])
                                            }else{
                                                self.numOfLoveLabel.text = "0"
                                                self.ref.child("AllPosts").child(postID).updateChildValues(["Love": 0])
                                            }
                                            //love button is white
                                            sender.setImage(UIImage(named: "unlike"), for: .normal)
                                            sender.isSelected = false
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

