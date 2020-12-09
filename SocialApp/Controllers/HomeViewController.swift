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
class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    var menu: SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCurrentUser()
        setUpTableView()
        setUpMenu()
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.systemPink
        self.navigationController?.navigationBar.backgroundColor = UIColor.systemPink
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
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        return cell
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
