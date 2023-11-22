//
//  SocketManager.swift
//  ChatGPTStreaming
//
//  Created by Berserk on 22/11/2023.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noDataReceived
    case decodingError
    case responseError
    case serializingBodyError
    case serializingResponseError
}

class SocketManager: NSObject, URLSessionDataDelegate {
    
    private var storedCompletion: ((Result<String, Error>) -> Void)?
    
    override init() {
        super.init()
    }
    
    func sendChatGPTRequest(input: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let configPlist = getConfigPlist() else { return }
        
        let requestData: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "You are a helpful assistant and you answer in french."],
                ["role": "user", "content": input]
            ],
            "stream": true
        ]
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(configPlist.OPENAI_API_KEY)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
        } catch {
            DispatchQueue.main.async {
                completion(.failure(APIError.serializingBodyError))
            }
            return
        }
        
        self.storedCompletion = completion
        
        let session: URLSession = {
                return URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        }()
        
        session.dataTask(with: request)
    }
    
    private func getConfigPlist() -> ConfigPlist? {
        
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
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        print("didReceive data")
    }
    
}

struct ConfigPlist: Decodable {
    let OPENAI_API_KEY: String
}
