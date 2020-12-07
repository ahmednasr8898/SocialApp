//
//  AddPostViewController.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/7/20.
//

import UIKit

class AddPostViewController: UIViewController {
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var topPostConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightPostConstraint: NSLayoutConstraint!
    @IBOutlet weak var topDescriptionConstraint: NSLayoutConstraint!
    @IBOutlet weak var topImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var topAddPhotoConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstarint()
        setUpDesign()
    }
    func setUpDesign(){
        descriptionView.backgroundColor = .white
        descriptionView.layer.cornerRadius = 10.0
        descriptionView.layer.shadowColor = UIColor.gray.cgColor
        descriptionView.layer.shadowOffset = CGSize(width: 0.0, height: 3)
        descriptionView.layer.shadowRadius = 2.0
        descriptionView.layer.shadowOpacity = 0.7
    }
    func setUpConstarint(){
        topPostConstraint.constant = self.view.frame.height * 0.021
        rightPostConstraint.constant = self.view.frame.height  * 0.023
        topDescriptionConstraint.constant = self.view.frame.height * 0.075
        topImageConstraint.constant = self.view.frame.height * 0.043
        topAddPhotoConstraint.constant = self.view.frame.height * 0.064
    }
}
