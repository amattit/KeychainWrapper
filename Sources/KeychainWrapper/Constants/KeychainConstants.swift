//
//  KeychainConstants.swift
//  KeychainWrapper
//
//  Created by Mikhail Seregin on 10/17/19.
//  Copyright © 2019 MikhailSeregin. All rights reserved.
//

/**
 Private enum to return possible errors
 */
internal enum Errors: Error {
    /// Error with the keychain creting and checking
    case creatingError
    /// Error for operation
    case operationError
}

