//
//  MenuViewController.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/8/20.
//
import UIKit
import  FirebaseAuth
class MenuViewController: UITableViewController {
        
    let items = ["Profile", "Personal Info", "Change Password", "Log Out"]
    let itemImage = [UIImage(named: "profile-1"), UIImage(named: "personal-information"), UIImage(named: "password"), UIImage(named: "logout")]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "menuCell")
        tableView.tableFooterView = UIView()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        cell.imageMenu.image = itemImage[indexPath.row]
        cell.labelMenu.text = items[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemIndex = indexPath.row
        if itemIndex == 0 {
            //go to profile page
            self.goToByPresent(storyboardName: "Main", viewControllerName: ProfileViewController.self, showAs: .automatic)
        }else if itemIndex == 1{
           //go to personal info page
            self.goToByPresent(storyboardName: "Main", viewControllerName: ChangeInfoViewController.self, showAs: .fullScreen)
        }else if itemIndex == 2{
            //go to change password page
            self.goToByPresent(storyboardName: "Main", viewControllerName: ChangePasswordViewController.self, showAs: .fullScreen )
        }else if itemIndex == 3{
            self.sureLogOut()
        }
    }
    func logOut(){
        self.showIndicator(withTitle: "Log Out", and: "")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.hideIndicator()
            //self.goToByPresent(storyboardName: "Main", viewControllerName: AuthViewController.self, showAs: .fullScreen)
            self.goToByNavigate(storyboardName: "Main", viewControllerName: AuthViewController.self)
        }catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            self.view.makeToast("faild to log out")
        }
    }
    func sureLogOut(){
        let alert = UIAlertController(title: "Are you sure?", message: "Log Out !!", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .destructive) { (_) in
            self.logOut()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
}
