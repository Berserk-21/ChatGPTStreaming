//
//  SocketDecoder.swift
//  ChatGPTStreaming
//
//  Created by Berserk on 22/11/2023.
//

import Foundation

final class SocketDecoder {
    
    func decodeResult(result: (Result<Data, Error>), completion: @escaping (String) -> Void) {
        
        switch result {
        case .success(let data):
            if let receivedString = String(data: data, encoding: .utf8) {
                
                let components = receivedString.components(separatedBy: "data: ")
                
                let cleanedComponents = components.map { component in
                    
                    var cleanedComponent = component
                    
                    if let endIndex = cleanedComponent.lastIndex(of: "}") {
                        
                        let rangeToDelete = cleanedComponent.index(after: endIndex)..<cleanedComponent.endIndex
                        
                        cleanedComponent.removeSubrange(rangeToDelete)
                    }
                    
                    if let indexOfOpenBrace = cleanedComponent.firstIndex(of: "{") {
                        
                        let rangeToDelete = cleanedComponent.startIndex..<indexOfOpenBrace
                        
                        cleanedComponent.removeSubrange(rangeToDelete)
                    }
                    
                    return cleanedComponent
                }
                
                cleanedComponents.forEach { component in
                                        
                    if !component.isEmpty, let componentData = component.data(using: .utf8) {
                        
                        do {
                            let response = try JSONDecoder().decode(OpenAIStreamingJSON.self, from: componentData)
    
                            if let answer = response.choices?[0].delta?.content {
                                
                                completion(answer)
                            }
                        } catch let error {
    
                            if component.contains("[DONE]") {
                                print("Streaming is over")
                            } else {
                                print("There was an error with this answer: \(component)")
                                print(String(describing: error))
                            }
                        }
                    }
                }
        }
        case .failure(let error):
            print(error.localizedDescription)
        }
        
    }
}
