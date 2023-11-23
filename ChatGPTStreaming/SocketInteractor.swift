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
            
            self.socketDecoder.decodeResult(result: result) { content in
                self.view?.display(content: content)
            }
            
        }, completion: { result in
            
            self.socketDecoder.decodeResult(result: result) { content in
                
                guard !content.isEmpty else {
                    print("did end streaming",content)
                    return
                }
                
                self.view?.display(content: content)
            }
        })
    }
}
