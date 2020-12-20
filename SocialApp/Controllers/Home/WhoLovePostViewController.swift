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
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabelView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(listenForNotification(notification:)), name: NSNotification.Name(rawValue: "SendData"), object: nil)
    }
    @objc func listenForNotification(notification: Notification){
        if let data = notification.object as? String{
            print("data",data)
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
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WhoLovePostTableViewCell", for: indexPath) as! WhoLovePostTableViewCell
        /*cell.userNameLabel.text = arrOfWhoLovePost[indexPath.row].name
        cell.getPhoto = arrOfWhoLovePost[indexPath.row]*/
        cell.userNameLabel.text = "Hello, User Love post"
        return cell
    }
}
extension WhoLovePostViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
