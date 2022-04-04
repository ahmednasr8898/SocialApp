//
//  UIViewContoller+Extenstion.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/5/20.
//
import Foundation
import UIKit
import MBProgressHUD
extension UIViewController{
    func goToByPresent<vc: UIViewController>(storyboardName: String , viewControllerName: vc.Type , showAs: UIModalPresentationStyle){
        let identfire = String(describing: viewControllerName)
        if let page = UIStoryboard(name: storyboardName, bundle:nil).instantiateViewController(withIdentifier: identfire) as? vc{
        page.modalPresentationStyle = showAs
        present(page, animated: true, completion: nil)
        }
    }
    func goToByNavigate<vc: UIViewController>(storyboardName: String , viewControllerName: vc.Type) {
        let identfire = String(describing: viewControllerName)
        if let page = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identfire) as? vc{
        navigationController?.pushViewController(page, animated: true)
        }
    }
    func showIndicator(withTitle title: String, and description: String) {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.label.text = title
        indicator.isUserInteractionEnabled = false
        indicator.detailsLabel.text = description
        indicator.show(animated: true)
        self.view.isUserInteractionEnabled = false
    }
    func hideIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.view.isUserInteractionEnabled = true
    }
    func showAlert(title: String? , messege: String?){
        let alert = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        let actionCancle = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        alert.addAction(actionCancle)
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController{
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
