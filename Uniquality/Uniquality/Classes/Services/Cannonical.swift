//
//  Cannonical.swift
//  Uniquality
//
//  Created by Александр on 20.11.2020.
//  Copyright © 2020 AlexBugatti. All rights reserved.
//

import Foundation

class Cannonical {
    
    private var text: String
    var summary: String {
        return self.toResult()
    }
    
    static let whitespaces = ["  ", "   ", "    ", "     ", "      ", "       "]
    
    init(text: String) {
        self.text = text
    }
    
    func toResult() -> String {
        
        text = text.lowercased()
        
        for punctuation in Storage.punctuations {
            text = text.replacingOccurrences(of: punctuation, with: " ")
        }
        
        let prepositions = Storage.prepositions.sorted(by: { $0.count > $1.count })
        for prep in prepositions {
            text = text.replacingOccurrences(of: " \(prep) ", with: " ")
        }
        
        let unions = Storage.unions.sorted(by: { $0.count > $1.count })
        for union in unions {
            text = text.replacingOccurrences(of: " \(union) ", with: " ")
        }
        
        text = text.removeExtraSpaces()
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return text
    }
    
    func isValid() -> String? {
        
        if self.text.components(separatedBy: " ").count < Constants.shingleLenght {
            return "Длина текста должна состоять больше чем из 10 слов (предлоги и союзы не считаются)"
        }
        
        return nil
    }
    
}
