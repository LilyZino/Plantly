//
//  NewPostViewController.swift
//  Plantly
//
//  Created by admin on 07/02/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit



class NewPostViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, LoginViewControllerDelegate {
    
    func onLoginSuccess() {}
    
    func onLoginCancell() {
        self.tabBarController?.selectedIndex = 0;
    }
    
    @IBOutlet weak var PostImgView: UIImageView!
    
    @IBOutlet weak var PostTextView: UITextField!
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var UploadButton: UIButton!
    var newId = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Close keyboard on outside tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        //self.PostTextView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        if (!userModel.userInstance.isLogedIn()){
            let loginVc = LoginViewController.factory()
            loginVc.delegate = self
            show(loginVc, sender: self)
        }
        getNewId()
        self.ActivityIndicator.isHidden = true;
        self.SaveButton.isHidden = false
        self.UploadButton.isEnabled = true
    }
    
    // Close keyboard on return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func UploadImageButton(_ sender: UIButton) {
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
        self.PostImgView.image = selectedImage;
        dismiss(animated: true, completion: nil);
    }
    
    func getNewId() {
        postsModel.postsInstance.getLastID { id in
            self.newId = String(Int(id)! + 1)
        }
    }
    
    @IBAction func SaveButton(_ sender: UIButton) {
        self.ActivityIndicator.isHidden = false
        self.SaveButton.isHidden = true
        self.UploadButton.isEnabled = false
        
        if let image = selectedImage{
            postsModel.postsInstance.saveImage(image: image) { (url) in
                print("saved image url \(url)");
                let newPost = Post(id: self.newId, name:userModel.userInstance.currentUser.userName, text:self.PostTextView.text!, photo:url);
                postsModel.postsInstance.add(newPost) {
                self.tabBarController?.selectedIndex = 0;
                }
            }
        } else {
            let newPost = Post(id: self.newId, name:userModel.userInstance.currentUser.userName, text:self.PostTextView.text!, photo:"");
            postsModel.postsInstance.add(newPost) {
            self.tabBarController?.selectedIndex = 0;
            }
        }
    }
    
}
