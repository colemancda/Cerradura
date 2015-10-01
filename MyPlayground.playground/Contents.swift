//: Playground - noun: a place where people can play

import SwiftFoundation
import OpenSSL

let concatenatedString = "\(Date())example"

func generateToken(identifier: String, secret: String) -> String {
    
    let stringToSign = concatenatedString
    
    let signature: Data
    
    do {
        
        let hmacContext = UnsafeMutablePointer<HMAC_CTX>()
        
        HMAC_CTX_init(hmacContext)
        
        let secretData = secret.toUTF8Data()
        
        HMAC_Init_ex(hmacContext, secretData, Int32(secretData.count), EVP_sha512(), nil)
        
        let identifierData = identifier.toUTF8Data()
        
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
        
        signature = resultData
    }
    
    let base64SignatureData = Base64.encode(signature)
    
    guard let base64Signature = String(UTF8Data: base64SignatureData)
        else { fatalError("Could not create string from Base64 data") }
    
    return base64Signature
}
