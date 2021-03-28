//
//  CDservice.swift
//  GoCar
//
//  Created by Thien Nguyen on 9/3/21.
//

import Foundation
import CoreData
import UIKit

public class CDService{
    var context : NSManagedObjectContext
    
    init(){
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    public func addUser(email: String, password: String){
        
        self.clear()
        let newUser = LocalUser(context: self.context)
        newUser.email = email
        newUser.password = password
        print(newUser.email!)
        do{
            try self.context.save()
            
        }
        catch{
            print("Error when saving")
        }
    }
    
    public func clear(){
        do{
            print("clearing")
            let users = try self.context.fetch(LocalUser.fetchRequest()) as! [LocalUser]
            for u in users{
                self.context.delete(u)
                try self.context.save()
            }
            
            let us = try self.context.fetch(LocalUser.fetchRequest()) as! [LocalUser]
            for u in us{
                print(u.email!)
            }
        }
        catch{
            print("Error when deleting")
        }
    }
    
    public func load() -> LocalUser {
        
        var usr = LocalUser(context: self.context)
        usr.email = ""
        usr.password = ""
        do{
            let users = try self.context.fetch(LocalUser.fetchRequest()) as! [LocalUser]
            for u in users{
                if u.email! != "" && u.password! != "" {
                    usr = u
                }
               
            }
        }
        catch{
            print("Error when deleting")
        }
        return usr
    }
    
   
}
