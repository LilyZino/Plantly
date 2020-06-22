//
//  MyPostsTableViewCell.swift
//  Plantly
//
//  Created by admin on 20/06/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit

class MyPostsTableViewCell: UITableViewCell {

    @IBOutlet weak var avater: UIImageView!
    
    @IBOutlet weak var myName: UILabel!
    
    @IBOutlet weak var postImg: UIImageView!
    
    @IBOutlet weak var postText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avater.layer.borderWidth = 1
        avater.layer.masksToBounds = false
        avater.layer.borderColor = UIColor.black.cgColor
        avater.layer.cornerRadius = avater.frame.height / 2
        avater.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
