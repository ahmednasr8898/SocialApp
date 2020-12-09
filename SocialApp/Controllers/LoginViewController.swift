//
//  LoginViewController.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/5/20.
//
import UIKit
import FirebaseAuth
import Toast_Swift
class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var topEmailConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topPasswordConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLoginConstarint: NSLayoutConstraint!
    @IBOutlet weak var topORConstraint: NSLayoutConstraint!
    @IBOutlet weak var topFacebookConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFields()
        setUpButtons()
        setUpConstraint()
        passwordTextField.isSecureTextEntry = true
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
        navigationItem.title = "Log In"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPink]
        navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    @objc func backButtonOnClick(){
        navigationController?.popViewController(animated: true)
    }
    func setUpTextFields(){
        emailTextField.setUpDesign(cornerRadius: self.emailTextField.frame.height / 2, borderWidth: 0.9, borderColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
        passwordTextField.setUpDesign(cornerRadius: self.passwordTextField.frame.height / 2, borderWidth: 0.9, borderColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
    }
    func setUpButtons(){
        loginButton.layer.cornerRadius = self.loginButton.frame.height / 2
        facebookLoginButton.layer.cornerRadius = self.facebookLoginButton.frame.height / 2
    }
    func setUpConstraint(){
        topEmailConstraint.constant = self.view.frame.height * 0.15
        topPasswordConstraint.constant = self.view.frame.height * 0.037
        topLoginConstarint.constant = self.view.frame.height * 0.037
        topORConstraint.constant = self.view.frame.height * 0.048
        topFacebookConstraint.constant = self.view.frame.height * 0.048
    }
    @IBAction func loginOnClick(_ sender: UIButton) {
        if checkValid() {
            login()
        }else{
            self.showAlert(title: "happend problem", messege: "all fields is required...")
        }
    }
    func login(){
        let email = emailTextField.text
        let password = passwordTextField.text
        //show indecatior
        self.showIndicator(withTitle: "Loading", and: "signin")
        Auth.auth().signIn(withEmail: email ?? "", password: password ?? "") { ( _ , error) in
            if error == nil{
                //stop indecatior
                self.hideIndicator()
                print("Login Success")
                //go to home page
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                //stop indecatior
                self.hideIndicator()
                print("login faild")
                self.view.makeToast("Login Faild")
            }
        }
    }
    func checkValid() -> Bool{
        let email = emailTextField.text
        let password = passwordTextField.text
        guard email != nil, !email!.isEmpty, password != nil, !password!.isEmpty else {
            return false
        }
        return true
    }
}

