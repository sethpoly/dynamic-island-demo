//
//  MediaAction.swift
//  DynamicIslandDemo
//
//  Created by Seth Polyniak on 12/5/22.
//

import Foundation

enum MediaAction {
    case rewind
    case play
    case pause
    case fastForward
    
    var image: String {
        switch self {
        case .rewind: return "backward.fill"
        case .play: return "play.fill"
        case .pause: return "pause.fill"
        case .fastForward: return "forward.fill"
        }
    }
}
