//
//  EditPostViewController.swift
//  Plantly
//
//  Created by admin on 21/06/2020.
//  Copyright © 2020 Plants. All rights reserved.
//

import UIKit

class EditPostViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var post:Post!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true;
        // Close keyboard on outside tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        if post?.photo != "" && post?.photo != nil {
            postPhoto.kf.setImage(with: URL(string: post.photo!));
        }
        oldText.text = post?.postText
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.activityIndicator.isHidden = true;
        // Close keyboard on outside tap
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.saveButton.isHidden = false
        self.editPhotoButton.isEnabled = true
    }
    
    @IBOutlet weak var postPhoto: UIImageView!
    
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBAction func editPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var oldText: UILabel!
    @IBOutlet weak var newText: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func save(_ sender: UIButton) {
        self.activityIndicator.isHidden = false
        self.saveButton.isHidden = true
        self.editPhotoButton.isEnabled = false
        var updatedText = oldText.text!
        if newText.text != "" {
            updatedText = newText.text!
        }
        if let image = selectedImage{
            postsModel.postsInstance.saveImage(image: image) { (url) in
                print("saved image url \(url)");
                let newPost = Post(id: self.post.id, name:userModel.userInstance.currentUser.userName, text:updatedText, photo:url);
                postsModel.postsInstance.editPost(post: newPost) {
                    self.navigationController?.popViewController(animated: true);
                    self.navigationController?.popViewController(animated: true);
                }
            }
        } else {
            let newPost = Post(id: self.post.id, name:userModel.userInstance.currentUser.userName, text:updatedText, photo:self.post.photo!);
            postsModel.postsInstance.editPost(post: newPost) {
                self.navigationController?.popViewController(animated: true);
                self.navigationController?.popViewController(animated: true);
            }
        }
        
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deletePost(_ sender: UIButton) {
        postsModel.postsInstance.deletePost(post: self.post) {
            self.navigationController?.popViewController(animated: true);
            self.navigationController?.popViewController(animated: true);
        }
    }
    
    // Close keyboard on return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    var selectedImage:UIImage?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage;
        self.postPhoto.image = selectedImage;
        dismiss(animated: true, completion: nil);
    }
}
