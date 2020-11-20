//
//  Extension+Crypto.swift
//  Uniquality
//
//  Created by Александр on 20.11.2020.
//  Copyright © 2020 AlexBugatti. All rights reserved.
//

//import CommonCrypto
import Foundation
import CryptoKit

enum Crypt {
    case md5
    case sha1
}

extension String {
//    func sha1() -> String {
//        let data = Data(self.utf8)
//
//        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
//        data.withUnsafeBytes {
//            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
//        }
//        let hexBytes = digest.map { String(format: "%02hhx", $0) }
//        return hexBytes.joined()
//    }
    
    func md5() -> String? {
        guard let data = self.data(using: .utf8) else { return nil }
        let hash = Insecure.MD5.hash(data: data)
        
        return hash.makeIterator().map { String(format: "%02x", $0) }.joined()
    }
    
    func sha1() -> String? {
        guard let data = self.data(using: .utf8) else { return nil }
        let hash = Insecure.SHA1.hash(data: data)
        
        return hash.makeIterator().map { String(format: "%02x", $0) }.joined()
    }
    
    func removeExtraSpaces() -> String {
        return self.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
    }
    
    func getShingles(crypt: Crypt) -> [String] {
        switch crypt {
            case .sha1:
                let strings = self.components(separatedBy: " ").compactMap({ $0.sha1() })
                return strings
            case .md5:
                let strings = self.components(separatedBy: " ").compactMap({ $0.md5() })
                return strings
        }
    }
    
}

