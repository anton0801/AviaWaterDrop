import SwiftUI
import SpriteKit

class GameFiresScene: SKScene, SKPhysicsContactDelegate {
    
    private var selectedPlane: String = UserDefaults.standard.string(forKey: "selected_plane") ?? "plane_base"
    private var selectedMap: String = UserDefaults.standard.string(forKey: "selected_background") ?? "background_new_your"
    
    private var plane: SKSpriteNode!
    
    private var planeUpBtn: SKSpriteNode!
    private var planeDownBtn: SKSpriteNode!
    private var planeSpeedUpBtn: SKSpriteNode!
    private var waterBombBtn: SKSpriteNode!
    
    private var exitGameBtn: SKSpriteNode!
    
    private var firesCountRest = 0 {
        didSet {
            firesCountRestLabel.text = "\(firesCountRest)"
            if firesCountRest == 0 {
                plane.run(SKAction.moveTo(x: size.width + 100, duration: 1.5)) {
                    self.isPaused = true
                    NotificationCenter.default.post(name: Notification.Name("plane_fire_rested"), object: nil)
                }
            }
        }
    }
    private var firesCountRestLabel: SKLabelNode!
    
    var level: Int
    
    private var waterBombVolume = 0.0 {
        didSet {
            if waterBombVolume == 100.0 {
                waterBombBtn.run(SKAction.setTexture(SKTexture(imageNamed: "water_bomb_full")))
            } else {
                waterBombBtn.run(SKAction.setTexture(SKTexture(imageNamed: "water_bomb_empty")))
            }
        }
    }
    
    private var spawnObstaclesTimer: Timer!
    private var spawnFiresTimer: Timer!
    
    init(level: Int) {
        self.level = level
        super.init(size: CGSize(width: 1350, height: 750))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gameRestartWith(level: Int) -> GameFiresScene {
        let newGameScene = GameFiresScene(level: level)
        view?.presentScene(newGameScene)
        return newGameScene
    }
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 1350, height: 750)
        physicsWorld.gravity = CGVector(dx: -1.2, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        let map = SKSpriteNode(imageNamed: selectedMap)
        map.position = CGPoint(x: size.width / 2, y: size.height / 2)
        map.size = size
        map.zPosition = -1
        addChild(map)
        
        plane = SKSpriteNode(imageNamed: selectedPlane)
        plane.position = CGPoint(x: 250, y: size.height / 2)
        plane.size = CGSize(width: 160, height: 110)
        plane.physicsBody = SKPhysicsBody(rectangleOf: plane.size)
        plane.physicsBody?.isDynamic = true
        plane.physicsBody?.affectedByGravity = false
        plane.physicsBody?.categoryBitMask = 1
        plane.physicsBody?.collisionBitMask = 2
        plane.physicsBody?.contactTestBitMask = 2
        addChild(plane)
        
        
        let lineSeparate = SKSpriteNode(imageNamed: "line_discount")
        lineSeparate.size = CGSize(width: size.width, height: 5)
        lineSeparate.position = CGPoint(x: size.width / 2, y: 200)
        addChild(lineSeparate)
        
        planeUpBtn = SKSpriteNode(imageNamed: "plane_btn_up")
        planeUpBtn.position = CGPoint(x: 150, y: 260)
        planeUpBtn.size = CGSize(width: 90, height: 95)
        addChild(planeUpBtn)
        
        planeDownBtn = SKSpriteNode(imageNamed: "plane_btn_down")
        planeDownBtn.position = CGPoint(x: 150, y: 140)
        planeDownBtn.size = CGSize(width: 90, height: 95)
        addChild(planeDownBtn)
        
        planeSpeedUpBtn = SKSpriteNode(imageNamed: "plane_btn_speed_up")
        planeSpeedUpBtn.position = CGPoint(x: size.width - 150, y: 140)
        planeSpeedUpBtn.size = CGSize(width: 90, height: 95)
        addChild(planeSpeedUpBtn)
        
        let waterBombBg = SKSpriteNode(imageNamed: "value_empty")
        waterBombBg.position = CGPoint(x: size.width - 150, y: 260)
        waterBombBg.size = CGSize(width: 90, height: 95)
        addChild(waterBombBg)
        
        waterBombBtn = SKSpriteNode(imageNamed: "water_bomb_empty")
        waterBombBtn.position = CGPoint(x: size.width - 150, y: 260)
        addChild(waterBombBtn)
        
        let fires_count_bg = SKSpriteNode(imageNamed: "fires_count_bg")
        fires_count_bg.position = CGPoint(x: size.width / 2, y: size.height - 40)
        fires_count_bg.size = CGSize(width: 220, height: 80)
        addChild(fires_count_bg)
        
        firesCountRestLabel = SKLabelNode(text: "\(firesCountRest)")
        firesCountRestLabel.position = CGPoint(x: size.width / 2 - 50, y: size.height - 50)
        firesCountRestLabel.fontName = "HoltwoodOneSC-Regular"
        firesCountRestLabel.fontSize = 32
        firesCountRestLabel.fontColor = .white
        addChild(firesCountRestLabel)
        
        exitGameBtn = SKSpriteNode(imageNamed: "exit_game")
        exitGameBtn.position = CGPoint(x: 100, y: size.height - 60)
        exitGameBtn.size = CGSize(width: 70, height: 75)
        addChild(exitGameBtn)
        
        firesCountRest = 1 + (level * 2)
        
        spawnObstaclesTimer = .scheduledTimer(withTimeInterval: 5.0 - (Double(level) * 0.4), repeats: true, block: { _ in
            if !self.isPaused {
                self.spawnObstacles()
            }
        })
        
        spawnFiresTimer = .scheduledTimer(withTimeInterval: 8.0 + (Double(level) * 0.4), repeats: true, block: { _ in
            if !self.isPaused {
                self.spawnFireCoster()
            }
        })
    }
    
