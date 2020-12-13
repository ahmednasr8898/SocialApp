//
//  ChangePasswordViewController.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/13/20.
//

import UIKit
import FirebaseAuth
class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var saveChangeButton: UIButton!
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDesign()
    }
    func setUpDesign(){
        currentPasswordTextField.layer.borderWidth = 1
        currentPasswordTextField.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        newPasswordTextField.layer.borderWidth = 1
        newPasswordTextField.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        confirmPasswordTextField.layer.borderWidth = 1
        confirmPasswordTextField.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        currentPasswordTextField.setRightPaddingPoints(6)
        currentPasswordTextField.setLeftPaddingPoints(6)
        newPasswordTextField.setRightPaddingPoints(6)
        newPasswordTextField.setLeftPaddingPoints(6)
        confirmPasswordTextField.setRightPaddingPoints(6)
        confirmPasswordTextField.setLeftPaddingPoints(6)
        saveChangeButton.layer.borderWidth = 1
        saveChangeButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        currentPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
    }
    @IBAction func backOnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveChangeOnClick(_ sender: Any) {
        guard let currentPassword = currentPasswordTextField.text, !currentPassword.isEmpty, let newPassword = newPasswordTextField.text, !newPassword.isEmpty, confirmPasswordTextField.text == newPassword else {
            self.showAlert(title: "error", messege: "check all fields")
            return
        }
        changePassword(currentPassword: currentPassword, newPassword: newPassword) { (error) in
            if error != nil {
                self.showAlert(title: "faild in update password", messege: "check all fileds")
            }else{
                self.view.makeToast("update password is success")
                self.currentPasswordTextField.text = ""
                self.newPasswordTextField.text = ""
                self.confirmPasswordTextField.text = ""
            }
        }
    }
    func changePassword(currentPassword: String, newPassword: String, completion: @escaping (Error?) -> Void) {
        guard let email = currentUser?.email else {return}
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        currentUser?.reauthenticate(with: credential, completion: { (result, error) in
                if let error = error {
                    completion(error)
                }
                else {
                    self.currentUser?.updatePassword(to: newPassword, completion: { (error) in
                        completion(error)
                })
            }
        })
    }
}
