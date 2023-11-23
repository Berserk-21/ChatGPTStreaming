//
//  PlistReaderInteractor.swift
//  ChatGPTStreaming
//
//  Created by Berserk on 23/11/2023.
//

import Foundation

protocol PlistReaderInterface: AnyObject {
    func getConfigPlist() -> ConfigPlist?
}

class PlistReaderInteractor: PlistReaderInterface {
    
    func getConfigPlist() -> ConfigPlist? {
        
        if let configUrl = Bundle.main.url(forResource: "Config", withExtension: "plist"), let data = try? Data(contentsOf: configUrl) {
            
            do {
                let configPlist = try PropertyListDecoder().decode(ConfigPlist.self, from: data)
                
                return configPlist
                
            } catch let err {
                print("There was an error getting the plist from bundle: ",err.localizedDescription)
            }
        }
        
        return nil
    }
}
