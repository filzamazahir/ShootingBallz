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
    var startGameLabel: SKLabelNode?
    var currentPlayer: String?
    var players = [String]()
    var playerOneScored: Bool = false
    var playerTwoScored: Bool = false
    var playerLocation: CGPoint?
    var ballSprite: SKSpriteNode?
    var ballLocation: CGPoint?
    var gameStart: Int = 0
    
    var playerOne: Player?, playerTwo: Player?
    var scoreOne: Int = 0
    var scoreTwo: Int = 0
    
    var ballCreated = false
    
    let arrayOfBalls  = ["baseball", "basketball", "puck", "tennisball", "golfball", "football"]
    
    
    var initiatedOnce: Bool = false

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
//        let bgImage = SKSpriteNode(imageNamed: "baseball_bkg")
//        bgImage.position = CGPointMake(self.size.width/2, self.size.height/2)
        

        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Shooting Ballz"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame)-50)
        
        startGameLabel = SKLabelNode(fontNamed: "Chalkduster")
        startGameLabel!.text = "Tap to start"
        startGameLabel!.fontSize = 40
        startGameLabel!.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        socket = SocketIOClient(socketURL: "http://192.168.1.59:5000")
        // Filza 192.168.1.42
        // Jimmy 192.168.1.59
        socket?.connect()
        
        socket?.on("connect") { data, ack in
            print("iOS::WE ARE USING SOCKETS!")
            
            self.socket?.emit("newUserConnected", self.currentPlayer!)
        }

        socket!.on("updatePlayers") { data , ack in
            print("All players: \(data)")
            self.players = []
            
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
        
        //self.addChild(bgImage)
        self.addChild(myLabel)
        self.addChild(startGameLabel!)
    }
    
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            
            if gameStart == 0 {
                if initiatedOnce == false {
                    initiateGame()
                    initiatedOnce = true
                }
                socket?.emit("gameStarted")
                startGameLabel!.hidden = true
                gameStart = 1
                return
            }
            
            playerLocation = touch.locationInNode(self)
            
            playerPressedBall()
            
            
