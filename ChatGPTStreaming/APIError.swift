//
//  APIError.swift
//  ChatGPTStreaming
//
//  Created by Berserk on 23/11/2023.
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
