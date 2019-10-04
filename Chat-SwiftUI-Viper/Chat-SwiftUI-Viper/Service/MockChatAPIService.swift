//
//  MockAPISearvice.swift
//  Github-SwiftUI-VIPER
//
//  Created by Nishant on 04/10/19.
//  Copyright © 2019 Nishant. All rights reserved.
//

import Foundation
import Combine

final class MockAPIService: APIServiceType {
    let response: AnyPublisher<String, APIServiceError>
    init(response:AnyPublisher<String, APIServiceError> ) {
        self.response = response
    }
    
    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request: APIRequestType {
        return self.response as! AnyPublisher<Request.Response, APIServiceError>
    }
}

