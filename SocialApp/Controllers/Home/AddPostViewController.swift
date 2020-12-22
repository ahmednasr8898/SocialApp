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
        setUpMessegePostTextView()
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
            uploadPost { (isSuccess) in
                if isSuccess{
                    self.hideIndicator()
                    self.dismiss(animated: true, completion: nil)
                    print("add new post")
                }
            }
        }else{
            self.view.makeToast("faild in upload post")
            print("faild in upload post")
        }
    }
    func checkValid()-> Bool{
        guard messegPostTextView.text != nil, !messegPostTextView.text.isEmpty, messegPostTextView.text !=
                "what are you thinking..." else {
            self.showAlert(title: "can't upload post", messege: "enter descreption to your post")
            return false
        }
        guard  imageViewPost.image != nil else {
            self.showAlert(title: "can't upload post", messege: "select photo to your post")
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
    func uploadPost(completion: @escaping (Bool)->()){
        self.showIndicator(withTitle: "Uploading Your Post", and: "")
        guard let postID = ref.childByAutoId().key, let post = messegPostTextView.text, !post.isEmpty, let userID =
                Auth.auth().currentUser?.uid, let imagePost = imageViewPost.image, let imagePostData = imagePost.jpegData(compressionQuality: 0.5)   else {return}
        self.uplaodImagePost(postID: postID, imagePostData: imagePostData) { (url, error) in
            if error != nil {
                print("fiald in upload image post")
                completion(false)
            }else{
                guard let url = url else {return}
                print("success when get url imageURL")
                self.ref.child("AllPosts").child(postID).setValue(["Post": post, "imagePost": url, "Love": 0, "UserID": userID])
               completion(true)
            }
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
extension AddPostViewController: UITextViewDelegate{
    func setUpMessegePostTextView(){
        messegPostTextView.text = "what are you thinking..."
        messegPostTextView.textColor = UIColor.lightGray
        messegPostTextView.font = UIFont.systemFont(ofSize: 13)
        messegPostTextView.delegate = self
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "what are you thinking..." {
            textView.text = ""
            textView.textColor = UIColor.black
            textView.font = UIFont.systemFont(ofSize: 16)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "/n" {
            textView.resignFirstResponder()
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "what are you thinking..."
            textView.textColor = UIColor.lightGray
            textView.font = UIFont.systemFont(ofSize: 13)
        }
    }
}
