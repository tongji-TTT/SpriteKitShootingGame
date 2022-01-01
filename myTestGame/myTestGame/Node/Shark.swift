//
//  Shark.swift
//  myTestGame
//
//  Created by 邓若涛 on 2021/12/24.
//

import Foundation
import SpriteKit

class Shark: SKSpriteNode
{
    let sharkLife = 3
    
    init()
    {
        let texture = SKTexture(imageNamed: Texture.shark.imageName)
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
