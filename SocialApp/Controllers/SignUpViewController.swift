//
//  SignUpViewController.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/6/20.
//
import UIKit
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
        let backButton = UIBarButtonItem()
        backButton.image = UIImage(systemName: "chevron.backward")
        backButton.target = self
        backButton.action = #selector(backButtonOnClick)
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = "Sign Up"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPink]
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
}
