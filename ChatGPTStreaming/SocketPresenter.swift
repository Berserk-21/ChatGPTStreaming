//
//  SocketPresenter.swift
//  ChatGPTStreaming
//
//  Created by Berserk on 22/11/2023.
//

import Foundation

protocol SocketPresenterInterface: AnyObject {
    var view: ViewInterface? { get set }
    var socketManager: SocketManager { get set }
    var socketDecoder: SocketDecoder { get set }
    var plistReader: PlistReaderInteractor { get set }
    func onTextFieldReturn(with input: String)
}

final class SocketPresenter: SocketPresenterInterface {
    
    var plistReader: PlistReaderInteractor = PlistReaderInteractor()
    var socketManager: SocketManager = SocketManager()
    var socketDecoder: SocketDecoder = SocketDecoder()
    
    weak var view: ViewInterface?
    
    func onTextFieldReturn(with input: String) {
        socketManager.sendStreamingUrlRequest(input: input, configPlist: plistReader.getConfigPlist(), onDataReceived: { [weak self] result in
            
            self?.socketDecoder.decodeResult(result: result) { content in
                self?.view?.display(content: content)
            }
            
        }, completion: { [weak self] result in
            
            self?.socketDecoder.decodeResult(result: result) { [weak self] content in
                
                guard !content.isEmpty else {
                    print("did end streaming",content)
                    return
                }
                
                self?.view?.display(content: content)
            }
        })
    }
}
