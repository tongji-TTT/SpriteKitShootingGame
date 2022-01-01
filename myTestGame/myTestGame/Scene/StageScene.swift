//
//  StageScene.swift
//  myTestGame
//
//  Created by 邓若涛 on 2021/12/22.
//

// TODO
// 1.添加退出，暂停，重新开始
// 2.增加血量与新动物
// 3.更换背景
import Foundation
import SpriteKit
import GameplayKit
class StageScene: SKScene
{
    //Nodes
    var rifle: SKSpriteNode?
    var crosshair: SKSpriteNode?
    var fire = FireButton()
    var duckScoreNode: SKNode!
    var targetScoreNode: SKNode!
    
    //
    var stopBool = false
    var stopTable :SKSpriteNode!
    //
    
    //bullet
    var magazine : Magazine!
    //life
    var lifeManager : LifeManager!
    //Touches
    var selectedNodes:[UITouch: SKSpriteNode] = [:]
    var touchDifferent: (CGFloat,CGFloat)?
    
    //game logic
    var manager: GameManager!
    
    //游戏状态机
    var gameStateMachine: GKStateMachine!
    //StageScene 被调用的时候就会执行
    override func didMove(to view: SKView) {

        manager = GameManager(scene: self)
        loadUI()
        //设置背景音乐
        Audio.sharedInstance.playSound(soundFileName: Sound.musicLoop.fileName)
        Audio.sharedInstance.player(with: Sound.musicLoop.fileName)?.volume = 0.3
        Audio.sharedInstance.player(with: Sound.musicLoop.fileName)?.numberOfLoops = -1
        //设置游戏状态机
        gameStateMachine = GKStateMachine(states: [
        ReadyState(fire: fire, magazine: magazine),
        ShootingState(fire: fire, magazine: magazine),
        ReloadingState(fire: fire, magazine: magazine)])
        gameStateMachine.enter(ReadyState.self)
    
        manager.activeShark()
        manager.activeDuckS()
        manager.activeTargets()
        
    }
}

// gameloop
extension StageScene
{
    override func update(_ currentTime: TimeInterval) {
        syncRiflePosition()
        setBountry()
    }
}


// Touch
extension StageScene
{
    //begin
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let crosshair = crosshair else {return}
        
