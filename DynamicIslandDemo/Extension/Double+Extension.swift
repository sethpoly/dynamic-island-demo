//
//  Double+Extension.swift
//  DynamicIslandDemo
//
//  Created by Seth Polyniak on 12/5/22.
//

import Foundation

extension Double {
    var minutes: String {
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
