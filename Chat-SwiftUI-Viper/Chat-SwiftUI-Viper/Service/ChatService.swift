//
//  ChatService.swift
//  Github-SwiftUI-VIPER
//
//  Created by Nishant on 04/10/19.
//  Copyright © 2019 Nishant. All rights reserved.
//
import Combine
import Foundation

protocol ChatAPIServiceProvider {
    var apiService: ChatService { get }
}
final class ChatService {
    func postChat(message: String) -> AnyPublisher< String, APIServiceError> {
        let dummyResponse = Result<String, APIServiceError>.Publisher(message + " " + message ).eraseToAnyPublisher()
        let apiService = MockAPIService(response: dummyResponse)
        let chatRequest = ChatRequest()
        return apiService.response(from: chatRequest) 
    }
    
}

struct ChatRequest: APIRequestType {
    
    typealias Response = String
    //Add post content
    var path: String { return "/chat" }
    var queryItems: [URLQueryItem]?
    init(fromItem: Int = 0) {
        queryItems = []
        
    }
}