    private func spawnObstacles() {
        let obstacleName = ["direjable", "shar"].randomElement() ?? "shar"
        let obstacleNode = SKSpriteNode(imageNamed: obstacleName)
        let spawnedY = CGFloat.random(in: (size.height / 2 - 170)...(size.height / 2 + 300))
        obstacleNode.position = CGPoint(x: size.width + 100, y: spawnedY)
        obstacleNode.physicsBody = SKPhysicsBody(rectangleOf: obstacleNode.size)
        obstacleNode.physicsBody?.isDynamic = false
        obstacleNode.physicsBody?.affectedByGravity = false
        obstacleNode.physicsBody?.categoryBitMask = 2
        obstacleNode.physicsBody?.collisionBitMask = 1
        obstacleNode.physicsBody?.contactTestBitMask = 1
        addChild(obstacleNode)
        
        obstacleNode.run(SKAction.sequence([
            SKAction.moveTo(x: -100, duration: 7.0 - (Double(level) * 0.5)),
            SKAction.removeFromParent()
        ]))
    }
    
    private func spawnFireCoster() {
        let fire = SKSpriteNode(imageNamed: "fire")
        let spawnedY = CGFloat.random(in: (100)...(200))
        fire.position = CGPoint(x: size.width + 100, y: spawnedY)
        fire.physicsBody = SKPhysicsBody(rectangleOf: fire.size)
        fire.physicsBody?.isDynamic = false
        fire.physicsBody?.affectedByGravity = false
        fire.physicsBody?.categoryBitMask = 4
        fire.physicsBody?.collisionBitMask = 3
        fire.physicsBody?.contactTestBitMask = 3
        addChild(fire)
        
        fire.run(SKAction.sequence([
            SKAction.moveTo(x: -100, duration: 5.0 - (Double(level) * 0.5)),
            SKAction.removeFromParent()
        ]))
    }
    
    private var speedUpPlane = false {
        didSet {
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touched = touches.first {
            let location = touched.location(in: self)
            let object = atPoint(location)
            
            if object == exitGameBtn {
                NotificationCenter.default.post(name: Notification.Name("exit_game"), object: nil)
            }
            
            if object == planeUpBtn {
                plane.run(SKAction.group([
                    SKAction.moveTo(y: plane.position.y + 30, duration: 0.3),
                    SKAction.rotate(toAngle: .pi / 8, duration: 0.3)
                ]))
            }
            
            if object == planeDownBtn {
                plane.run(SKAction.group([
                    SKAction.moveTo(y: plane.position.y - 30, duration: 0.3),
                    SKAction.rotate(toAngle: -(.pi / 8), duration: 0.3)
                ]))
            }
            
            if object == planeSpeedUpBtn {
                speedUpPlane = true
            }
            
            if object == waterBombBtn {
                if waterBombVolume == 100.0 {
                    waterBombVolume = 0.0
                    dropWaterBomb()
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touched = touches.first {
            let location = touched.location(in: self)
            let object = atPoint(location)
            
            if object == planeSpeedUpBtn {
                speedUpPlane = false
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if speedUpPlane {
            if plane.position.y < 200 {
                if waterBombVolume < 100 {
                    waterBombVolume += 1
                }
            }
        }
    }
    
    private func dropWaterBomb() {
        let waterBomb = SKSpriteNode(imageNamed: "water_bomb_full")
        waterBomb.position = plane.position
        waterBomb.position.y -= 100
        waterBomb.physicsBody = SKPhysicsBody(rectangleOf: waterBomb.size)
        waterBomb.physicsBody?.isDynamic = true
        waterBomb.physicsBody?.affectedByGravity = true
        waterBomb.physicsBody?.categoryBitMask = 3
        waterBomb.physicsBody?.collisionBitMask = 4
        waterBomb.physicsBody?.contactTestBitMask = 4
        addChild(waterBomb)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2 ||
            bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 1 {
            var obstacleBody: SKPhysicsBody = bodyB
            if bodyA.categoryBitMask == 2 {
                obstacleBody = bodyA
            }
            if let _ = obstacleBody.node {
                plane.removeFromParent()
                gameOver()
            }
        }
        
        if bodyA.categoryBitMask == 3 && bodyB.categoryBitMask == 4 ||
            bodyA.categoryBitMask == 4 && bodyB.categoryBitMask == 3 {
            // 3 - water bomb, 4 - fire
            let waterBombBody: SKPhysicsBody
            let fireBody: SKPhysicsBody
            
            if bodyA.categoryBitMask == 3 {
                waterBombBody = bodyA
                fireBody = bodyB
            } else {
                waterBombBody = bodyB
                fireBody = bodyA
            }
            
            if let waterBombNode = waterBombBody.node,
               let fireNode = fireBody.node {
                waterBombNode.removeFromParent()
                fireNode.removeFromParent()
                firesCountRest -= 1
            }
        }
    }
    
    private func gameOver() {
        NotificationCenter.default.post(name: Notification.Name("game_over_plane_die"), object: nil)
        isPaused = true
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: GameFiresScene(level: 1))
            .ignoresSafeArea()
    }
}
