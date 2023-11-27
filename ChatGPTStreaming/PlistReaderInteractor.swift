//
//  PlistReaderInteractor.swift
//  ChatGPTStreaming
//
//  Created by Berserk on 23/11/2023.
//

import Foundation

protocol PlistReaderInteractorInterface: AnyObject {
    func decodePlist<T: Decodable>(filename: String, type: T.Type) -> T?
}

class PlistReaderInteractor: PlistReaderInteractorInterface {
    
    func decodePlist<T: Decodable>(filename: String, type: T.Type) -> T? {
        
        if let configUrl = Bundle.main.url(forResource: filename, withExtension: "plist"), let data = try? Data(contentsOf: configUrl) {
            
            do {
                let configPlist = try PropertyListDecoder().decode(type, from: data)
                
                return configPlist
                
            } catch let err {
                print("There was an error getting the plist from bundle: ",err.localizedDescription)
            }
        }
        
        return nil
    }
}