        for touch in touches{
            let location = touch.location(in: self)
            if let node = self.atPoint(location) as? SKSpriteNode{
                if !selectedNodes.values.contains(crosshair) && !(node is FireButton){
                    selectedNodes[touch] = crosshair
                    let xDifference = touch.location(in: self).x - crosshair.position.x
                    let yDifference = touch.location(in: self).y - crosshair.position.y
                    touchDifferent = (xDifference,yDifference)
                }
                if node.name == "stop" || stopBool
                {
                   // loadStopUI()
                    if stopBool {
                        if node.name == "back"
                        {
                        self.view?.isPaused = false
                        stopTable.run(.removeFromParent())
                        stopBool = !stopBool
                        }
                        if node.name == "restart"{
                            
                            duckScoreNode.removeFromParent()
                            duckScoreNode = manager.generateTextNode(from: "0")
                            duckScoreNode.position = CGPoint(x: 70, y: 365)
                            duckScoreNode.zPosition = 11
                            duckScoreNode.xScale = 0.5
                            duckScoreNode.yScale = 0.5
                            addChild(duckScoreNode)
                            
                            targetScoreNode.removeFromParent()
                            targetScoreNode = manager.generateTextNode(from: "0")
                            targetScoreNode.position = CGPoint(x: 70, y: 325)
                            targetScoreNode.zPosition = 11
                            targetScoreNode.xScale = 0.5
                            targetScoreNode.yScale = 0.5
                            addChild(targetScoreNode)
                            
                            manager.duckCount = 0
                            manager.targetCount = 0
                            lifeManager.reStart()
                            
                            self.view?.isPaused = false
                            stopTable.run(.removeFromParent())
                            stopBool = !stopBool
                        }
                        if node.name == "exit"
                        {
                            self.view?.removeFromSuperview()
                        }
                    }
                    else{
                    stopTable = getStopUI()
                    self.addChild(stopTable)
                    stopTable.run(.run {
                            self.view?.isPaused = true
                        })
                    stopBool = !stopBool
                    }
                }
                else{
                //actual shooting
                if node  is FireButton
                    {
                    selectedNodes[touch] = fire
                    
                    //check if is reloading
                    if !fire.isReloading{
                        
                        fire.isPressed = true
                        magazine.shoot()
                        //开枪声
                        Audio.sharedInstance.playSound(soundFileName: Sound.hit.fileName)
                        
                        if magazine.needToReload(){
                            gameStateMachine.enter(ReloadingState.self)
                        }
                        //find shot node
                        let shootNode = manager.findShootNode(at: crosshair.position)
                        guard let (socreText, shotImageName) = manager.findTextAndImageName(for: shootNode.name) else {return}
                        //add shot image
                        manager.addshot(imageNamed: shotImageName, to: shootNode, on: crosshair.position)
                        //add score text
                        manager.addTextNode(on: crosshair.position, from: socreText)
                        //得分声
                        Audio.sharedInstance.playSound(soundFileName: Sound.score.fileName)
                        //update socre node
                        manager.update(text: String(manager.duckCount*manager.duckScore), node: &duckScoreNode)
                        manager.update(text: String(manager.targetCount*manager.targetScore), node: &targetScoreNode)
                        //animate shoot down
                        shootNode.physicsBody = nil
                        if shootNode.name == "shark"
                        {
                            shootNode.removeFromParent()
                        }
                        else
                        {
                        if let node = shootNode.parent
                        {
                            node.run(.sequence([
                                .wait(forDuration: 0.2),
                                .scaleY(to: 0.0, duration: 0.2)]))
                        }
                        }
                    }
                }
                }
            }
         
        }
    }
    //move
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let crosshair = crosshair else {return}
        guard let touchDifferent = touchDifferent else{return}
        
        for touch in touches {
            //判断是开火还是移动
            let location = touch.location(in: self)
            if let node = selectedNodes[touch]{
                if node.name == "fire"{
                    
                }else{
                    let newCrosshairPosition = CGPoint(x: location.x - touchDifferent.0, y: location.y-touchDifferent.1)
                    crosshair.position = newCrosshairPosition
                }
            }
        }
        
    }
    //end
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches {
            if selectedNodes[touch] != nil {
                if let fire = selectedNodes[touch] as? FireButton{
                    fire.isPressed = false
                }
                selectedNodes[touch] = nil
            }
    }
    }
}
// Action
extension StageScene
{
    
