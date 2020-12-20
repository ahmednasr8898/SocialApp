//
//  AddPostViewController.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/7/20.
//
import UIKit
import FirebaseDatabase
import FirebaseAuth
import Toast_Swift
import FirebaseStorage
class AddPostViewController: UIViewController {
    
    @IBOutlet weak var messegPostTextView: UITextView!
    @IBOutlet weak var imageViewPost: UIImageView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var topPostConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightPostConstraint: NSLayoutConstraint!
    @IBOutlet weak var topDescriptionConstraint: NSLayoutConstraint!
    @IBOutlet weak var topImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var topAddPhotoConstraint: NSLayoutConstraint!
    
    let ref = Database.database().reference()
    let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstarint()
        setUpDesign()
    }
    func setUpDesign(){
        descriptionView.backgroundColor = .white
        descriptionView.layer.cornerRadius = 10.0
        descriptionView.layer.shadowColor = UIColor.gray.cgColor
        descriptionView.layer.shadowOffset = CGSize(width: 0.0, height: 3)
        descriptionView.layer.shadowRadius = 2.0
        descriptionView.layer.shadowOpacity = 0.7
    }
    func setUpConstarint(){
        topPostConstraint.constant = self.view.frame.height * 0.021
        rightPostConstraint.constant = self.view.frame.height  * 0.023
        topDescriptionConstraint.constant = self.view.frame.height * 0.075
        topImageConstraint.constant = self.view.frame.height * 0.043
        topAddPhotoConstraint.constant = self.view.frame.height * 0.064
    }
    @IBAction func openGalleryOnClick(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    @IBAction func uploadPostOnClick(_ sender: UIButton) {
        if checkValid(){
            //upload post
            uploadPost()
        }else{
            self.view.makeToast("faild in upload post")
            print("faild in upload post")
        }
    }
    func checkValid()-> Bool{
        guard messegPostTextView.text != nil, !messegPostTextView.text.isEmpty, imageViewPost.image != nil else {
            self.showAlert(title: "happend problem", messege: "check All fields...")
            return false
        }
        return true
    }
}
extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        dismiss(animated: true, completion: nil)
        guard let imagePost = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        imageViewPost.image = imagePost
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
}
extension AddPostViewController{
    func uploadPost(){
        guard let postID = ref.childByAutoId().key, let post = messegPostTextView.text, !post.isEmpty, let userID =
                Auth.auth().currentUser?.uid, let imagePost = imageViewPost.image, let imagePostData = imagePost.jpegData(compressionQuality: 0.5)   else {return}
        self.uplaodImagePost(postID: postID, imagePostData: imagePostData) { (url, error) in
            if error != nil {
                print("fiald in upload image post")
            }else{
                guard let url = url else {return}
                print("success when get url imageURL")
                self.ref.child("AllPosts").child(postID).setValue(["Post": post, "imagePost": url, "Love": 0, "UserID": userID])
            }
            self.dismiss(animated: true, completion: nil)
            print("add new post")
        }
    }
    func uplaodImagePost(postID: String, imagePostData: Data, complation: @escaping(_ url: String?, _ error: Error?)->Void){
        storage.child("ImagePosts").child(postID).putData(imagePostData, metadata: nil) { (metadata, error) in
            if error != nil{
                complation(nil,error)
            }else{
                print("success in upload image post")
                self.storage.child("ImagePosts").child(postID).downloadURL { (url, error) in
                    if error != nil {
                        print("Error when get url : \(String(describing: error?.localizedDescription))")
                    }else{
                        guard let url = url else {return}
                        print("success when get url imageURL")
                        complation(url.absoluteString, nil)
                    }
                }
            }
        }
    }
}

