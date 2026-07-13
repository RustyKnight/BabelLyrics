//
//  ArrayQueue.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 13/7/2026.
//

import Foundation

struct Queue {
    enum QueueError: Error{
        case capacityExceeded
    }
    
    private var array: [String] = []
    
    init(_ array: [String]) {
        self.array = Array(array)
    }
    
    mutating func pop() -> String? {
        isEmpty ? nil : array.removeFirst()
    }
    
    mutating func clear() {
        array.removeAll()
    }
    
    var isEmpty: Bool {
        array.isEmpty
    }
    
    var count: Int {
        array.count
    }
    
    var peek: String? {
        array.first
    }
}
