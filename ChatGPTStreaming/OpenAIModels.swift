//
//  OpenAIModels.swift
//  OpenAI-Chat
//
//  Created by Berserk on 22/11/2023.
//

import Foundation

struct OpenAIStreamingJSON: Decodable {
    var id: String?
    var object: String
    var created: Int
    var model: String
    var choices: [StreamingChoice]?
}

struct StreamingChoice: Decodable {
    let delta: StreamingDelta?
    let finish_reason: String?
    let index: Int?
}

struct StreamingDelta: Decodable {
    let content: String?
}

struct OpenAIJson: Decodable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let usage: Usage
    let choices: [Choice]
}

struct Usage: Decodable {
    let prompt_tokens: Int
    let completion_tokens: Int
    let total_tokens: Int
}

struct Choice: Decodable {
    let message: Message
    let finish_reason: String
    let index: Int
}

struct Message: Decodable {
    let role: String
    let content: String
}

