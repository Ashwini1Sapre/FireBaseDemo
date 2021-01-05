//
//  GorasayItem.swift
//  FireBaseDemo
//
//  Created by Knoxpo MacBook Pro on 02/01/21.
//

import Foundation
import Firebase
import FirebaseDatabase

struct GorasayItem
{
    
    let ref: DatabaseReference?
    let key: String
    let addByUser: String
    let name: String
    let completed: Bool
    let imageurl: String
    
    init(name: String, addByUser: String, completed: Bool, imageurl: String, key:String = "") {
        
        self.ref = nil
        self.key = key
        self.addByUser = addByUser
        self.name = name
        self.completed = completed
        self.imageurl = imageurl
        
        
        
    }
    
    init? (snapshot: DataSnapshot){
        
        guard
            let value = snapshot.value as? [String : AnyObject],
            let name = value["name"] as? String,
            let addByUser = value["addByUser"] as? String,
         let completed = value["completed"] as? Bool,
        let imageurl = value["imageurl"] as? String else{
            
            return nil
            
        }
            
        self.key = snapshot.key
        self.ref = snapshot.ref
        self.name = name
        self.addByUser = addByUser
        self.completed = completed
        self.imageurl = imageurl

        
    }
    
    
    func toAnyObject() -> Any{
        
        return[
            "name": name,
            "addByUser": addByUser,
            "completed": completed,
            "imageurl": imageurl
            ]
        
        
        
    }
    
    
    
    
    
    
}
