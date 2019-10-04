//
//  UserChatInteractor.swift
//  Github-SwiftUI-VIPER
//
//  Created Nishant on 30/09/19.
//  Copyright © 2019 Nishant. All rights reserved.
//
//

import Foundation
import Combine
protocol UserChatInteractorProtocol {
	func postChat(message: String) -> AnyPublisher< String, APIServiceError>
}

final class UserChatInteractor {
    private let dependencies: UserChatInteractorDependenciesProtocol
    
    init(dependencies: UserChatInteractorDependenciesProtocol) {
        self.dependencies = dependencies
    }
}

extension UserChatInteractor: UserChatInteractorProtocol {
    func postChat(message: String) -> AnyPublisher< String, APIServiceError> {
        return self.dependencies.apiService.postChat(message: message)
    }
}
