//
//  DispatchQueue.swift
//  ChatGPTStreaming
//
//  Created by Berserk on 23/11/2023.
//

import Foundation

extension DispatchQueue {
    
    static func executeOnMainThread(_ work: @escaping @convention(block) () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async {
                work()
            }
        }
    }
}
