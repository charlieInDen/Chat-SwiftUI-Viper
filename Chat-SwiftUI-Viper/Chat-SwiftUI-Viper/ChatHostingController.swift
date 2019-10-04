//
//  GithubUserHostingController.swift
//  Github-SwiftUI-VIPER
//
//  Created by Nishant on 03/10/19.
//  Copyright © 2019 Nishant. All rights reserved.
//

import SwiftUI

class Model: ObservableObject {
    @Published var landscape: Bool = false

    init(isLandscape: Bool) {
        self.landscape = isLandscape // Initial value
        NotificationCenter.default.addObserver(self, selector: #selector(onViewWillTransition(notification:)), name: .my_onViewWillTransition, object: nil)
    }

    @objc func onViewWillTransition(notification: Notification) {
        guard let size = notification.userInfo?["size"] as? CGSize else { return }

        landscape = size.width > size.height
    }
}


extension Notification.Name {
    static let my_onViewWillTransition = Notification.Name("MainUIHostingController_viewWillTransition")
}

class ChatHostingController<Content> : UIHostingController<Content> where Content : View {

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        NotificationCenter.default.post(name: .my_onViewWillTransition, object: nil, userInfo: ["size": size])
        super.viewWillTransition(to: size, with: coordinator)
    }

}
