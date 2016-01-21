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
    var players = [String]()
    var playerOneScored: Bool = false
    var playerTwoScored: Bool = false
    var ballPressed: Bool = false
    var playerLocation: CGPoint?
    var ballLocation: CGPoint?
    
    var playerOne: Player?, playerTwo: Player?
    var score: Int = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Shooting Ballz"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        socket = SocketIOClient(socketURL: "http://192.168.1.59:5000")
        // http://192.168.1.42
        socket?.connect()
        
        socket?.on("connect") { data, ack in
            print("iOS::WE ARE USING SOCKETS!")
            
            self.socket?.emit("newUserConnected", self.currentPlayer!)
        }
        
        print("funnnnay")

        socket!.on("updatePlayers") { data , ack in
            print("All players: \(data)")

            
            for player in data{
                print("Player: \(player)")

                if player is NSNull {
                    //do nothing
                }
                
                else {
                    self.players.append(player as! String)
                }
               
            }
            
            print(self.players)
            for var i=0; i<self.players.count; ++i {
                self.createPlayerLabel(i+1, name: self.players[i])
            }
            
            
            
            
            
        }
        
        
        // run code that sends out the balls in 4 second intervals
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addSportsBall),
                SKAction.waitForDuration(4.0)
                ])
            ))

        
//        socket!.on("newUserJoinedServer") { data, ack in
//            
//            print("user joined in Game Scene: \(data)")
//            
//            if self.playerOne == nil {
//                self.createPlayerOneLabel(data[0] as! String)
//            }
//            else if self.playerOne != nil && self.playerTwo == nil {
//                self.createPlayerTwoLabel(data[0] as! String)
//
//            }
//            
//            else if self.playerOne != nil && self.playerTwo != nil && self.playerThree == nil{
//                // create Player Three Label
//            }
//            
//            else if self.playerOne != nil && self.playerTwo != nil && self.playerThree != nil && self.playerFour == nil{
//                // create Player Four Label
//            }
//            
//            
//        }
        
        
        self.addChild(myLabel)
        
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            
            playerLocation = touch.locationInNode(self)
            //let xy: Location = Location(x: Float(location.x), y: Float(location.y))
            
            
//            socket?.emit("x", location.x)
//            socket!.on("updateXLocation") { data, ack in
//                print("x data in updatePlayer", data)
//                let xCrd: CGFloat = CGFloat(data[0] as! NSNumber)
//                
//            }
//            
//            socket?.emit("y", location.y)
//            socket!.on("updateYLocation") { data, ack in
//                print("y data in updatePlayer", data)
//                let yCrd: CGFloat = CGFloat(data[0] as! NSNumber)
//            }
            
//            playerLocation = CGPoint(x: xCrd, y: yCrd)
            
            
            // JIMMY: Checking to see if player's Y-axis location is the same as the ball's y-axis location
            // NOT YET WORKING ON INDIVIDUAL BALLS
            if playerLocation!.y == ballLocation!.y {
                
                
                
                // JIMMY: Boolean to check to see if ball has been pressed
                // NOT WORKING YET
                ballPressed = true
                
                // CHECK FOR CURRENT PLAYER
                print("currentPlayer: ", currentPlayer)
                if currentPlayer == playerOne?.playerName {
                    playerOneScored = true
                } else if currentPlayer == playerTwo?.playerName {
                    playerTwoScored = true
                }
                
                
            }
            
            

            
            
            
            
//            
//            let arrayOfBalls: Array = ["baseball", "basketball", "puck", "tennisball", "golfball", "football"]
//            
//            let rand = Int(arc4random_uniform(6))
//            
//            let sprite = SKSpriteNode(imageNamed:arrayOfBalls[rand])
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
            
            
            
            
            
            
//            if let playerOneName = playerOne?.playerName {
//                if playerOneName == currentPlayer {
//                    print("Score one for player 1")
//                    increasePlayerOneScore(10)
//                }
//            } else if let playerTwoName = playerTwo?.playerName {
//                if playerTwoName == currentPlayer {
//                    print("Score one for player 2")
//                    increasePlayerTwoScore(10)
//                }
//            }
            
            
            //            controller.increasePlayerOneScore()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
        
        
        
        
        // JIMMY: Boolean to check to see if player one or player two scored
        // NOT WORKING ON INDIVIDUAL BALLS YET
        if playerOneScored == true {
            increasePlayerOneScore(10)
            playerOneScored = false
        } else if playerTwoScored == true {
            increasePlayerTwoScore(10)
            playerTwoScored = false
        }
        
        
        
        
        
        
        
        
