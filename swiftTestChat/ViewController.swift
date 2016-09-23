//
//  ViewController.swift
//  swiftTestChat
//
//  Created by Alan Valdez on 9/19/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var loggedUser : FIRUser!
    var authReference : FIRAuth!
    var userID = "default"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        authReference = FIRAuth.auth()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAnonimously(_ sender: UIButton) {
        authReference?.signInAnonymously() { (user, error) in
            if error != nil {
                print(error)
                return
            }
            
            self.loggedUser = user
            self.performSegue(withIdentifier: "loggedIn", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        let newView = segue.destination as! UINavigationController
        
        let chatView = newView.viewControllers.first as! ChatViewController
        
        chatView.navigationItem.title = "Swift Firebase Chat"
        
        chatView.senderId = self.loggedUser.uid
        chatView.senderDisplayName = ""
    }
}

