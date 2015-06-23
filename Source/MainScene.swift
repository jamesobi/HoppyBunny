import Foundation

class MainScene: CCNode, CCPhysicsCollisionDelegate {
    weak var hero: CCSprite!
    weak var ground1: CCSprite!
    weak var ground2: CCSprite!
    var grounds = [CCSprite]()
    weak var bam : CCPhysicsNode!
    weak var carrots: CCNode!
    weak var obstacleLayer : CCNode!
    weak var topCarrot : CCNode!
    weak var bottomCarrot : CCNode!
    weak var restartButton : CCButton!
    var sinceTouch : CCTime = 0
    var scrollSpeed:CGFloat = 80
    
    var gameOver = false
    var obstacles: [CCNode] = []
    var points: NSInteger = 0
    weak var scoreLabel: CCLabelTTF!
    weak var goal: CCNode!
    
    let firstObstaclePosition:CGFloat = 280
    let distanceBetweenObstacles:CGFloat = 160
    let differenceBetweenCarrotAndGoal:CGFloat = 122

    
    
    
    /*override func onEnter() {
        super.onEnter()
        gamePhyscicsNode!.debug = true
    } */
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        bam.collisionDelegate = self

        grounds.append(ground1)
        grounds.append(ground2)

        spawnNewObstacle()
        spawnNewObstacle()
        spawnNewObstacle()
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, level: CCNode!) -> ObjCBool {
        //println("TODO: handle Game Over")
        triggerGameOver()
        
        //restartButton.position.x = hero.position.x
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero nodeA: CCNode!, goal: CCNode!) -> ObjCBool {
        goal.removeFromParent()
        points++
        scoreLabel.string = String(points)
        println("\(points)")
        return true
        
    }
    
    func restart(){
        let scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(scene)
    }
    
    func triggerGameOver(){
        println("Game Over")
        gameOver = true
        restartButton.visible = true
        scrollSpeed = 0
        hero.rotation = 90
        hero.physicsBody.allowsRotation = false
        
        hero.stopAllActions()
        
        let move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.2, position: ccp(0,4)))
        let moveBack = CCActionEaseBounceOut(action: move.reverse())
        
        let shakeSequence = CCActionSequence(array: [move, moveBack])
        
        runAction(shakeSequence)
        
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if(gameOver == false){
            hero.physicsBody.applyImpulse(ccp(0, 400))
            hero.physicsBody.applyAngularImpulse(10000)
            sinceTouch = 0
        }
    }
    
    
    override func update(delta: CCTime) {
        let velocityY = clampf(Float(hero.physicsBody.velocity.y), -Float(CGFloat.max), 200)
        hero.physicsBody.velocity = ccp(0, CGFloat(velocityY))
        sinceTouch += delta
        hero.rotation = clampf(hero.rotation, -30, 90)
        
        if (hero.physicsBody.allowsRotation) {
            let angularVelocity = clampf(Float(hero.physicsBody.angularVelocity), -2, 1)
            hero.physicsBody.angularVelocity = CGFloat(angularVelocity)
        }
        if (sinceTouch > 0.3) {
            let impulse = -18000.0 * delta
            hero.physicsBody.applyAngularImpulse(CGFloat(impulse))
        }
        
        hero.position = ccp(hero.position.x + scrollSpeed * CGFloat(delta), hero.position.y)
        //hero.position = ccp(0, 0)
        bam.position = ccp(bam.position.x - scrollSpeed * CGFloat(delta), bam.position.y)
        //bam.position = ccp(0, 0)
        
        
        let scale = CCDirector.sharedDirector().contentScaleFactor
        bam.position = ccp(round((bam.position.x * scale) / scale), round((bam.position.y * scale) / scale))
        hero.position = ccp(round((hero.position.x * scale) / scale), round((hero.position.y * scale) / scale))
        
        
        bam.position = ccp(round(bam.position.x), round(bam.position.y))
        
        
        
        // loop the ground whenever a ground image was moved entirely outside the screen
        for ground in grounds {
            let groundWorldPosition = bam.convertToWorldSpace(ground.position)
            let groundScreenPosition = convertToNodeSpace(groundWorldPosition)
            if groundScreenPosition.x <= (-ground.contentSize.width) {
                ground.position = ccp(ground.position.x + ground.contentSize.width * 2, ground.position.y)
            }
        }
        
        for obstacle in obstacles.reverse(){
            let obstacleWorldPosition = bam.convertToWorldSpace(obstacle.position)
            let obstacleScreenPosition = convertToNodeSpace(obstacleWorldPosition)
            
            if(obstacleScreenPosition.x < (-obstacle.contentSize.width)){
                obstacle.removeFromParent()
                println("Carrot at \(obstacle.position.x) removed")
                obstacles.removeAtIndex(find(obstacles, obstacle)!)
                
                spawnNewObstacle()
            }
        }
        
    }
    
    
    func spawnNewObstacle() {
        var prevObstaclePos = firstObstaclePosition
        if obstacles.count > 0 {
            prevObstaclePos = obstacles.last!.position.x
        }
        
        // create and add a new obstacle
        let obstacle = CCBReader.load("Obstacle") as! Obstacle
        obstacle.position = ccp(prevObstaclePos + distanceBetweenObstacles, 0)
        obstacle.setupRandomPosition()
        //goal.position.y = topCarrot.position.y + differenceBetweenCarrotAndGoal
        carrots.addChild(obstacle)
        println("Obstacle added at position \(prevObstaclePos + distanceBetweenObstacles)")
        obstacles.append(obstacle)
    }
    
}