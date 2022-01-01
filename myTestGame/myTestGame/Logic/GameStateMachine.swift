//
//  GameStateMachine.swift
//  myTestGame
//
//  Created by 邓若涛 on 2021/12/23.
//

import Foundation
import GameplayKit

//basic state
class GameState: GKState{
    unowned var fire:FireButton
    unowned var magazine:Magazine
    
    init(fire: FireButton,magazine: Magazine){
        self.fire = fire
        self.magazine = magazine
        
        super.init()
    }
}

//一开始的状态
class ReadyState: GameState{
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        //只能进入Shooting State
        if stateClass is ShootingState.Type && !magazine.needToReload()
        {
            return true
        }
        return false
    }
    
    //一进入ReadyState就要做的事情
    override func didEnter(from previousState: GKState?) {
        magazine.reloadIfNeeded()
        stateMachine?.enter(ShootingState.self)
    }
}
//开火状态
class ShootingState: GameState{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is ReloadingState.Type && magazine.needToReload()
        {
            return true
        }
        return false
    }
    
    override func didEnter(from previousState: GKState?) {
        fire.removeAction(forKey: ActionKey.reloading.key)
        fire.run(.animate(with: [SKTexture.init(imageNamed: Texture.fireButtonNormal.imageName)], timePerFrame: 0.1), withKey: ActionKey.reloading.key)
    }
}

//装填状态
class ReloadingState: GameState{
    let reloadingTime: Double = 0.25
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass is ShootingState.Type && !magazine.needToReload()
        {
            return true
        }
        return false
    }
    let ReloadingTexture = SKTexture(imageNamed: Texture.bulletReloadingTexture.imageName)
    lazy var fireButtonRelodingAction = {
        SKAction.sequence([
            SKAction.animate(with:[ReloadingTexture],timePerFrame: 0.1),
            SKAction.rotate(byAngle: 360, duration: 30)
        ])
    }()
    
    let bulletTexture = SKTexture(imageNamed: Texture.bulletTexture.imageName)
    lazy var bulletReloadingAction = {
        SKAction.animate(with: [bulletTexture], timePerFrame: 0.1)
    }()
    
    override func didEnter(from previousState: GKState?) {
        fire.isReloading = true
        fire.removeAction(forKey:ActionKey.reloading.key)
        fire.run(fireButtonRelodingAction,withKey: ActionKey.reloading.key)
        
        for(i,bullet)in magazine.bullets.reversed().enumerated(){
            var action = [SKAction]()
            let waitAction = SKAction.wait(forDuration: TimeInterval(reloadingTime * Double(i)))
            action.append(waitAction)
            action.append(bulletReloadingAction)
            action.append(SKAction.run {
                Audio.sharedInstance.playSound(soundFileName: Sound.reload.fileName)
                Audio.sharedInstance.player(with: Sound.reload.fileName)?.volume = 0.3
            })
            action.append(SKAction.run {
                bullet.reloaded()
            })
            if i == magazine.capacity-1{
                action.append(SKAction.run {[unowned self] in
                    self.fire.isReloading = false
                    self.stateMachine?.enter(ShootingState.self)
                })
            }
            
            bullet.run(.sequence(action))
        }
    }
}

