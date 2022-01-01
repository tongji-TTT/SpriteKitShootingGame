//
//  Life.swift
//  myTestGame
//
//  Created by 邓若涛 on 2021/12/24.
//

import Foundation
import SpriteKit

class Life: SKSpriteNode{
    
    private var isHurt = false
    
    init()
    {
        let texture = SKTexture(imageNamed: Texture.life.imageName)
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getHurt()
    {
        isHurt = true
        texture = SKTexture(imageNamed: Texture.lostLife.imageName)
    }
    
    func Hurt() -> Bool{
        return isHurt
    }
    
    func getCured()
    {
        isHurt = false
        texture = SKTexture(imageNamed: Texture.life.imageName)
    }
}
