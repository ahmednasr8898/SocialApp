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
    var postID: String?
    var arrOfID = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabelView()
        getWhoLovePost { (noData) in
            if !noData{
                self.checkIfTableViewEmpty()
            }
        }
    }
    func checkIfTableViewEmpty(){
        if arrOfID.count == 0{
            self.whoLovePostTableView.isHidden = true
            let noLovePostLabel = UILabel()
            noLovePostLabel.text = "no love in this post"
            noLovePostLabel.textAlignment = .center
            noLovePostLabel.textColor = .black
            noLovePostLabel.font = UIFont.systemFont(ofSize: 22)
            noLovePostLabel.frame = CGRect(x: 0, y: self.view.center.y, width: self.view.frame.width, height: 50)
            self.view.addSubview(noLovePostLabel)
        }
    }
    func setUpTabelView(){
        whoLovePostTableView.register(UINib(nibName: "WhoLovePostTableViewCell", bundle: nil), forCellReuseIdentifier: "WhoLovePostTableViewCell")
        whoLovePostTableView.dataSource = self
        whoLovePostTableView.delegate = self
    }
}
extension WhoLovePostViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfID.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WhoLovePostTableViewCell", for: indexPath) as! WhoLovePostTableViewCell
        
        self.ref.child("Users").child(arrOfID[indexPath.row]).observe(.value) { (dataSnap) in
            if let value = dataSnap.value as? [String: Any]{
                guard let name = value["name"] as? String, let profilePicture = value["ProfilePicture"] as? String else {
                    return
                }
                cell.userNameLabel.text = name
                cell.userImageView.kf.indicatorType = .activity
                if let url = URL(string: profilePicture){
                    cell.userImageView.kf.setImage(with: url)
                }
            }
        }
        return cell
    }
}
extension WhoLovePostViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
extension WhoLovePostViewController{
    func getWhoLovePost(complation: @escaping (Bool)->()){
        guard let postId = postID else {return}
        ref.child("AllPosts").child(postId).observe(.value) { (dataSnap) in
            if let value = dataSnap.value as? [String: Any]{
                guard let whoLovePost = value["WhoLovePost"] as? [String: Any] else {
                    complation(false)
                    return
                }
                for (_,val) in whoLovePost{
                    self.arrOfID.append(val as! String)
                    complation(true)
                }
            }
        }
    }
}
