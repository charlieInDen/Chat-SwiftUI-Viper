//
//  UserChatInteractorDependencies.swift
//  Github-SwiftUI-VIPER
//
//  Created Nishant on 30/09/19.
//  Copyright © 2019 Nishant. All rights reserved.
//
//

import Foundation

protocol UserChatInteractorDependenciesProtocol: ChatAPIServiceProvider {
    
}

struct UserChatInteractorDependencies: UserChatInteractorDependenciesProtocol {
    let apiService: ChatService
    
    init() {
        apiService = ChatService()
    }
}
