//
//  RegisterViewController.swift
//  Plantly
//
//  Created by admin on 18/06/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBOutlet weak var userText: UITextField!
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    @IBAction func register(_ sender: UIButton) {
        userModel.userInstance.register(username: userText.text!, email: emailText.text!, pwd: passwordText.text!){ (success) in
            if (success) {
            } else {
                print("register failed")
            }
        }
    }
}
