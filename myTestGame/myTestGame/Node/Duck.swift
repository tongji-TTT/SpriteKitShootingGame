//
//  Duck.swift
//  myTestGame
//
//  Created by 邓若涛 on 2021/12/22.
//

import Foundation
import SpriteKit

class Duck: SKNode
{
    var hasTarget: Bool!
    
    init(hasTarget: Bool = false)
    {
        super.init()
        self.hasTarget = hasTarget
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
