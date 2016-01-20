//
//  GameScene.swift
//  Shooting Ballz
//
//  Created by Filza Mazahir on 1/19/16.
//  Copyright (c) 2016 Filza Mazahir. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var socket: SocketIOClient?
    var currentPlayer: String?
    
    var playerOne: Player?, playerTwo: Player?, playerThree: Player?, playerFour: Player?
    var score: Int = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        socket = SocketIOClient(socketURL: "http://192.168.1.42:5000")
        // http://192.168.1.42
        socket?.connect()
        
        socket?.on("connect") { data, ack in
            print("iOS::WE ARE USING SOCKETS!")
            
            self.socket?.emit("newUserConnected", self.currentPlayer!)
        }
        
        
        socket!.on("newUserJoinedServer") { data, ack in
            
            print("user joined in Game Scene: \(data)")
            
            if self.playerOne == nil {
                self.createPlayerOneLabel(data[0] as! String)
            }
            else if self.playerOne != nil && self.playerTwo == nil {
                self.createPlayerTwoLabel(data[0] as! String)

            }
            
            else if self.playerOne != nil && self.playerTwo != nil && self.playerThree == nil{
                // create Player Three Label
            }
            
            else if self.playerOne != nil && self.playerTwo != nil && self.playerThree != nil && self.playerFour == nil{
                // create Player Four Label
            }
            
            
        }
        
        
        self.addChild(myLabel)
        
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
            print("player one:", playerOne?.playerName)
            print("player two:", playerTwo?.playerName)
            print("player three:", playerThree?.playerName)
            print("player four:", playerFour?.playerName)
            
            if let playerOneName = playerOne?.playerName {
                increasePlayerScore(playerOneName, points: 10)
            }
            
            
            //            controller.increasePlayerOneScore()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func createPlayerOneLabel(name: String) {
        playerOne = Player(playerName: name)
        let playerOneScoreLabel = SKLabelNode(fontNamed: "Courier")
        playerOneScoreLabel.name = "playerOne"
        playerOneScoreLabel.fontSize = 25
        if let playerOneName = playerOne?.playerName {
            playerOneScoreLabel.text = String(format: "\(playerOneName): %04u", 0)
        }
        
        playerOneScoreLabel.horizontalAlignmentMode = .Right
        playerOneScoreLabel.position = CGPoint(x: frame.size.width / 2, y: size.height - (40 + playerOneScoreLabel.frame.size.height/2))
        
        //        playerOneScoreLabel.position = CGPoint(x: frame.size.width / 2, y: size.height - (40 + playerOneScoreLabel.frame.size.height/2))
        addChild(playerOneScoreLabel)
    }
    
    
    func createPlayerTwoLabel(name: String) {
        playerTwo = Player(playerName: name)
        let playerTwoScoreLabel = SKLabelNode(fontNamed: "Courier")
        playerTwoScoreLabel.name = "playerTwo"
        playerTwoScoreLabel.fontSize = 25
        if let playerTwoName = playerTwo?.playerName {
            playerTwoScoreLabel.text = String(format: "\(playerTwoName): %04u", 0)
        }
        
        playerTwoScoreLabel.horizontalAlignmentMode = .Left
        playerTwoScoreLabel.position = CGPoint(x: frame.size.width / 2, y: size.height - (40 + playerTwoScoreLabel.frame.size.height/2))
        
        //        playerOneScoreLabel.position = CGPoint(x: frame.size.width / 2, y: size.height - (40 + playerOneScoreLabel.frame.size.height/2))
        addChild(playerTwoScoreLabel)
    }
    
    func increasePlayerScore(name: String, points: Int) {
        self.score += points
        
        if name == "Player 1" {
            let score = self.childNodeWithName("playerOne") as! SKLabelNode
            
            print("Score variable", score)
            
            if let playerOneName = playerOne?.playerName {
                score.text = String(format: "\(playerOneName): %04u", self.score)
            }
        } // End of if
        
    }
}
