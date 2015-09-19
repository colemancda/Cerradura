//
//  AuthenticationToken.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 5/3/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import IDZSwiftCommonCrypto

/// Generates the authentication token used for authenticating requests.
/// Modeled after [AWS](http://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAuthentication.html#UsingTemporarySecurityCredentials)
///
/// - Parameter identifier: The identifier (e.g. resource ID or username) of the entity trying to authenticate.
/// - Parameter secret: The secret (e.g. password) of the entity trying to authenticate.
/// - Parameter context: The authentication context info.
/// - Returns: The generated authentication token.
public func GenerateAuthenticationToken(identifier: String, secret: String, context: AuthenticationContext) -> String {
    
    let stringToSign = context.concatenatedString
    
    let secretData = (secret as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
    
    let signedKeyBytes = HMAC(algorithm: HMAC.Algorithm.SHA512, key: secretData).update(stringToSign)!.final()
    
    let signedKey = NSData(bytes: signedKeyBytes, length: signedKeyBytes.count)
    
    let base64Signature = signedKey.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
    
    return "{\(identifier):\(base64Signature)}"
}
