//
//  LoginViewController.swift
//  Plantly
//
//  Created by admin on 18/06/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate {
    func onLoginSuccess();
    func onLoginCancell();
}

class LoginViewController: UIViewController {
    
    var delegate:LoginViewControllerDelegate?
    static func factory()->LoginViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true);
        
        if let delegate = delegate{
            delegate.onLoginCancell()
        }
    }
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func login(_ sender: UIButton) {
        userModel.userInstance.login(email: emailText.text!, pwd: passwordText.text!) { (success) in
            if (success) {
                self.navigationController?.popViewController(animated: true);
                if let delegate = self.delegate{
                    delegate.onLoginSuccess()
                }
            } else {
                print("login failed")
            }
        }
    }
}
