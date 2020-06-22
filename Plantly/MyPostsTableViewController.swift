//
//  MyPostsTableViewController.swift
//  Plantly
//
//  Created by admin on 20/06/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit

class MyPostsTableViewController: UITableViewController, LoginViewControllerDelegate {
    
    func onLoginSuccess() {}
    
    func onLoginCancell() {
        self.tabBarController?.selectedIndex = 0;
    }
    
    var data = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load page while waiting for data
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
        self.refreshControl?.beginRefreshing()
        reloadData();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        if (!userModel.userInstance.isLogedIn()){
            let loginVc = LoginViewController.factory()
            loginVc.delegate = self
            show(loginVc, sender: self)
        } else {
            reloadData();
        }
    }
    
    @objc func reloadData(){
        userModel.userInstance.getMyPosts { (_data:[Post]?) in
            if (_data != nil) {
                self.data = _data!;
                self.tableView.reloadData();
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyPostsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyPost", for: indexPath) as! MyPostsTableViewCell
        
        //Configure the cell...
        let post = data[indexPath.row]
        cell.myName.text = post.userName
        cell.postText.text = post.postText
        // Place holder for the image when it is loading
        cell.postImg.image = UIImage(named: "plant1")
        if post.photo != "" {
            cell.postImg.kf.setImage(with: URL(string: post.photo!));
        }
        cell.avater.image = UIImage(named: "avatar")
        return cell
    }
    
    var selected:Post?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = data[indexPath.row]
        performSegue(withIdentifier: "showEditScreenSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showEditScreenSegue"){
            let vc:EditPostViewController = segue.destination as! EditPostViewController
            vc.post = selected
        }
    }
    
    @IBAction func backFromEditingPost(segue:UIStoryboardSegue){
        
    }
}
