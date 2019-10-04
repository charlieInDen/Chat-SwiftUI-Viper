//
//  BaseAPIService.swift
//  Github-SwiftUI-VIPER
//
//  Created by Nishant on 04/10/19.
//  Copyright © 2019 Nishant. All rights reserved.
//

import Foundation
import Combine

protocol APIRequestType {
    associatedtype Response: Decodable
    
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

protocol APIServiceType {
    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request: APIRequestType
}
class BaseAPIService: APIServiceType {
    
    private let baseURL: URL
    private let urlSession: URLSession
    init(baseURL: URL = URL(string: "https://api.github.com")!, session: URLSession = URLSession.shared) {
        self.baseURL = baseURL
        self.urlSession = session
    }

    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request: APIRequestType {
    
        let pathURL = URL(string: request.path, relativeTo: baseURL)!
        
        var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = request.queryItems
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let decorder = JSONDecoder()
        return urlSession.dataTaskPublisher(for: request)
            .map { $0.data }
            .mapError { _ in APIServiceError.responseError }
            .decode(type: Request.Response.self, decoder: decorder)
            .mapError(APIServiceError.parseError)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

