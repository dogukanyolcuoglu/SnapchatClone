//
//  SettingVC.swift
//  SnapchatClone
//
//  Created by Dogukan Yolcuoglu on 17.03.2021.
//

import UIKit
import Firebase

class SettingVC: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - IBAction
    @IBAction func logoutButtonClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignInVC", sender: nil)
        } catch {
            
            print("Error!")
        }
    
    }
    
}
