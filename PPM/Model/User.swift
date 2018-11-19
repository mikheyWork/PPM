//
//  User.swift
//  ppmiPhone2
//
//  Created by softevol on 10/23/18.
//  Copyright © 2018 softevol. All rights reserved.
//

import Foundation
import Firebase

struct UserModel {
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
