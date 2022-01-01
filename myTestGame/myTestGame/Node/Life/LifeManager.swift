//
//  LifeManager.swift
//  myTestGame
//
//  Created by 邓若涛 on 2021/12/24.
//

import Foundation
import SpriteKit

class LifeManager{
    
    var lives:[Life]!
    var capacity: Int!
    init(lives:[Life]){
        self.lives = lives
        self.capacity = lives.count
    }
    
    //受伤
    func getHurt(){
        lives.last{$0.Hurt() == false}?.getHurt()
    }
    
    //检查是否结束
    func isEnd() -> Bool{
        return lives.allSatisfy({ $0.Hurt() == true})
    }
    
    //补充满
    func reStart()
    {
        for index in 0...capacity-1 {
            lives[index].getCured()
        }
    }
    
}
