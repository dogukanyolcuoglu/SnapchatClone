//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Dogukan Yolcuoglu on 17.03.2021.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    //MARK: - Variables
    
    let firestoreDatabase = Firestore.firestore()
    var snapArray = [Snap]()
    
    var chosenSnap : Snap?
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - State funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //self.tableView.tableFooterView = UIView()
        
        getUserInfo()
        getSnapsFromFirebase()

    }
    
    
    //MARK: - Funcs
    func getSnapsFromFirebase() {
     
        firestoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            
            if error != nil {
                
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error" )
            }else {
                
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    self.snapArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String {
                            
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                
                                if let date = document.get("date") as? Timestamp {
                                    
                                    
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour{
                                        
                                        if difference >= 24 {
                                            
                                            self.firestoreDatabase.collection("Snaps").document(documentId).delete { (error) in
                                                
                                                
                                            }
                                            
                                        } else {
                                            
                                            let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeLeft: 24 - difference)
                                            self.snapArray.append(snap)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }

        }
        
        
    }
    
    func getUserInfo() {
        
        
        firestoreDatabase.collection("userInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in
        
            if error != nil {
                
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                
            } else {
                
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    for document in snapshot!.documents {
                        
                        if let username = document.get("username") as? String {
                            
                            UserSingleton.sharedUserInfo.username = username
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                        }
                    } 
                }
            }
        }
        
    }
    
    func makeAlert(title: String , message: String) {
        
        let alert = UIAlertController(title: title , message: message , preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FeedCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FeedCell
        
        cell.imageviewCell.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        cell.usernameCell.text = snapArray[indexPath.row].username
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            
            let destinationVC = segue.destination as! SnapVC
            destinationVC.selectedSnap = chosenSnap
        }
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
}
