//
//  DetailController.swift
//  Uniquality
//
//  Created by Александр on 20.11.2020.
//  Copyright © 2020 AlexBugatti. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    var note: Note
    @IBOutlet weak var textView: UITextView!
    
    init(note: Note) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = self.note.username
        self.textView.text = note.note
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
