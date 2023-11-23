//
//  SocketInteractor.swift
//  ChatGPTStreaming
//
//  Created by Berserk on 22/11/2023.
//

import Foundation

protocol SocketPresenterInterface: AnyObject {
    var view: ViewInterface? { get set }
    var socketManager: SocketManager { get set }
    var socketDecoder: SocketDecoder { get set }
    func onTextFieldReturn(with input: String)
}

final class SocketPresenter: SocketPresenterInterface {
    
    var socketManager: SocketManager = SocketManager()
    var socketDecoder: SocketDecoder = SocketDecoder()
    
    weak var view: ViewInterface?
    
    func onTextFieldReturn(with input: String) {
        socketManager.sendChatGPTRequest(input: input, onDataReceived: { result in
            
            self.socketDecoder.decodeResult(result: result) { chunk in
                self.view?.get(chunk: chunk)
            }
            
        }, completion: { result in
            
            self.socketDecoder.decodeResult(result: result) { chunk in
                
                guard !chunk.isEmpty else {
                    print("did end streaming",chunk)
                    return
                }
                
                self.view?.get(chunk: chunk)
            }
        })
    }
}