    func loadUI(){
        //Rifle
        if let scene = scene{
        rifle = childNode(withName: "rifle") as? SKSpriteNode
        crosshair = childNode(withName: "crosshair") as? SKSpriteNode
        crosshair?.position = CGPoint(x:scene.frame.midX,y:scene.frame.midY)
        }
        //fireButton
        fire.position = CGPoint(x: 720, y: 80)
        fire.xScale = 1.7
        fire.yScale = 1.7
        fire.zPosition = 11
        
        addChild(fire)
        
        //add icons
        let duckIcon = SKSpriteNode(imageNamed: Texture.duckIcon.imageName)
        duckIcon.position = CGPoint(x: 36, y: 365)
        duckIcon.zPosition = 11
        addChild(duckIcon)
        
        let targetIcon = SKSpriteNode(imageNamed: Texture.targetIcon.imageName)
        targetIcon.position = CGPoint(x: 36, y: 325)
        targetIcon.zPosition = 11
        addChild(targetIcon)
        //add socre
        duckScoreNode = manager.generateTextNode(from: "0")
        duckScoreNode.position = CGPoint(x: 70, y: 365)
        duckScoreNode.zPosition = 11
        duckScoreNode.xScale = 0.5
        duckScoreNode.yScale = 0.5
        addChild(duckScoreNode)
        
        targetScoreNode = manager.generateTextNode(from: "0")
        targetScoreNode.position = CGPoint(x: 70, y: 325)
        targetScoreNode.zPosition = 11
        targetScoreNode.xScale = 0.5
        targetScoreNode.yScale = 0.5
        addChild(targetScoreNode)
        
        
        //add empty magazine
        let magazineNode = SKNode()
        magazineNode.position = CGPoint(x: 760, y: 20)
        magazineNode.zPosition = 11
        
        var bullets = Array<Bullet>()
        
        for i in 0...manager.ammunitionQuantity-1{
            let bullet = Bullet()
            bullet.position = CGPoint(x: -30*i, y: 0)
            bullets.append(bullet)
            magazineNode.addChild(bullet)
        }
        
        magazine = Magazine(bullets: bullets)
        addChild(magazineNode)
        
        //add stop button
        let stopNode = SKSpriteNode(imageNamed: Texture.stopButton.imageName)
        stopNode.position = CGPoint(x: 770, y: 360)
        stopNode.zPosition = 13
        stopNode.xScale = 0.08
        stopNode.yScale = 0.08
        stopNode.name = "stop"
        addChild(stopNode)
        
        //add Life Manager
        let lifeManagerNode = SKNode()
        lifeManagerNode.position = CGPoint(x: 85, y: 280)
        lifeManagerNode.zPosition = 11
        
        var lives = Array<Life>()
        
        for i in 0...manager.lifeQuantity-1{
            let life = Life()
            life.position = CGPoint(x: -240+240*i, y: 0)
            lives.append(life)
            lifeManagerNode.addChild(life)
        }
        
        lifeManager = LifeManager(lives: lives)
        lifeManagerNode.xScale = 0.2
        lifeManagerNode.yScale = 0.2
        addChild(lifeManagerNode)
    }
    
    func getStopUI() ->SKSpriteNode
    {
       //let scene = scene
        let stopTable = SKSpriteNode(imageNamed: "bg_wood")
        stopTable.position = CGPoint(x:self.frame.midX,y:self.frame.midY)
        stopTable.zPosition = 13
        stopTable.xScale = 1.864
        stopTable.yScale = 0.6
        stopTable.name = "stopTable"
        let backNode = SKSpriteNode(imageNamed: Texture.backButton.imageName)
        backNode.position = CGPoint(x: -86.793, y: -0.001)
        backNode.zPosition = 1
        backNode.xScale = 0.161
        backNode.yScale = 0.5
        backNode.name = "back"
        let restartNode = SKSpriteNode(imageNamed: Texture.restartButton.imageName)
        restartNode.position = CGPoint(x: -3.198, y: -5.333)
        restartNode.zPosition = 1
        restartNode.xScale = 0.123
        restartNode.yScale = 0.383
        restartNode.name = "restart"
        let exitNode = SKSpriteNode(imageNamed: Texture.exitButton.imageName)
        exitNode.position = CGPoint(x: 82.897, y: -3.667)
        exitNode.zPosition = 1
        exitNode.xScale = 0.107
        exitNode.yScale = 0.333
        exitNode.name = "exit"
        stopTable.addChild(backNode)
        stopTable.addChild(restartNode)
        stopTable.addChild(exitNode)
        return stopTable
    }

    
    //让枪移动
    func syncRiflePosition(){
        guard let rifle = rifle else {return}
        guard let crosshair = crosshair else {return}
        
        rifle.position.x = crosshair.position.x + 100
    }
    //保证准星不出边界
    func setBountry()
    {
        guard let scene = scene else {return}
        guard let crosshair = crosshair else {return}
        
        if crosshair.position.x < scene.frame.minX{
            crosshair.position.x = scene.frame.minX
        }
        if crosshair.position.x > scene.frame.maxX{
            crosshair.position.x = scene.frame.maxX
        }
        if crosshair.position.y < scene.frame.minY{
            crosshair.position.y = scene.frame.minY
        }
        if crosshair.position.y > scene.frame.maxY{
            crosshair.position.y = scene.frame.maxY
        }
    }
   
}
