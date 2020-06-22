//
//  PostsTableViewController.swift
//  Plantly
//
//  Created by admin on 10/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit
import Kingfisher

class PostsTableViewController: UITableViewController {
    
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
        reloadData();
    }
    
    @objc func reloadData(){
        postsModel.postsInstance.getAllPosts { (_data:[Post]?) in
            if (_data != nil) {
                self.data = _data!;
                self.tableView.reloadData();
            }
            self.refreshControl?.endRefreshing()
        };
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
        
        let cell:PostViewCell = tableView.dequeueReusableCell(withIdentifier: "Post", for: indexPath) as! PostViewCell
        
        //Configure the cell...
        let post = data[indexPath.row]
        cell.userName.text = post.userName
        cell.postText.text = post.postText
        // Place holder for the image when it is loading
        cell.img.image = UIImage(named: "plant1")
        if post.photo != "" {
            cell.img.kf.setImage(with: URL(string: post.photo!));
        }
        cell.avatar.image = UIImage(named: "avatar")
        userModel.userInstance.getUserPhoto(post.userName!) { (url) in
            if (url != "") {
                cell.avatar.kf.setImage(with: URL(string: url));
            }
        }
        return cell
    }
    @IBAction func backFromCancelLogin(segue:UIStoryboardSegue){
        
    }
}
