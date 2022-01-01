//
//  Texture.swift
//  myTestGame
//
//  Created by 邓若涛 on 2021/12/23.
//

import Foundation

enum Texture: String{
    case fireButtonNormal = "fire_normal"
    case fireButtonPressed = "fire_pressed"
    case bulletEmptyTexture = "icon_bullet_empty"
    case bulletTexture = "icon_bullet"
    case bulletReloadingTexture = "fire_reloading"
    case shotBlue = "shot_blue"
    case shotBrown = "shot_brown"
    case duckIcon = "icon_duck"
    case targetIcon = "icon_target"
    case stopButton = "Stop/stop"
    case backButton = "Stop/back"
    case restartButton = "Stop/restart"
    case exitButton = "Stop/exit"
    case life = "Life/redLife"
    case lostLife = "Life/whiteLife"
    case shark = "shark"
    var imageName :String{
        return rawValue
    }
}
