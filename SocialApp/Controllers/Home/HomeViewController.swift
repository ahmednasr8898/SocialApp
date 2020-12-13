//
//  HomeViewController.swift
//  SocialApp
//
//  Created by Ahmed Nasr on 12/7/20.
//
import UIKit
import SideMenu
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    var menu: SideMenuNavigationController?
    var ref = Database.database().reference()
    var arrOfPosts = [PostsModel]()
    var postID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCurrentUser()
        setUpTableView()
        setUpMenu()
        getAllPosts()
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigation()
    }
    func setUpTableView(){
        homeTableView.dataSource = self
        homeTableView.delegate = self
        homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
    }
    func setUpNavigation(){
        self.navigationController?.navigationBar.barTintColor = UIColor.systemPink
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    @IBAction func addNewPostOnClick(_ sender: UIBarButtonItem) {
        self.goToByPresent(storyboardName: "Main", viewControllerName: AddPostViewController.self, showAs: .automatic)
    }
    func setUpMenu(){
        menu = SideMenuNavigationController(rootViewController: MenuViewController())
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        menu?.leftSide = true
    }
    @IBAction func showMenuOnClick(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    func checkCurrentUser(){
        if Auth.auth().currentUser?.uid == nil{
            self.goToByNavigate(storyboardName: "Main", viewControllerName: AuthViewController.self)
        }
    }
}
extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfPosts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.descriptionPostLabel.text = arrOfPosts[indexPath.row].bodyPost
        cell.userNameLabel.text = arrOfPosts[indexPath.row].postPublisher
        cell.getPhotoImagePost = arrOfPosts[indexPath.row]
        cell.getPhotoPostPublisherProfile = arrOfPosts[indexPath.row]
        cell.numOfLoveLabel.text = String(arrOfPosts[indexPath.row].love)
        cell.postID = arrOfPosts[indexPath.row].postID
        cell.whoLovePostButton.addTarget(self, action: #selector(gotoWhoLovepostPage), for: .touchUpInside)
        postID = arrOfPosts[indexPath.row].postID
        
        for person in self.arrOfPosts[indexPath.row].whoLovePost{
            if person == Auth.auth().currentUser?.uid{
                cell.loveButton.isSelected = true
                cell.loveButton.setImage(UIImage(named: "like"), for: .normal)
            }
        }
        return cell
    }
    @objc func gotoWhoLovepostPage(){
        let st = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "WhoLovePostViewController") as! WhoLovePostViewController
        st.postID = postID
        present(st, animated: true, completion: nil)
    }
}
extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.systemGray5
    }
}
extension HomeViewController{
    func getAllPosts(){
        ref.child("AllPosts").observe(.childAdded){ snap in
            if let value = snap.value as? [String: Any] {
                let posts = PostsModel()
                guard let post = value["Post"] as? String, let postPublisher = value["PostPublisher"] as? String, let imagePost = value["imagePost"] as? String, let love = value["Love"] as? Int, let postPublisherProfile = value["PostPublisherProfile"] as? String else{return}
                posts.postID = snap.key
                posts.postPublisher = postPublisher
                posts.postPublisherProfile = postPublisherProfile
                posts.bodyPost = post
                posts.imagePost = imagePost
                posts.love = love
                if let whoLovePost = value["WhoLovePost"] as? [String: Any]{
                    for (key,_) in whoLovePost{
                        print(key)
                        posts.whoLovePost.append(key)
                    }
                }
                self.arrOfPosts.append(posts)
                print(self.arrOfPosts)
                self.homeTableView.reloadData()
            }
        }
    }
}
