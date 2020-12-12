//
//  WhoLovePostViewController.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/12/20.
//

import UIKit
import FirebaseDatabase
import Kingfisher
class WhoLovePostViewController: UIViewController {

    @IBOutlet weak var whoLovePostTableView: UITableView!
    let ref = Database.database().reference()
    var arrOfWhoLovePost = [WhoLovePostModel]()
    var postID: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabelView()
        getWhoLovePost()
    }
    func setUpTabelView(){
        whoLovePostTableView.register(UINib(nibName: "WhoLovePostTableViewCell", bundle: nil), forCellReuseIdentifier: "WhoLovePostTableViewCell")
        whoLovePostTableView.dataSource = self
        whoLovePostTableView.delegate = self
    }
}
extension WhoLovePostViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfWhoLovePost.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WhoLovePostTableViewCell", for: indexPath) as! WhoLovePostTableViewCell
        cell.userNameLabel.text = arrOfWhoLovePost[indexPath.row].name
        cell.getPhoto = arrOfWhoLovePost[indexPath.row]
    
        
        return cell
    }
}
extension WhoLovePostViewController{
    func getWhoLovePost(){
        self.ref.child("AllPosts").child(self.postID!).child("WhoLovePost").observe(.childAdded){ snap in
            if let value = snap.value as? [String: Any]{
                print("VAVVAVAVAVAV:",value)
                guard let name = value["Name"] as? String, let userID = value["UserID"] as? String, let profilePictrue = value["profilePicture"] as? String else {return}
                let whoLovePost = WhoLovePostModel(UserID: userID, name: name, profilePicture: profilePictrue)
                self.arrOfWhoLovePost.append(whoLovePost)
                self.whoLovePostTableView.reloadData()
                print("ARARARRARAR",self.arrOfWhoLovePost)
            }
        }
    }
}
extension WhoLovePostViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
