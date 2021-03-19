//
//  SignInVC.swift
//  SnapchatClone
//
//  Created by Dogukan Yolcuoglu on 17.03.2021.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    //MARK: - State funcs
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - IBActions
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (auth, error) in
                
                if error != nil {
                    
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                    
                } else {
                 
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
            }
        }else {
            self.makeAlert(title: "Error", message: "Passowrd / Email ?")
            
        }
 
    }
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        if emailText.text != "" && usernameText.text != "" && passwordText.text != "" {
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (auth, error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                    
                } else {
                    
                    let firestore = Firestore.firestore()
                    
                    let userDictonary = ["email" : self.emailText.text! , "username" : self.usernameText.text!] as [String : Any]
                    
                    firestore.collection("userInfo").addDocument(data: userDictonary) { (error) in
                            
                        if error != nil {
                            
                            self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                        } else {
                            
                            self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                            
                        }
                        
                    }
                    
                    
                }
                
            }
        } else {
            
            self.makeAlert(title: "Error", message: "Username / Password / Email ?")
            
        }
        
    }
    
    //MARK: - Funcs
    
    func makeAlert(title: String , message: String) {
        
        let alert = UIAlertController(title: title , message: message , preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
}

