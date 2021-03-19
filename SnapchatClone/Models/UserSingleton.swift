//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Dogukan Yolcuoglu on 17.03.2021.
//

import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var username = ""
    var email = ""
    
    private init() {
        
        
    }
    
    
}
