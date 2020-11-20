//
//  API.swift
//  Uniquality
//
//  Created by Александр on 18.11.2020.
//  Copyright © 2020 AlexBugatti. All rights reserved.
//

import UIKit
import Firebase

class API {

    class func getNotes(completion: @escaping (([Note])->())) {
        let query = Firestore.firestore().collection("data")
        query.addSnapshotListener { (notes, error) in
            guard let snapshot = notes else {
                print("Error fetching documents results: \(error!)")
                return
            }
            
            let notes = snapshot.documents.compactMap({ Note(from: $0.data()) })
            completion(notes)
        }
    }
    
    class func add(note: Note, completion: @escaping ((Bool)->())) {
        let query = Firestore.firestore().collection("data")
        query.addDocument(data: note.map) { (error) in
            completion(error == nil)
        }
    }
    
}

