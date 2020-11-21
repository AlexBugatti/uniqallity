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
        
        let words = self.components(separatedBy: " ")
        var shingles: [String] = []
        
        for (index, _) in words.enumerated() {
            
            if words.count - Constants.shingleLenght >= index {
                
                var substrings: [String] = []
                for i in index..<(index+Constants.shingleLenght) {
                    substrings.append(words[i])
                }
                
                switch crypt {
                    case .sha1:
                        let strings = substrings.compactMap({ $0.sha1() })
                        shingles.append(contentsOf: strings)
                    case .md5:
                        let strings = substrings.compactMap({ $0.md5() })
                        shingles.append(contentsOf: strings)
                }
                
            }
            
        }
        
        return shingles
    }
    
}

