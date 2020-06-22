//
//  ProfileViewController.swift
//  Plantly
//
//  Created by admin on 07/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LoginViewControllerDelegate {
    
    func onLoginSuccess() {}
    
    func onLoginCancell() {
        self.tabBarController?.selectedIndex = 0;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        if (!userModel.userInstance.isLogedIn()){
            let loginVc = LoginViewController.factory()
            loginVc.delegate = self
            show(loginVc, sender: self)
        }
        myName.text = userModel.userInstance.currentUser.userName
        if userModel.userInstance.currentUser.userImage != "" && userModel.userInstance.currentUser.userImage != nil {
            profileImGE.kf.setImage(with: URL(string: userModel.userInstance.currentUser.userImage!));
        }
    }
    
    @IBOutlet weak var profileImGE: UIImageView!
    @IBAction func uploadImage(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    var selectedImage:UIImage?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage;
        self.profileImGE.image = selectedImage;
        dismiss(animated: true, completion: nil);
    }
    
    @IBAction func updateImage(_ sender: UIButton) {
        if let image = selectedImage{
            postsModel.postsInstance.saveImage(image: image) {(url) in
                userModel.userInstance.currentUser.userImage = url
                userModel.userInstance.edit(userModel.userInstance.currentUser)
            }
        }
    }
    
    @IBOutlet weak var myName: UILabel!
    
    @IBAction func logout(_ sender: UIButton) {
        userModel.userInstance.logout()
    }
}
