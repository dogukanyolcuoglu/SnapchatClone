//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Dogukan Yolcuoglu on 17.03.2021.
//

import UIKit
import Firebase

class UploadVC: UIViewController , UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageview: UIImageView!
    
    //MARK: - State funcs
    override func viewDidLoad() {
        super.viewDidLoad()

        imageSettings()
    }
    
    //MARK: - IBAction
    @IBAction func uploadButtonClicked(_ sender: Any) {
        
        
        // Storage
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("media")
        
        if let data = imageview.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageRef = mediaFolder.child("\(uuid).jpg")
            
            imageRef.putData(data, metadata: nil) { (metadata, error) in
                
                if error != nil {
                    
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error   ")
                    
                } else {
                    
                    imageRef.downloadURL { (url, error) in
                        
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            
                            
                            // Firestore
                            
                            let firestore = Firestore.firestore()
                            
                            firestore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { (snapshot, error) in
                                
                                
                                if error != nil {
                                    
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                    
                                } else {
                                    
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        
                                        for document in snapshot!.documents {
                                            
                                            let documentID = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                        
                                                imageUrlArray.append(imageUrl!)
                                                
                                                let additionalDictonary = ["imageUrlArray" : imageUrlArray] as [String : Any]
                                                
                                                firestore.collection("Snaps").document(documentID).setData(additionalDictonary, merge: true) { (error) in
                                                    
                                                    if error == nil {
                                                        
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.imageview.image = UIImage(named: "image.png")
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    } else {
                                         
                                        let snapDictonary = ["imageUrlArray" : [imageUrl!] , "snapOwner" : UserSingleton.sharedUserInfo.username, "date" : FieldValue.serverTimestamp()] as [String : Any]
                                            
                                        firestore.collection("Snaps").addDocument(data: snapDictonary) { (error) in
                                            
                                            if error != nil {
                                                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                                
                                            } else {
                                                
                                                self.tabBarController?.selectedIndex = 0
                                                self.imageview.image = UIImage(named: "image.png")
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    //MARK: - Funcs
    
    func imageSettings() {
    
        imageview.isUserInteractionEnabled = true
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        
        imageview.addGestureRecognizer(recognizer)
    
    }
    
    @objc func chooseImage(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageview.image = info[.originalImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(title: String , message: String) {
        
        let alert = UIAlertController(title: title , message: message , preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
}
