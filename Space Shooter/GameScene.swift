//
//  GameScene.swift
//  Space Shooter
//
//  Created by Jas on 11/21/16.
//  Copyright © 2016 Saini. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory
{
    static let Enemies: UInt32 = 1
    static let Bullets: UInt32 = 2
    static let Player: UInt32 = 3
}

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var Player = SKSpriteNode(imageNamed: "Spaceship")
    var Score = Int()
    var ScoreLabel = UILabel()
    
    override func didMove(to view: SKView)
    {
        scene?.anchorPoint = CGPoint(x: 0, y: 0) //Lays out x and y coordinate system based on bottom left corner//
        physicsWorld.contactDelegate = self
        
        Player.position = CGPoint(x: self.size.width/2, y: self.size.height/5) // Sets original Player Position//
        
        Player.physicsBody = SKPhysicsBody(rectangleOf: Player.size)
        Player.physicsBody?.affectedByGravity = false
        Player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        Player.physicsBody?.contactTestBitMask = PhysicsCategory.Enemies
        Player.physicsBody?.isDynamic = false
        
        self.addChild(Player) //Add Player Node to the Screen//
        
        ScoreLabel.text = "  Score: \(Score)"
        ScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        ScoreLabel.backgroundColor = backgroundColor
        ScoreLabel.textColor = UIColor.white
        self.view?.addSubview(ScoreLabel)
        
        var BulletsTimer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(GameScene.Bullets), userInfo: nil, repeats: true)
        var EnemiesTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameScene.Enemies), userInfo: nil, repeats: true)
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        
        if ((firstBody.categoryBitMask == PhysicsCategory.Enemies) && (secondBody.categoryBitMask == PhysicsCategory.Bullets) || (firstBody.categoryBitMask == PhysicsCategory.Bullets) && (secondBody.categoryBitMask == PhysicsCategory.Enemies))
        {
            collisionWithBullet(Enemies: firstBody.node as! SKSpriteNode, Bullets: secondBody.node as! SKSpriteNode)
        }
        
        else if ((firstBody.categoryBitMask == PhysicsCategory.Enemies) && (secondBody.categoryBitMask == PhysicsCategory.Player) || (firstBody.categoryBitMask == PhysicsCategory.Player) && (secondBody.categoryBitMask == PhysicsCategory.Enemies))
        {
            collisionWithPlayer(Enemies: firstBody.node as! SKSpriteNode, Player: secondBody.node as! SKSpriteNode)
        }
    }
    
    func collisionWithBullet(Enemies: SKSpriteNode, Bullets: SKSpriteNode)
    {
        Enemies.removeFromParent()
        Bullets.removeFromParent()
        Score += 1
        
        ScoreLabel.text = " Score: \(Score)"
    }
    
    func collisionWithPlayer(Enemies: SKSpriteNode, Player: SKSpriteNode)
    {
        Enemies.removeFromParent()
        Player.removeFromParent()
        
        self.view?.presentScene(SKScene(fileNamed: "GameOver"))
        ScoreLabel.backgroundColor = UIColor.black
    }
    
    func Bullets()
    {
        let Bullets = SKSpriteNode(imageNamed: "Bullet")
        
        Bullets.zPosition = -5
        Bullets.position = CGPoint(x: Player.position.x, y: Player.position.y)
        
        Bullets.physicsBody = SKPhysicsBody(rectangleOf: Bullets.size)
        Bullets.physicsBody?.affectedByGravity = false
        Bullets.physicsBody?.categoryBitMask = PhysicsCategory.Bullets
        Bullets.physicsBody?.contactTestBitMask = PhysicsCategory.Enemies
        Bullets.physicsBody?.isDynamic = false
        
        
        let fire = SKAction.moveTo(y: self.size.height + 30, duration: 0.8)
        let shotsFired = SKAction.removeFromParent()
        
        Bullets.run(SKAction.sequence([fire, shotsFired]))
        
        self.addChild(Bullets)
    }
    
    func Enemies()
    {
        let Enemies = SKSpriteNode(imageNamed: "Enemy")
        let Min = self.size.width/8
        let Max = self.size.width - 20
        let SpawnEnemy = UInt32(Max - Min)
        
        Enemies.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnEnemy)), y: self.size.height)
        
        Enemies.physicsBody = SKPhysicsBody(rectangleOf: Enemies.size)
        Enemies.physicsBody?.affectedByGravity = false
        Enemies.physicsBody?.categoryBitMask = PhysicsCategory.Enemies
        Enemies.physicsBody?.contactTestBitMask = PhysicsCategory.Bullets
        Enemies.physicsBody?.isDynamic = true

        
        let EnemyAttack = SKAction.moveTo(y: -70, duration: 5.0)
        let enemyAttacked = SKAction.removeFromParent()
        
        Enemies.run(SKAction.sequence([EnemyAttack, enemyAttacked]))
        
        self.addChild(Enemies)
    }
    
    func touchDown(atPoint pos : CGPoint)
    {
        
    }
    
    func touchMoved(toPoint pos : CGPoint)
    {
        
    }
    
    func touchUp(atPoint pos : CGPoint)
    {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches
        {
            self.touchDown(atPoint: t.location(in: self))
            Player.position.x = t.location(in: self).x  //Moves player postion to the x position of touch location//
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches
        {
            self.touchMoved(toPoint: t.location(in: self))
            Player.position.x = t.location(in: self).x  //Moves player postion to the x position of touch location (Allows user to drag object and move across x position)//
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches
        {
            self.touchUp(atPoint: t.location(in: self))
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for t in touches
        {
            self.touchUp(atPoint: t.location(in: self))
        }
    }
    
    
    override func update(_ currentTime: TimeInterval)
    {
        // Called before each frame is rendered
    }
}
