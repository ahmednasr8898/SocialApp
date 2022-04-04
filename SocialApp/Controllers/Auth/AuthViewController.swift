//
//  ViewController.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/5/20.
//
import UIKit
class AuthViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var topImageLogoConstraint: NSLayoutConstraint!
    @IBOutlet weak var topWelcomLabelconstraint: NSLayoutConstraint!
    @IBOutlet weak var topDescLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLoginButtonConstarint: NSLayoutConstraint!
    @IBOutlet weak var topSignupCuttonConstarint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewDidLayoutSubviews() {
        setUpLoginButton()
        setUpSignupButton()
        setUpConstarint()
    }
    func setUpLoginButton(){
        loginButton.layer.cornerRadius = loginButton.frame.height / 2
    }
    func setUpSignupButton(){
        signupButton.layer.cornerRadius = signupButton.frame.height / 2
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    func setUpConstarint(){
        topImageLogoConstraint.constant = self.view.frame.height * 0.097
        topWelcomLabelconstraint.constant = self.view.frame.height * 0.043
        topDescLabelConstraint.constant = self.view.frame.height * 0.036
        topLoginButtonConstarint.constant = self.view.frame.height * 0.075
        topSignupCuttonConstarint.constant = self.view.frame.height * 0.029
    }
    @IBAction func goLoginOnClick(_ sender: UIButton) {
        self.goToByNavigate(storyboardName: "Main", viewControllerName: LoginViewController.self)
       // self.goToByPresent(storyboardName: "Main", viewControllerName: LoginViewController.self, showAs: .fullScreen)
    }
    @IBAction func goSignupOnClick(_ sender: UIButton) {
       // self.goToByPresent(storyboardName: "Main", viewControllerName: SignUpViewController.self, showAs: .fullScreen)
        self.goToByNavigate(storyboardName: "Main", viewControllerName: SignUpViewController.self)
    }
}

