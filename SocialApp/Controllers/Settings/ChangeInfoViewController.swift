//
//  ChangeInfoViewController.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/13/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Toast_Swift
class ChangeInfoViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var saveChangeButton: UIButton!
    let ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDesign()
        getCurrentUserInformation()
    }
    func setUpDesign(){
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        phoneTextField.layer.borderWidth = 1
        phoneTextField.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        nameTextField.setRightPaddingPoints(6)
        nameTextField.setLeftPaddingPoints(6)
        phoneTextField.setRightPaddingPoints(6)
        phoneTextField.setLeftPaddingPoints(6)
        saveChangeButton.layer.borderWidth = 1
        saveChangeButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    @IBAction func backOnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveChangeOnClick(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty, let phone = phoneTextField.text , !phone.isEmpty else {
            self.showAlert(title: "error", messege: "check all fields")
            return
        }
        changeInfo(name: name, phone: phone)
    }
    func getCurrentUserInformation(){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        ref.child("Users").child(userID).child("PersonalInformation").observeSingleEvent(of: .value) { (datasnap) in
            if let value = datasnap.value as? [String: Any] {
                guard let name = value["name"] as? String, let phone = value["phone"] as? String else {return}
                self.nameTextField.text = name
                self.phoneTextField.text = phone
            }
        }
    }
    func changeInfo(name: String, phone: String){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        ref.child("Users").child(userID).child("PersonalInformation").updateChildValues(["name": name, "phone": phone])
        self.view.makeToast("Update Success")
    }
}
