//
//  SocketInteractor.swift
//  ChatGPTStreaming
//
//  Created by Berserk on 22/11/2023.
//

import Foundation

protocol SocketPresenterInterface: AnyObject {
    var viewController: ViewInterface? { get set }
}

final class SocketPresenter: SocketPresenterInterface {
    
    weak var viewController: ViewInterface?
        
    private let socketManager = SocketManager()
    private let socketDecoder = SocketDecoder()
    
    func sendRequest(with input: String) {
        socketManager.sendChatGPTRequest(input: input, onDataReceived: { result in
            
            self.socketDecoder.decodeResult(result: result) { chunk in
                self.viewController?.get(chunk: chunk)
            }
            
        }, completion: { result in
            
            self.socketDecoder.decodeResult(result: result) { chunk in
                
                guard !chunk.isEmpty else {
                    print("did end streaming",chunk)
                    return
                }
                
                self.viewController?.get(chunk: chunk)
            }
        })
    }
}
