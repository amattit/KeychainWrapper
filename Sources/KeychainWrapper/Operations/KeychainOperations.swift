//
//  KeychainOperations.swift
//  KeychainWrapper
//
//  Created by Mikhail Seregin on 10/17/19.
//  Copyright © 2019 MikhailSeregin. All rights reserved.
//

import Foundation

internal class KeychainOperations: NSObject {
    internal var service: String
    
    init(service: String) {
        self.service = service
    }
    /**
     Funtion to add an item to keychain
     - parameters:
     - value: Value to save in `data` format (String, Int, Double, Float, etc)
     - account: Account name for keychain item
     */
    internal func add(value: Data, account: String) throws {
        let status = SecItemAdd([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: self.service,
            // Allow background access:
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
            kSecValueData: value,
            ] as NSDictionary, nil)
        guard status == errSecSuccess else { throw Errors.operationError }
    }
    /**
     Function to update an item to keychain
     - parameters:
     - value: Value to replace for
     - account: Account name for keychain item
     */
    internal func update(value: Data, account: String) throws {
        let status = SecItemUpdate([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            ] as NSDictionary, [
                kSecValueData: value,
                ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.operationError }
    }
    /**
     Function to retrieve an item to keychain
     - parameters:
     - account: Account name for keychain item
     */
    internal func retreive(account: String) throws -> Data? {
        /// Result of getting the item
        var result: AnyObject?
        /// Status for the query
        let status = SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecReturnData: true,
            ] as NSDictionary, &result)
        // Switch to conditioning statement
        switch status {
        case errSecSuccess:
            return result as? Data
        case errSecItemNotFound:
            return nil
        default:
            throw Errors.operationError
        }
    }
    /**
     Function to delete a single item
     - parameters:
     - account: Account name for keychain item
     */
    internal func delete(account: String) throws {
        /// Status for the query
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.operationError }
    }
    /**
     Function to delete all items for the app
     */
    internal func deleteAll() throws {
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            ] as NSDictionary)
        guard status == errSecSuccess else { throw Errors.operationError }
    }
    /**
     Function to check if we've an existing a keychain `item`
     - parameters:
     - account: String type with the name of the item to check
     - returns: Boolean type with the answer if the keychain item exists
     */
    public func exists(account: String) throws -> Bool {
        /// Constant with current status about the keychain to check
        let status = SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: service,
            kSecReturnData: false,
            ] as NSDictionary, nil)
        // Switch to conditioning statement
        switch status {
        case errSecSuccess:
            return true
        case errSecItemNotFound:
            return false
        default:
            throw Errors.creatingError
        }
    }
}
