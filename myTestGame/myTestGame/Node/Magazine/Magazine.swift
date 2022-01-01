//
//  Magazine.swift
//  myTestGame
//
//  Created by 邓若涛 on 2021/12/23.
//

import Foundation
import SpriteKit

//管理换弹
class Magazine {
    var bullets:[Bullet]!
    var capacity: Int!
    init(bullets:[Bullet]){
        self.bullets = bullets
        self.capacity = bullets.count
    }
    
    //开枪
    func shoot(){
        bullets.first{$0.wasShoot() == false}?.shoot()
    }
    
    //检查是否换弹
    func needToReload() -> Bool{
        return bullets.allSatisfy({ $0.wasShoot() == true})
    }
    
    //换弹
    func reloadIfNeeded(){
        if needToReload(){
            for bullet in bullets{
                bullet.reloadIfNeeded()
            }
        }
    }
    
}
