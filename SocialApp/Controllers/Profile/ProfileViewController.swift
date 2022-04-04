//
//  ProfileViewController.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/13/20.
//
import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import Toast_Swift
import Kingfisher
class ProfileViewController: UIViewController {
    
    @IBOutlet weak var topProfileImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftUpdateProfileImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var topUserNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var topDescConstraint: NSLayoutConstraint!

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var personalImageView: UIImageView!
    @IBOutlet weak var changeProfileButton: UIButton!
    @IBOutlet weak var changePersonalButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var isProfile = false
    var isPersonal = false
    
    let ref = Database.database().reference()
    let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDesign()
        getProfileImages()
        getCurrentUserInformation()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpConstraint()
    }
    func setUpConstraint(){
        topProfileImageConstraint.constant = self.view.frame.height * -0.10
        topUserNameConstraint.constant = self.view.frame.height * 0.06
        topDescConstraint.constant = self.view.frame.height * 0.10
        leftUpdateProfileImageConstraint.constant = self.view.frame.width * 0.28
    }
    func setUpDesign(){
        personalImageView.layer.borderWidth = 5
        personalImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        personalImageView.layer.cornerRadius = 90//personalImageView.frame.size.height/2
        personalImageView.clipsToBounds = true
        //personalImageView.clipsToBounds = true
    }
    @IBAction func changeProfileImageOnClick(_ sender: UIButton) {
        isProfile = true
        setUpImagePicker()
    }
    @IBAction func changePersonalImageOnCLick(_ sender: UIButton) {
        isPersonal = true
        setUpImagePicker()
    }
    func setUpImagePicker(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        if isProfile == true {
            profileImageView.image = image
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
            updateCoverImage(coverImage: imageData)
            isProfile = false
        }else if isPersonal == true{
            personalImageView.image = image
            guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
            updatePersonalImage(personalImage: imageData)
            isPersonal = false
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    func updatePersonalImage(personalImage: Data){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        storage.child("ProfilePicture").child(userID).child("MyProfilePicture.jpeg").putData(personalImage, metadata: nil) { (_, error) in
            if error != nil{
                print("faild in update image")
            }else{
                print("update image is success")
                self.view.makeToast("update Profile Picture is success")
                Storage.storage().reference().child("ProfilePicture").child(userID).child("MyProfilePicture.jpeg").downloadURL { (url, error) in
                    if error != nil {
                        print("Error when get url : \(String(describing: error?.localizedDescription))")
                    }else{
                        guard let url = url else {return}
                        print("success when get url imageURL")
                        Database.database().reference().child("Users").child(userID).updateChildValues(["ProfilePicture": url.absoluteString])
                    }
                }
            }
        }
    }
    func updateCoverImage(coverImage: Data){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        storage.child("ProfilePicture").child(userID).child("MyCoverPicture.jpeg").putData(coverImage, metadata: nil) { (_, error) in
            if error != nil{
                print("faild in update image")
            }else{
                self.view.makeToast("update cover Picture is success")
                Storage.storage().reference().child("ProfilePicture").child(userID).child("MyCoverPicture.jpeg").downloadURL { (url, error) in
                    if error != nil {
                        print("Error when get url : \(String(describing: error?.localizedDescription))")
                    }else{
                        guard let url = url else {return}
                        print("success when get url imageURL")
                        Database.database().reference().child("Users").child(userID).updateChildValues(["CoverPicture": url.absoluteString])
                    }
                }
            }
        }
    }
}
extension ProfileViewController{
    func getProfileImages(){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        self.ref.child("Users").child(userID).observeSingleEvent(of: .value) { (dataSnap) in
            if let value = dataSnap.value as? [String: Any]{
                guard let profilePicture = value["ProfilePicture"] as? String, let coverPicture = value["CoverPicture"] as? String else {return}
                self.personalImageView.kf.indicatorType = .activity
                self.profileImageView.kf.indicatorType = .activity
                guard let profileUrl = URL(string: profilePicture), let coverUrl = URL(string: coverPicture)  else {return}
                self.personalImageView.kf.setImage(with: profileUrl)
                self.profileImageView.kf.setImage(with: coverUrl)
            }
        }
    }
    func getCurrentUserInformation(){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        ref.child("Users").child(userID).observeSingleEvent(of: .value) { (datasnap) in
            if let value = datasnap.value as? [String: Any] {
                guard let name = value["name"] as? String else {return}
                self.userNameLabel.text = name
            }
        }
    }
}
