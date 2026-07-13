//
//  ArrayQueue.swift
//  BabelLyrics
//
//  Created by Shane Whitehead on 13/7/2026.
//

import Foundation

/// A simple FIFO queue backed by an array of strings.
struct Queue {
    /// Errors that can be raised by queue operations.
    enum QueueError: Error{
        case capacityExceeded
    }
    
    private var array: [String] = []
    
    /// Creates a queue from the supplied items.
    init(_ array: [String]) {
        self.array = Array(array)
    }
    
    /// Removes and returns the next item, if any.
    mutating func pop() -> String? {
        isEmpty ? nil : array.removeFirst()
    }
    
    /// Removes all items from the queue.
    mutating func clear() {
        array.removeAll()
    }
    
    /// Returns whether the queue is empty.
    var isEmpty: Bool {
        array.isEmpty
    }
    
    /// Returns the number of queued items.
    var count: Int {
        array.count
    }
    
    /// Returns the next item without removing it.
    var peek: String? {
        array.first
    }
}
