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
import Kingfisher

class AddPostViewController: UIViewController {
    
    @IBOutlet weak var messegPostTextView: UITextView!
    @IBOutlet weak var imageViewPost: UIImageView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var bottonAddPhotoConstraint: NSLayoutConstraint!

    let ref = Database.database().reference()
    let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.height/2
        profilePicImageView.clipsToBounds = true
        getProfileImages()
        getCurrentUserInformation()
        self.hideKeyboardWhenTappedAround()
        setupViewWhenShowKeyboard()
        setUpMessegePostTextView()
    }
    @IBAction func openGalleryOnClick(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    @IBAction func uploadPostOnClick(_ sender: UIBarButtonItem) {
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
                completion(true)
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
        messegPostTextView.font = UIFont.systemFont(ofSize: 20)
        messegPostTextView.returnKeyType = .done
        messegPostTextView.delegate = self
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("DidBeginEditing")
        if textView.textColor == .lightGray {
            print("DidBeginEditing 1")
            textView.text = ""
            textView.textColor = UIColor.black
            textView.font = UIFont.systemFont(ofSize: 20)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "/n" {
            textView.resignFirstResponder()
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("DidEndEditing")
        if textView.text == "" {
            print("DidEndEditing 3")
            textView.text = "what are you thinking..."
            textView.textColor = UIColor.lightGray
            textView.font = UIFont.systemFont(ofSize: 20)
        }
    }
}

extension AddPostViewController{
    func setupViewWhenShowKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardApear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisApear(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: Notification) -> CGFloat{
        guard let keyboardHeihgt = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
            return 0
        }
        return keyboardHeihgt
    }
    
    @objc func keyboardApear(notification: Notification){
        let keyboardHeight = getKeyboardHeight(notification: notification)
        print(keyboardHeight)
        bottonAddPhotoConstraint.constant = -keyboardHeight
    }
    @objc func keyboardDisApear(notification: Notification){
        let keyboardHeight = getKeyboardHeight(notification: notification)
        print(keyboardHeight)
        bottonAddPhotoConstraint.constant = -34
    }
}

extension AddPostViewController{
    func getProfileImages(){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        self.ref.child("Users").child(userID).observeSingleEvent(of: .value) { (dataSnap) in
            if let value = dataSnap.value as? [String: Any]{
                guard let profilePicture = value["ProfilePicture"] as? String else{ return }
                self.profilePicImageView.kf.indicatorType = .activity
                guard let profileUrl = URL(string: profilePicture) else {return}
                self.profilePicImageView.kf.setImage(with: profileUrl)
            }
        }
    }
    func getCurrentUserInformation(){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        ref.child("Users").child(userID).observeSingleEvent(of: .value) { (datasnap) in
            if let value = datasnap.value as? [String: Any] {
                guard let name = value["name"] as? String else {return}
                self.nameLabel.text = name
            }
        }
    }
}
