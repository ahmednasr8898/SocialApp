//
//  ProfileViewController.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/13/20.
//
import UIKit
class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var personalImageView: UIImageView!
    @IBOutlet weak var changeProfileButton: UIButton!
    @IBOutlet weak var changePersonalButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        personalImageView.layer.cornerRadius = personalImageView.frame.width / 2
        personalImageView.layer.borderWidth = 5
        personalImageView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        personalImageView.clipsToBounds = true
    }
    
    @IBAction func changeProfileImageOnClick(_ sender: UIButton) {
        sender.tag = 0
        setUpImagePicker()
    }
    @IBAction func changePersonalImageOnCLick(_ sender: UIButton) {
        sender.tag = 1
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
        /*if changeProfileButton.tag == 0 {
            profileImageView.image = image
        }else if changePersonalButton.tag == 1{
            personalImageView.image = image
        }*/
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
}
