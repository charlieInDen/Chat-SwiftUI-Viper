//
//  APIServiceError.swift
//  Github-SwiftUI-VIPER
//
//  Created Nishant on 02/10/19.
//  Copyright © 2019 Nishant. All rights reserved.
//
//

import Foundation

enum APIServiceError: Error {
    case couldNotCreateURL
    case responseError
    case parseError(Error)
}
