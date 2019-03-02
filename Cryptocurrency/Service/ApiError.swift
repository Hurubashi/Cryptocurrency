//
//  ApiError.swift
//  Cryptocurrency
//
//  Created by Max Rybak on 3/2/19.
//  Copyright © 2019 Max Rybak. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case wentWrong
    case noConnection
}

extension ApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .wentWrong: return NSLocalizedString("Something went wrong", comment: "My error")
        case .noConnection: return NSLocalizedString("No connection", comment: "My error")
        }
    }
}
