//
//  Note.swift
//  Uniquality
//
//  Created by Александр on 18.11.2020.
//  Copyright © 2020 AlexBugatti. All rights reserved.
//

import UIKit

class Note {

    var note: String
    var username: String
    var date: Int
    
    var md5: [String] = []
    var sha1: [String] = []
    
    var map: [String: Any] {
        return ["note": note,
                "username": username,
                "md5": md5,
                "sha1": sha1,
                "date": date]
    }
    
    
    init(note: String, username: String, md5: [String], sha1: [String]) {
        self.note = note
        self.username = username
        self.md5 = md5
        self.sha1 = sha1
        self.date = Int(Date().timeIntervalSince1970)
    }
    
    init?(from map: [String: Any]) {
        guard let note = map["note"] as? String,
              let username = map["username"] as? String,
              let date = map["date"] as? Int else {
            return nil
        }
        
        if let md5 = map["md5"] as? [String] {
            self.md5 = md5
        }
        if let sha1 = map["sha1"] as? [String] {
            self.sha1 = sha1
        }
        self.note = note
        self.username = username
        self.date = date
    }
    
    func isEqual(note: Note) -> CGFloat {
        
        let counts = self.md5.count + self.sha1.count
        var equality = 0
        
        for element in self.md5 {
            if note.md5.contains(element) {
                equality += 1
            }
        }
        
        for element in self.sha1 {
            if note.sha1.contains(element) {
                equality += 1
            }
        }
        
        return CGFloat(equality) / CGFloat(counts)
    }
    
}
