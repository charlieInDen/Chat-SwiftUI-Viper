//
//  UserChatPresenter.swift
//  Github-SwiftUI-VIPER
//
//  Created Nishant on 30/09/19.
//  Copyright © 2019 Nishant. All rights reserved.
//
//

import Combine
import SwiftUI

protocol UserChatPresenterProtocol: class {
    var viewModel: UserChatViewModel { get }
    func didReceiveEvent(_ event: UserChatEvent)
    func didTriggerAction(_ action: UserChatAction)
}

final class UserChatPresenter: ObservableObject {
    private let dependencies: UserChatPresenterDependenciesProtocol
    private let interactor: UserChatInteractorProtocol
    private var delegate: UserChatDelegate?
    private var postUserMessageCancellable: AnyCancellable?

    private(set) var viewModel: UserChatViewModel {
        didSet {
            objectWillChange.send()
        }
    }
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    // We've relocated the messages from the main SwiftUI View. Now, if you wish, you can handle the networking part here and populate this array with any data from your database. If you do so, please share your code and let's build the first global open-source chat app in SwiftUI together
   @Published var messages = [
        ChatMessage(message: "Hello, How can i help you?", avatar: "Bot", color: .gray),
    ] {
           didSet {
               objectWillChange.send()
           }
       }
    
    // this function will be accessible from SwiftUI main view
    // here you can add the necessary code to send your messages not only to the SwiftUI view, but also to the database so that other users of the app would be able to see it
    func sendMessage(_ chatMessage: ChatMessage) {
        //Send message to using mock chat service
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.postUserMessage(message: chatMessage.message)
        }
        // here we populate the messages array
        messages.append(chatMessage)
        // here we let the SwiftUI know that we need to rebuild the views
        objectWillChange.send(())
    }
    init(dependencies: UserChatPresenterDependenciesProtocol,
         interactor: UserChatInteractorProtocol,
         delegate: UserChatDelegate?) {
        self.dependencies = dependencies
        self.interactor = interactor
        self.delegate = delegate
        
        viewModel = UserChatViewModel()
    }
}

extension UserChatPresenter: UserChatPresenterProtocol {
    func didReceiveEvent(_ event: UserChatEvent) {
       
    }

    func didTriggerAction(_ action: UserChatAction) {

    }
}
extension UserChatPresenter {
    private func postUserMessage(message: String) {
        postUserMessageCancellable = interactor.postChat(message: message)
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { _ in
            
        }) { message in
            self.messages.append(ChatMessage(message: message, avatar: "Bot", color: .gray, isMe: false))
        }
    }
    
}
