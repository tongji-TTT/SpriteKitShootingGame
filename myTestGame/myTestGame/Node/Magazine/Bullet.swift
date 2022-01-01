//
//  Bullet.swift
//  myTestGame
//
//  Created by 邓若涛 on 2021/12/23.
//

import Foundation
import SpriteKit

class Bullet: SKSpriteNode{
    
    private var isEmpty = true
    
    init()
    {
        let texture = SKTexture(imageNamed: Texture.bulletEmptyTexture.imageName)
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //控制子弹是否为空
    func reloaded(){
        isEmpty = false
    }
    
    func shoot(){
        isEmpty = true
        texture = SKTexture(imageNamed: Texture.bulletEmptyTexture.imageName)
    }
    
    func wasShoot() -> Bool{
        return isEmpty
    }
    
    func reloadIfNeeded(){
        if isEmpty{
            texture = SKTexture(imageNamed: Texture.bulletTexture.imageName)
            isEmpty = false
        }
    }
}
