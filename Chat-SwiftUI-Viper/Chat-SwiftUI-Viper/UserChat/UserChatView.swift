//
//  UserChatView.swift
//  Github-SwiftUI-VIPER
//
//  Created Nishant on 30/09/19.
//  Copyright © 2019 Nishant. All rights reserved.
//
//

import SwiftUI

protocol UserChatViewProtocol: UserChatProtocol {
    
}
protocol ChatMessageProtocol: UserChatProtocol, Identifiable {
    var message: String { get }
    var avatar: String { get }
    var color: Color { get }
    // isMe will be true if We sent the message
    var isMe: Bool { get }
}
// let's create a structure that will represent each message in chat
struct ChatMessage : ChatMessageProtocol, Hashable {
    var id = UUID()
    
    var message: String
    var avatar: String
    var color: Color
    // isMe will be true if We sent the message
    var isMe: Bool = false
}


struct UserChatView: View {
    @ObservedObject private var presenter: UserChatPresenter
    // @State here is necessary to make the composedMessage variable accessible from different views
    @State var composedMessage: String = ""
    @ObservedObject var keyboard = KeyboardResponder()
    @EnvironmentObject var model: Model
    private let userName: String
    var body: some View {
        // the VStack is a vertical stack where we place all our substacks like the List and the TextField
            VStack {
                
                // List is the way you should create any list in SwiftUI
                List(presenter.messages) { chatMessage in
                    ChatRow(chatMessage: chatMessage)
                }.navigationBarTitle(Text("@" + userName), displayMode: .inline)
                
                // TextField are aligned with the Send Button in the same line so we put them in HStack
                HStack {
                    // this textField generates the value for the composedMessage @State var
                    //                TextField($composedMessage, placeholder: Text("Message...")).frame(minHeight: CGFloat(30))
                    TextField("Message...", text: $composedMessage).textFieldStyle(RoundedBorderTextFieldStyle())
                    // the button triggers the sendMessage() function written in the end of current View
                    Button(action: sendMessage) {
                        Text("Send").bold()
                        
                    }
                }.frame(minHeight: CGFloat(40)).padding()
                
                // that's the height of the HStack
            }.offset(y: -keyboard.currentHeight)
        .environmentObject(model)

    }
    func sendMessage() {
        presenter.sendMessage(ChatMessage(message: composedMessage, avatar: "You", color: .blue, isMe: true))
        composedMessage = ""
    }
    init(delegate: UserChatDelegate?, name: String) {
        self.userName = name
        UITableView.appearance().separatorColor = .clear
        self.presenter = UserChatWireframe.makePresenter(delegate: delegate)
        presenter.didReceiveEvent(.viewDidInit)
    }
}

extension UserChatView: UserChatViewProtocol {
    
}

extension UserChatView: UserChatProtocol {
    
}

#if DEBUG
struct UserChatView_Previews: PreviewProvider {
    static var previews: some View {
        UserChatView(delegate: nil, name: "Demo Chat")
    }
}
#endif

// ChatRow will be a view similar to a Cell in standard Swift
struct ChatRow : View {
    var chatMessage: ChatMessage
    
    // body - is the body of the view, just like the body of the first view we created when opened the project
    var body: some View {
        Group {
            // if the message is sent by the user,
            // show it on the right side of the view
            
            // HStack - is a horizontal stack. We let the SwiftUI know that we need to place
            // all the following contents horizontally one after another
            HStack {
                if !chatMessage.isMe {
                    Text(chatMessage.message)
                        .bold()
                        .foregroundColor(Color.white)
                        .padding(16)
                        .background(
                            Image("left_bubble")
                                .resizable(capInsets: EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20), resizingMode: .stretch))
                    // Spacer fills the gaps of the Horizontal stack between the content and the borders
                    Spacer()
                } else {
                    // else show the message on the left side
                    Spacer()
                    Text(chatMessage.message)
                        .bold()
                        .foregroundColor(Color.white)
                        .padding(16)
                        .background(Image("right_bubble")
                            .resizable(capInsets: EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20), resizingMode: .stretch))
                }
            }
        }
    }
}
