//
//  UserChatWireframe.swift
//  Github-SwiftUI-VIPER
//
//  Created Nishant on 30/09/19.
//  Copyright © 2019 Nishant. All rights reserved.
//
//

import Foundation

protocol UserChatWireframeProtocol {
    static func makePresenter(delegate: UserChatDelegate?) -> UserChatPresenter
}

struct UserChatWireframe: UserChatWireframeProtocol {
    static func makePresenter(delegate: UserChatDelegate?) -> UserChatPresenter {
        let interactorDependencies = UserChatInteractorDependencies()
        let interactor = UserChatInteractor(dependencies: interactorDependencies)

        let presenterDependencies = UserChatPresenterDependencies()
        let presenter = UserChatPresenter(dependencies: presenterDependencies,
                                         					   interactor: interactor,
                                         					   delegate: delegate)
        return presenter
    }
}
