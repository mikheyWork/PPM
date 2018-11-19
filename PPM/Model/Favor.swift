//
//  Favor.swift
//  ppmiPhone2
//
//  Created by softevol on 10/23/18.
//  Copyright © 2018 softevol. All rights reserved.
//

import Foundation
import Firebase

struct Favor {
    let favArray: [String]
    let userId: String
    let ref: DatabaseReference?
    
    init(favArray: [String],userId: String) {
        self.favArray = favArray
        self.userId = userId
        self.ref = nil
        
    }
    
    init(snapShot: DataSnapshot) {
        let snapShotValue = snapShot.value as! [String: AnyObject]
        favArray = snapShotValue["favor"] as! [String]
        userId = snapShotValue["userId"] as! String
        ref = snapShot.ref
    }
}
