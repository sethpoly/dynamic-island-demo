//
//  TimeCounter.swift
//  DynamicIslandDemo
//
//  Created by Seth Polyniak on 12/6/22.
//

import Foundation

class TimeCounter: ObservableObject {
    @Published var time = 0
    lazy var timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.time += 1 }
    
    init() { timer.fire() }
}
