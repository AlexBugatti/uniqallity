//
//  Storage.swift
//  Uniquality
//
//  Created by Александр on 20.11.2020.
//  Copyright © 2020 AlexBugatti. All rights reserved.
//

import Foundation

class Storage {

    static let shared = Storage()
    
    static var prepositions: [String] {
        if let path = Bundle.main.path(forResource: "config", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let prepositions = json["prepositions"] as? [String] {
                        return prepositions
                    }
                }
            } catch {}
        }
        
        return []
    }
    
    static var punctuations: [String] {
        if let path = Bundle.main.path(forResource: "config", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let punctuations = json["punctuation"] as? [String] {
                        return punctuations
                    }
                }
            } catch {}
        }
        
        return []
    }
    
    static var unions: [String] {
        if let path = Bundle.main.path(forResource: "config", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let unions = json["unions"] as? [String] {
                        return unions
                    }
                }
            } catch {}
        }
        
        return []
    }
    
    var notes: [Note] = []
}
