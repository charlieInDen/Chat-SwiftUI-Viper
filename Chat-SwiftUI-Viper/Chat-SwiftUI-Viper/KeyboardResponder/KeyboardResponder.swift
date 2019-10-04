//
//  KeyboardResponder.swift
//  Github-SwiftUI-VIPER
//
//  Created by Nishant on 01/10/19.
//  Copyright © 2019 Nishant. All rights reserved.
//

import Combine
import SwiftUI

final class KeyboardResponder: ObservableObject {
    let didChange = PassthroughSubject<CGFloat, Never>()
    private var _center: NotificationCenter
    private var initialHeight: CGFloat = 0
    @Published private(set) var currentHeight: CGFloat = 0 {
        didSet {
            didChange.send(currentHeight)
        }
    }

    init(center: NotificationCenter = .default) {
        _center = center
        _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        _center.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if initialHeight == 0 {
                currentHeight = keyboardSize.height
                initialHeight = currentHeight
            }else {
                currentHeight = initialHeight
            }
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}
