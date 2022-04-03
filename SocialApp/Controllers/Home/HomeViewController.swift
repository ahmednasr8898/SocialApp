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
import Kingfisher

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    var menu: SideMenuNavigationController?
    var ref = Database.database().reference()
    var arrOfPosts = [PostsModel]()
    let noLovePostLabel = UILabel()
    let reFreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCurrentUser()
        setUpTableView()
        setUpMenu()
        getAllPosts { (noPosts) in
            if noPosts{
                self.homeTableView.isHidden = false
                self.noLovePostLabel.isHidden = true
            }else{
                self.checkIfTableViewEmpty()
            }
        }
        setUpRefreshControl()
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigation()
    }
    func setUpRefreshControl(){
        reFreshControl.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        reFreshControl.addTarget(self, action: #selector(refreshDataInTabelview), for: .valueChanged)
        homeTableView.addSubview(reFreshControl)
    }
    @objc func refreshDataInTabelview(){
        print("refresh data")
        self.homeTableView.reloadData()
        reFreshControl.endRefreshing()
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
    func checkIfTableViewEmpty(){
        if arrOfPosts.count == 0{
            self.homeTableView.isHidden = true
            self.noLovePostLabel.isHidden = false
            noLovePostLabel.isHidden = false
            noLovePostLabel.text = "no post yet."
            noLovePostLabel.textAlignment = .center
            noLovePostLabel.textColor = .black
            noLovePostLabel.font = UIFont.systemFont(ofSize: 22)
            noLovePostLabel.frame = CGRect(x: 0, y: self.view.center.y, width: self.view.frame.width, height: 50)
            self.view.addSubview(noLovePostLabel)
        }
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
        //get Name and profile for user that make post
        self.ref.child("Users").child(arrOfPosts[indexPath.row].userID).observe(.value) { (dataSnap) in
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
        cell.getPhotoImagePost = arrOfPosts[indexPath.row]
        // handel love button
        let userID = (Auth.auth().currentUser?.uid) ?? ""
        let personLikePostID = ref.childByAutoId().key ?? ""
        let postID = self.arrOfPosts[indexPath.row].postID
        
        cell.addLoveToPost = {
            cell.loveButton.isSelected = !cell.loveButton.isSelected
            if cell.loveButton.isSelected{
                print("selected")
                cell.loveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.loveButtonSelected(postID: postID, personLikePostID: personLikePostID, userID: userID, indexPathRow: indexPath.row) { (success) in
                    if success{
                        cell.numOfLoveLabel.text = String(self.arrOfPosts[indexPath.row].love)
                    }
                }
            }else{
                print("non selcted")
                cell.loveButton.setImage(UIImage(systemName: "heart"), for: .normal)
                self.loveButtonNonSelected(postID: postID, userID: userID, indexPathRow: indexPath.row) { (success) in
                    if success{
                        cell.numOfLoveLabel.text = String(self.arrOfPosts[indexPath.row].love)
                    }
                }
            }
        }
        
        cell.whoLovePost = {
            let st = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "WhoLovePostViewController") as! WhoLovePostViewController
            st.postID = self.arrOfPosts[indexPath.row].postID
            self.present(st, animated: true, completion: nil)
        }
        //check if current user was love any post
        cell.numOfLoveLabel.text = String(arrOfPosts[indexPath.row].love)
        for person in self.arrOfPosts[indexPath.row].whoLovePost{
            if person == Auth.auth().currentUser?.uid{
                cell.loveButton.isSelected = true
                cell.loveButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }else{
                cell.loveButton.isSelected = false
                cell.loveButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
        return cell
    }
}
extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.systemGray5
    }
}
extension HomeViewController{
    func getAllPosts(compaltion: @escaping (Bool)->()){
        compaltion(false)
        ref.child("AllPosts").observe(.childAdded){ snap in
            if let value = snap.value as? [String: Any] {
                let posts = PostsModel()
                guard let post = value["Post"] as? String, let imagePost = value["imagePost"] as? String, let love = value["Love"] as? Int, let userID = value["UserID"] as? String else{
                    return
                }
                posts.postID = snap.key
                posts.bodyPost = post
                posts.imagePost = imagePost
                posts.love = love
                posts.userID = userID
                if let whoLovePost = value["WhoLovePost"] as? [String: Any]{
                    for (_,key) in whoLovePost{
                        posts.whoLovePost.append(key as! String)
                    }
                }
                self.arrOfPosts.append(posts)
                self.homeTableView.reloadData()
                print("Arr of posts:", self.arrOfPosts)
                compaltion(true)
            }
        }
    }
}
extension HomeViewController{
    func loveButtonSelected(postID: String, personLikePostID: String, userID: String, indexPathRow: Int, complation: @escaping (Bool)->()){
        self.ref.child("AllPosts").child(postID).updateChildValues(["WhoLovePost/\(personLikePostID)" : userID]) { (error, dataSnap) in
            if error == nil{
                self.getNumberOfLove(postID: postID) { (count) in
                    self.ref.child("AllPosts").child(postID).updateChildValues(["Love": count])
                    self.arrOfPosts[indexPathRow].love = count
                    complation(true)
                }
            }
        }
        ref.removeAllObservers()
    }
}
extension HomeViewController{
    func loveButtonNonSelected(postID: String, userID: String, indexPathRow: Int, complation: @escaping (Bool)->()){
        ref.child("AllPosts").child(postID).observeSingleEvent(of: .value){ (dataSnap) in
            if let value = dataSnap.value as? [String: Any]{
                guard let whoLovePost = value["WhoLovePost"] as? [String: Any] else {return}
                for (id,val) in whoLovePost{
                    if val as! String == userID{
                        self.ref.child("AllPosts").child(postID).child("WhoLovePost").child(id).removeValue { (error, dataSnap) in
                            if error == nil {
                                self.getNumberOfLove(postID: postID) { (count) in
                                    self.ref.child("AllPosts").child(postID).updateChildValues(["Love": count])
                                    self.arrOfPosts[indexPathRow].love = count
                                    complation(true)
                                }
                            }
                        }
                    }
                }
            }
        }
        ref.removeAllObservers()
    }
}
extension HomeViewController{
    func getNumberOfLove(postID: String, complation: @escaping (Int)->()){
        self.ref.child("AllPosts").child(postID).observeSingleEvent(of: .value) { (dataSnap) in
             if let value = dataSnap.value as? [String: Any]{
                 if let whoLovePost = value["WhoLovePost"] as? [String: Any]{
                     let countLove = whoLovePost.count
                     complation(countLove)
                 }else{
                     complation(0)
                 }
             }
         }
        ref.removeAllObservers()
     }
}
