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
class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var personalImageView: UIImageView!
    @IBOutlet weak var changeProfileButton: UIButton!
    @IBOutlet weak var changePersonalButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var isProfile = false
    var isPersonal = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDesign()
        getProfileImage()
        getCoverImage()
        getCurrentUserInformation()
    }
    func setUpDesign(){
        personalImageView.layer.cornerRadius = personalImageView.frame.width / 2
        personalImageView.layer.borderWidth = 5
        personalImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        personalImageView.clipsToBounds = true
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
        Storage.storage().reference().child("ProfilePicture").child(userID).child("MyProfilePicture.jpeg").putData(personalImage, metadata: nil) { (_, error) in
            if error != nil{
                print("faild in update image")
            }else{
                print("update image is success")
                Storage.storage().reference().child("ProfilePicture").child(userID).child("MyProfilePicture.jpeg").downloadURL { (url, error) in
                    if error != nil {
                        print("Error when get url : \(String(describing: error?.localizedDescription))")
                    }else{
                        guard let url = url else {return}
                        print("success when get url imageURL: \(url)")
                        Database.database().reference().child("Users").child(userID).updateChildValues(["ProfilePicture": url.absoluteString])
                    }
                }
            }
        }
    }
    func updateCoverImage(coverImage: Data){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        Storage.storage().reference().child("ProfilePicture").child(userID).child("MyCoverPicture.jpeg").putData(coverImage, metadata: nil) { (_, error) in
            if error != nil{
                print("faild in update image")
            }else{
                print("update image is success")
                Storage.storage().reference().child("ProfilePicture").child(userID).child("MyCoverPicture.jpeg").downloadURL { (url, error) in
                    if error != nil {
                        print("Error when get url : \(String(describing: error?.localizedDescription))")
                    }else{
                        guard let url = url else {return}
                        print("success when get url imageURL: \(url)")
                        Database.database().reference().child("Users").child(userID).updateChildValues(["CoverPicture": url.absoluteString])
                    }
                }
            }
        }
    }
}

extension ProfileViewController{
    func getCoverImage(){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        Storage.storage().reference().child("ProfilePicture").child(userID).child("MyCoverPicture.jpeg").getData(maxSize: 4000000) { (data, error) in
            if error != nil{
                print("error when get data\(String(describing: error?.localizedDescription))")
            }else{
                let image = UIImage(data: data!)
                self.profileImageView.image = image
            }
        }
    }
    func getProfileImage(){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        Storage.storage().reference().child("ProfilePicture").child(userID).child("MyProfilePicture.jpeg")
            .getData(maxSize: 4000000) { (data, error) in
                if error != nil{
                    print("error when get data\(String(describing: error?.localizedDescription))")
                }else{
                    let image = UIImage(data: data!)
                    self.personalImageView.image = image
            }
        }
    }
    func getCurrentUserInformation(){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("Users").child(userID).observeSingleEvent(of: .value) { (datasnap) in
            if let value = datasnap.value as? [String: Any] {
                guard let name = value["name"] as? String else {return}
                self.userNameLabel.text = name
            }
        }
    }
}
