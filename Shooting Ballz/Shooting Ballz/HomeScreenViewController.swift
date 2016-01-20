//
//  HomeScreenViewController.swift
//  Shooting Ballz
//
//  Created by Filza Mazahir on 1/19/16.
//  Copyright © 2016 Filza Mazahir. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    var socket: SocketIOClient?

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func startGameButtonPressed(sender: UIButton) {
        
        socket = SocketIOClient(socketURL: "http://192.168.1.42:5000")
        socket?.connect()
        
        socket?.on("connect") { data, ack in
            print("iOS::WE ARE USING SOCKETS!")
            
            self.socket?.emit("newUserConnected", self.nameTextField.text!)
        }

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "StartGame"{
        
            let gameViewController = segue.destinationViewController as! GameViewController
            gameViewController.socket = socket
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