//        socket?.emit("x", location.x)
//        socket!.on("updateXLocation") { data, ack in
//            print("x data in updatePlayer", data)
//            let xCrd: CGFloat = CGFloat(data[0] as! NSNumber)
//            
//        }
//        
//        socket?.emit("y", location.y)
//        socket!.on("updateYLocation") { data, ack in
//            print("y data in updatePlayer", data)
//            let yCrd: CGFloat = CGFloat(data[0] as! NSNumber)
//        }
        
        
        
        
        
        
        // Check to see if ball was pressed
        // JIMMY: Will add functionality to score points as balls are being passed through
        
        if ballPressed == true {
            
//            let arrayOfBalls: Array = ["baseball", "basketball", "puck", "tennisball", "golfball", "football"]
//            
//            let rand = Int(arc4random_uniform(6))
//            
//            let sprite = SKSpriteNode(imageNamed:arrayOfBalls[rand])
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = playerLocation!
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
            
            
            // USED TO RESET THE BALL PRESSED BOOLEAN
            ballPressed = false
            
        }
        
        
        
        
        
        
        
        
    }
    
    func createPlayerLabel(number: Int, name: String) {
        if number == 1 {
            playerOne = Player(playerName: name)
            let playerOneScoreLabel = SKLabelNode(fontNamed: "Courier")
            playerOneScoreLabel.name = "playerOne"
            playerOneScoreLabel.fontSize = 25
            if let playerOneName = playerOne?.playerName {
                playerOneScoreLabel.text = String(format: "\(playerOneName): %04u", 0)
            }
            
            playerOneScoreLabel.horizontalAlignmentMode = .Right
            playerOneScoreLabel.position = CGPoint(x: frame.size.width / 2, y: size.height - (40 + playerOneScoreLabel.frame.size.height/2))
            addChild(playerOneScoreLabel)
        }
        else if number == 2 {
            playerTwo = Player(playerName: name)
            let playerTwoScoreLabel = SKLabelNode(fontNamed: "Courier")
            playerTwoScoreLabel.name = "playerTwo"
            playerTwoScoreLabel.fontSize = 25
            if let playerTwoName = playerTwo?.playerName {
                playerTwoScoreLabel.text = String(format: "\(playerTwoName): %04u", 0)
            }
            
            playerTwoScoreLabel.horizontalAlignmentMode = .Left
            playerTwoScoreLabel.position = CGPoint(x: frame.size.width / 2, y: size.height - (40 + playerTwoScoreLabel.frame.size.height/2))
            addChild(playerTwoScoreLabel)
        }
        
        
        
        
    }
    

    func increasePlayerOneScore(points: Int) {
        self.score += points
        
        let score = self.childNodeWithName("playerOne") as! SKLabelNode
            
        if let playerOneName = playerOne?.playerName {
//            score.text = String(format: "\(playerOneName): %04u", self.score)
            socket?.emit("playerOneScored", self.score)
            socket!.on("updatePlayerOneScore") { data, ack in
                print("data returned to all members", data, "and extracted", data[0])
                score.text = String(format: "\(playerOneName): %04u", data[0] as! Int)
            }
        }
    }
    
    func increasePlayerTwoScore(points: Int) {
        self.score += points
        
        
        let score = self.childNodeWithName("playerTwo") as! SKLabelNode
        
        if let playerTwoName = playerTwo?.playerName {
            score.text = String(format: "\(playerTwoName): %04u", self.score)
            socket?.emit("playerTwoScored", self.score)
            socket!.on("updatePlayerTwoScore") { data, ack in
                print("data returned to all members", data, "and extracted", data[0])
                score.text = String(format: "\(playerTwoName): %04u", data[0] as! Int)
            }
        }
    }
    
    // JIMMY: Functions to add random balls
    //  Click on the balls won't add points yet.  Simply clicking on screen will add the points.
    // function to add random balls
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addSportsBall() {
        
        // create a random ball
        let arrayOfBalls: Array = ["baseball", "basketball", "puck", "tennisball", "golfball", "football"]
        
        let rand = Int(arc4random_uniform(6))
        
        let ball = SKSpriteNode(imageNamed:arrayOfBalls[rand])
        
        // determine where to spawn ball along Y-axis
        let actualY = random(min: ball.size.height/2, max: size.height - ball.size.height/2)
        
        // position the ball slightly off-screen along the right edge and along random position along Y axis
        ball.position = CGPoint(x: size.width + ball.size.width/2, y: actualY)
        
        // set the GLOBAL ballLocation variable
        ballLocation = ball.position
        
        // add ball to scene
        addChild(ball)
        
        // determine speed of the ball
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // create the actions of the ball
        let actionMove = SKAction.moveTo(CGPoint(x: -ball.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        ball.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
}