//            let xy: Location = Location(x: Float(location.x), y: Float(location.y))
            
            
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
            
            
            
            
            

        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if gameStart == 0 {
            print("gameStart in update", gameStart)
            
            socket?.on("startGame") { data, ack in
                if self.initiatedOnce == false {
                    // self.initiateGame()
                    self.initiatedOnce = true
                }
                
                self.startGameLabel!.hidden = true
                self.gameStart = 1
            }
        }
        
        //TODO: BUGGGGGGGGGGG
        //Listen to this in intervals..otherwise it hears one socket over 100 times
        if self.ballCreated == false {
            socket?.on("updateBalls") { data, ack in
            
                print("listening to updateBalls", data)
                let ballIndexsocket = data[0]
                let ballYPositionsocket = data[1]
                let ballSpeedsocket = data[2]
                
                // create ball with these variables FOR player who didnt press tap
                self.createRandomBallParameters(ballIndexsocket as! Int, height: ballYPositionsocket as! CGFloat, speed: ballSpeedsocket as! CGFloat)
                self.ballCreated = true
            }
            
            
        }
        
        
        
        // Boolean to check to see if player one or player two scored
        if playerOneScored == true {
            self.scoreOne += 10
            socket?.emit("playerOneScored", self.scoreOne)
            updateScores()
            playerOneScored = false
        } else if playerTwoScored == true {
            self.scoreTwo += 10
            socket?.emit("playerTwoScored", self.scoreTwo)
            updateScores()
            playerTwoScored = false
        }
        
        
    }
    
    //Create Player Labels
    func createPlayerLabel(number: Int, name: String) {
        if number == 1 {
            if let _ = playerOne?.playerName {
                return
            }
            playerOne = Player(playerName: name)
            let playerOneScoreLabel = SKLabelNode(fontNamed: "Courier")
            playerOneScoreLabel.name = "playerOne"
            playerOneScoreLabel.fontSize = 25
            if let playerOneName = playerOne?.playerName {
                
                playerOneScoreLabel.text = String(format: "\(playerOneName): %04u", scoreOne)
            }
            
            playerOneScoreLabel.horizontalAlignmentMode = .Right
            playerOneScoreLabel.position = CGPoint(x: frame.size.width / 2, y: size.height - (90 + playerOneScoreLabel.frame.size.height/2))
            addChild(playerOneScoreLabel)
        }
        else if number == 2 {
            playerTwo = Player(playerName: name)
            let playerTwoScoreLabel = SKLabelNode(fontNamed: "Courier")
            playerTwoScoreLabel.name = "playerTwo"
            playerTwoScoreLabel.fontSize = 25
            if let playerTwoName = playerTwo?.playerName {
                playerTwoScoreLabel.text = String(format: "\(playerTwoName): %04u", scoreTwo)
            }
            
            playerTwoScoreLabel.horizontalAlignmentMode = .Right

            playerTwoScoreLabel.position = CGPoint(x: frame.size.width / 2, y: size.height - (130 + playerTwoScoreLabel.frame.size.height/2))

            addChild(playerTwoScoreLabel)
        }
        
        
    }
    
    
    // Update scores together
    func updateScores() {
        socket!.on("updatePlayerOneScore") { data, ack in
            print("Player 1 updated score: \(data[0]) and previously had \(self.scoreOne), current player is \(self.currentPlayer)")
            
            self.ballSprite!.hidden = true
            let playerOneLabel = self.childNodeWithName("playerOne") as! SKLabelNode
            if let playerOneName = self.playerOne?.playerName {
                self.scoreOne = data[0] as! Int
                
                playerOneLabel.text = String(format: "\(playerOneName): %04u", self.scoreOne)
            }
        }
        
        // EXTRA Socket Listener -- Make changes later
//        socket!.on("hideBall") { data, ack in
//            self.ballSprite!.hidden = true
//        }

        
        socket!.on("updatePlayerTwoScore") { data, ack in
            print("Player 2 updated score: \(data[0]) and previously had \(self.scoreTwo), current player is \(self.currentPlayer)")
            
            self.ballSprite!.hidden = true
            let playerTwoLabel = self.childNodeWithName("playerTwo") as! SKLabelNode
        
            if let playerTwoName = self.playerTwo?.playerName {
                self.scoreTwo = data[0] as! Int
                playerTwoLabel.text = String(format: "\(playerTwoName): %04u", self.scoreTwo)
            }
        }
        
        
        
    }
    
    // Functions to add random balls
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func createRandomBallParameters(ballIndex: Int, height: CGFloat, speed: CGFloat) {
        
        let ball = SKSpriteNode(imageNamed:arrayOfBalls[ballIndex])
        ball.position = CGPoint(x: size.width + ball.size.width/2, y: height)
        
        // set the GLOBAL ballLocation variable
        ballSprite = ball
        ballLocation = ball.position
        
        // add ball to scene
        addChild(ball)
        
        // create the actions of the ball
        let actionMove = SKAction.moveTo(CGPoint(x: -ball.size.width/2, y: height), duration: NSTimeInterval(speed))
        let actionMoveDone = SKAction.removeFromParent()
        ball.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        
        
    }
    
    
    func addSportsBall() {
        
        // create a random ball
        
        
        let ballIndex = Int(arc4random_uniform(6))
        
        let ball = SKSpriteNode(imageNamed:arrayOfBalls[ballIndex])
        
        // determine where to spawn ball along Y-axis
        let actualY = random(min: ball.size.height/2, max: size.height - ball.size.height/2)
        
        // position the ball slightly off-screen along the right edge and along random position along Y axis
        ball.position = CGPoint(x: size.width + ball.size.width/2, y: actualY)
        
        // set the GLOBAL ballLocation variable
        ballSprite = ball
        ballLocation = ball.position
        
        // add ball to scene
        addChild(ball)
        
        // determine speed of the ball
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        //Filza - emitting ball details to sync
        socket?.emit("ballCreated", [ballIndex, actualY, actualDuration])
        
        // create the actions of the ball
        let actionMove = SKAction.moveTo(CGPoint(x: -ball.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        ball.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    // Initate Game
    func initiateGame() {
        print("game is starting NOW!")
        // run code that sends out the balls in 4 second intervals
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addSportsBall),
                SKAction.waitForDuration(4.0)
                ])
            ))

    }
    
    // Player Pressed Ball Function
    func playerPressedBall() {
        // Checking to see if player's Y-axis location is the same as the ball's y-axis location
        
        let playerPressedLocation = Int(playerLocation!.y)
        let maxBallLocation = Int(ballLocation!.y) + Int(ballSprite!.size.height / 2)
        let minBallLocation = Int(ballLocation!.y) - Int(ballSprite!.size.height / 2)
        
//        let maxBallLocation = Int(ballLocation!.y) + 10
//        let minBallLocation = Int(ballLocation!.y) - 10
        
        
        if playerPressedLocation <= maxBallLocation && playerPressedLocation >= minBallLocation {
            // ADDED BALL SPRITE TO HIDE
            ballSprite?.hidden = true
            print("Ball being hit", currentPlayer, "Ball Sprite name: \(ballSprite!.name)")
            socket?.emit("ballHit")
            
            
            // Check for current player to update scores later
            print("currentPlayer: ", currentPlayer)
            if currentPlayer == playerOne?.playerName {
                playerOneScored = true
            } else if currentPlayer == playerTwo?.playerName {
                playerTwoScored = true
            }
            
            
        }
        
        
    }
}
