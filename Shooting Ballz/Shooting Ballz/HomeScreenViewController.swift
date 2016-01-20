//
//  HomeScreenViewController.swift
//  Shooting Ballz
//
//  Created by Filza Mazahir on 1/19/16.
//  Copyright © 2016 Filza Mazahir. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    

    @IBOutlet weak var nameTextField: UITextField!
    
    //Create a socket connection when Start Game is pressed
    @IBAction func startGameButtonPressed(sender: UIButton) {
        
    }
    
    //To hide keyboard when you press return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Pass the socket to Game View Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "StartGame"{
        
            let gameViewController = segue.destinationViewController as! GameViewController
            gameViewController.currentPlayer = self.nameTextField.text!
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }


}
