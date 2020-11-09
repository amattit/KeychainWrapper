//
//  KeychainWrapper.swift
//  KeychainWrapper
//
//  Created by Mikhail Seregin on 10/17/19.
//  Copyright © 2019 MikhailSeregin. All rights reserved.
//

import Foundation
public class KeychainWrapper: NSObject {
    
    private let keychainOperations: KeychainOperations
    
    public init(service: String) {
        self.keychainOperations = KeychainOperations(service: service)
    }
    
    /**
     Function to store a keychain item
     - parameters:
     - value: Value to store in keychain in `data` format
     - account: Account name for keychain item
     */
    public func set(value: Data, account: String) throws {
        // If the value exists `update the value`
        if try keychainOperations.exists(account: account) {
            try keychainOperations.update(value: value, account: account)
        } else {
            // Just insert
            try keychainOperations.add(value: value, account: account)
        }
    }
    /**
     Function to retrieve an item in ´Data´ format (If not present, returns nil)
     - parameters:
     - account: Account name for keychain item
     - returns: Data from stored item
     */
    public func get(account: String) throws -> Data? {
        if try keychainOperations.exists(account: account) {
            return try keychainOperations.retreive(account: account)
        } else {
            throw Errors.operationError
        }
    }
    /**
     Function to delete a single item
     - parameters:
     - account: Account name for keychain item
     */
    public func delete(account: String) throws {
        if try keychainOperations.exists(account: account) {
            return try keychainOperations.delete(account: account)
        } else {
            throw Errors.operationError
        }
    }
    /**
     Function to delete all items
     */
    public func deleteAll() throws {
        try keychainOperations.deleteAll()
    }
}
