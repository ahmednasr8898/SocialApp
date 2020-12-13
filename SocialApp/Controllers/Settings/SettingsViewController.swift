//
//  SettingsViewController.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/13/20.
//
import UIKit
class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func dismissPageOnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func chnagePasswordOnClick(_ sender: Any) {
        print("go to chnage password page")
        self.goToByPresent(storyboardName: "Main", viewControllerName: ChangePasswordViewController.self, showAs: .fullScreen )
    }
    @IBAction func changeInfoOnClick(_ sender: Any) {
        print("go to change information page")
        self.goToByPresent(storyboardName: "Main", viewControllerName: ChangeInfoViewController.self, showAs: .fullScreen)
    }
}
