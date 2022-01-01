//
//  ScoreNumber.swift
//  myTestGame
//
//  Created by 邓若涛 on 2021/12/23.
//

import Foundation

enum ScoreNumber {
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case plus
    case multiplication
    
    var textureName: String {
        switch self {
        case .zero:
            return "number/0"
        case .one:
            return "number/1"
        case .two:
            return "number/2"
        case .three:
            return "number/3"
        case .four:
            return "number/4"
        case .five:
            return "number/5"
        case .six:
            return "number/6"
        case .seven:
            return "number/7"
        case .eight:
            return "number/8"
        case .nine:
            return "number/9"
        case .plus:
            return "number/+"
        case .multiplication:
            return "number/*"
        }
    }
    
}
