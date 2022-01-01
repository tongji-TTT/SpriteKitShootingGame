//
//  Sound.swift
//  myTestGame
//
//  Created by 邓若涛 on 2021/12/23.
//

import Foundation
enum Sound: String {
    case musicLoop = "Cheerful Annoyance.wav"
    case hit = "hit.wav"
    case reload = "reload.wav"
    case score = "score.wav"
    
    var fileName: String {
        return rawValue
    }
}
