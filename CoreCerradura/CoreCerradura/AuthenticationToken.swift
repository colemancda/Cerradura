//
//  AuthenticationToken.swift
//  CoreCerradura
//
//  Created by Alsey Coleman Miller on 5/3/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import SwiftFoundation
import OpenSSL

/// Generates the authentication token used for authenticating requests.
/// Modeled after [AWS](http://docs.aws.amazon.com/AmazonS3/latest/dev/RESTAuthentication.html#UsingTemporarySecurityCredentials)
///
/// - Parameter identifier: The identifier (e.g. resource ID or username) of the entity trying to authenticate.
/// - Parameter secret: The secret (e.g. password) of the entity trying to authenticate.
/// - Parameter context: The authentication context info.
/// - Returns: The generated authentication token.
public func GenerateAuthenticationToken(identifier: String, secret: String, context: AuthenticationContext) -> String {
    
    let stringToSign = context.concatenatedString
    
    let signedKey: Data
    
    do {
        
        let hmacContext = UnsafeMutablePointer<HMAC_CTX>()
        
        HMAC_CTX_init(hmacContext)
        
        let secretData = secret.utf8.map { (codeUnit) -> Byte in return codeUnit }
        
        HMAC_Init_ex(hmacContext, secretData, Int32(secretData.count), EVP_sha512(), nil)
        
        let identifierData = identifier.utf8.map { (codeUnit) -> Byte in return codeUnit }
        
        HMAC_Update(hmacContext, identifierData, identifierData.count)
        
        let digestLength = Int(SHA512_DIGEST_LENGTH)
        
        let result = UnsafeMutablePointer<Byte>.alloc(digestLength)
        
        defer { result.dealloc(digestLength) }
        
        var resultLength = UInt32(digestLength) // SHA512 digest length
        
        HMAC_Final(hmacContext, result, &resultLength)
        
        var resultData = Data()
        
        for byteIndex in 0...Int(resultLength) - 1 {
            
            let byte = result[byteIndex]
            
            resultData.append(byte)
        }
        
        assert(resultData.count == Int(resultLength))
        
        signedKey = resultData
    }
    
    let base64Signature = Base64.encode(signedKey)
    
    return "{\(identifier):\(base64Signature)}"
}