//
//  SignUpViewController.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/6/20.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Toast_Swift
class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confiremPasswordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var topNameConstriant: NSLayoutConstraint!
    @IBOutlet weak var topEmailConstriant: NSLayoutConstraint!
    @IBOutlet weak var topPhoneConstriant: NSLayoutConstraint!
    @IBOutlet weak var topPasswordConstriant: NSLayoutConstraint!
    @IBOutlet weak var topConfirmPasswordConstriant: NSLayoutConstraint!
    @IBOutlet weak var topCraeteAccountConstraint: NSLayoutConstraint!
    
    let ref = Database.database().reference()
    let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        setUpButtons()
        setUpConstraint()
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigation()
    }
    func setUpNavigation(){
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backButton = UIBarButtonItem()
        backButton.image = UIImage(systemName: "chevron.backward")
        backButton.target = self
        backButton.action = #selector(backButtonOnClick)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = "Sign Up"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPink]
        navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    @objc func backButtonOnClick(){
        navigationController?.popViewController(animated: true)
    }
    func setUpTextFields(){
        nameTextField.setUpDesign(cornerRadius: self.nameTextField.frame.height / 2, borderWidth: 0.9, borderColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        phoneTextField.setUpDesign(cornerRadius: self.phoneTextField.frame.height / 2, borderWidth: 0.9, borderColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        emailTextField.setUpDesign(cornerRadius: self.emailTextField.frame.height / 2, borderWidth: 0.9, borderColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        passwordTextField.setUpDesign(cornerRadius: self.passwordTextField.frame.height / 2, borderWidth: 0.9, borderColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        confiremPasswordTextField.setUpDesign(cornerRadius: self.confiremPasswordTextField.frame.height / 2, borderWidth: 0.9, borderColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    func setUpButtons(){
        createAccountButton.layer.cornerRadius = self.createAccountButton.frame.height / 2
    }
    func setUpConstraint(){
        topNameConstriant.constant = self.view.frame.height * 0.12
        topPhoneConstriant.constant = self.view.frame.height  * 0.021
        topEmailConstriant.constant = self.view.frame.height * 0.021
        topPasswordConstriant.constant = self.view.frame.height * 0.021
        topConfirmPasswordConstriant.constant = self.view.frame.height * 0.021
        topCraeteAccountConstraint.constant = self.view.frame.height * 0.032
    }
    @IBAction func singupOnClick(_ sender: UIButton) {
        if checkVaild(){
            signUp()
        }else{
            self.showAlert(title: "happend problem", messege: "check all fields...")
        }
    }
    func signUp(){
        let email = emailTextField.text
        let password = passwordTextField.text
        let phone = phoneTextField.text
        let name = nameTextField.text
        self.showIndicator(withTitle: "loading", and: "creating new user")
        Auth.auth().createUser(withEmail: email ?? "", password: password ?? "") { (res, error) in
            if error == nil{
                self.hideIndicator()
                print("success in create new account")
                //get user id
                guard let userID = Auth.auth().currentUser?.uid else {return}
                //create new user
                self.createNewUser(userID: userID, name: name!, email: email!, phone: phone!)
                //save profile picture
                //save profile picture
                self.uplaodProfilePicture(userID: userID) { (url, error) in
                    if error != nil{
                        print("error when upload profile picture \(String(describing: error?.localizedDescription))")
                    }else{
                        self.ref.child("Users").child(userID).child("PersonalInformation").child("ProfilePicture").setValue(url)
                    }
                }
                //save cover picture
                self.uplaodCoverPicture(userID: userID) { (url, string) in
                    if error != nil{
                        print("error when upload cover picture \(String(describing: error?.localizedDescription))")
                    }else{
                        self.ref.child("Users").child(userID).child("PersonalInformation").child("CoverPicture").setValue(url)
                    }
                }
                //go to home page
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                self.hideIndicator()
                print("create is falid")
                self.view.makeToast("faild in create new account")
            }
        }
    }
    func checkVaild()-> Bool{
        guard nameTextField.text != nil, !nameTextField.text!.isEmpty, emailTextField.text != nil, !emailTextField.text!.isEmpty ,  phoneTextField.text != nil, !phoneTextField.text!.isEmpty, passwordTextField.text != nil, !passwordTextField.text!.isEmpty, confiremPasswordTextField.text != nil, !confiremPasswordTextField.text!.isEmpty, passwordTextField.text == confiremPasswordTextField.text
        else {
            return false
        }
        return true
    }
}
extension SignUpViewController{
    func createNewUser(userID: String, name: String, email: String, phone: String){
        ref.child("Users").child(userID).child("PersonalInformation").setValue(["name": name, "email": email, "phone": phone])
    }
    func uplaodProfilePicture(userID: String, complation: @escaping(_ url: String?, _ error: Error?)->Void){
        guard let profilePicture = UIImage(named: "user")?.jpegData(compressionQuality: 0.5) else{
            self.view.makeToast("happend probelm")
            return
        }
        storage.child("ProfilePicture").child(userID).child("MyProfilePicture.jpeg")
            .putData(profilePicture, metadata: nil) { (_, error) in
                if error != nil{
                    complation(nil,error)
                }else{
                    self.storage.child("ProfilePicture").child(userID).child("MyProfilePicture.jpeg").downloadURL { (url, error) in
                        if error != nil {
                            print("Error when get url : \(String(describing: error?.localizedDescription))")
                        }else{
                            guard let url = url else {return}
                            print("success when get url imageURL: \(url)")
                            complation(url.absoluteString, nil)
                    }
                }
            }
        }
    }
    func uplaodCoverPicture(userID: String, complation: @escaping(_ url: String?, _ error: Error?)->Void){
        guard let profilePicture = UIImage(named: "profile")?.jpegData(compressionQuality: 0.5) else{
            self.view.makeToast("happend probelm")
            return
        }
        storage.child("ProfilePicture").child(userID).child("MyCoverPicture.jpeg")
            .putData(profilePicture, metadata: nil) { (_, error) in
                if error != nil{
                    complation(nil,error)
                }else{
                    self.storage.child("ProfilePicture").child(userID).child("MyCoverPicture.jpeg").downloadURL { (url, error) in
                        if error != nil {
                            print("Error when get url : \(String(describing: error?.localizedDescription))")
                        }else{
                            guard let url = url else {return}
                            print("success when get url imageURL: \(url)")
                            complation(url.absoluteString, nil)
                    }
                }
            }
        }
    }
}


