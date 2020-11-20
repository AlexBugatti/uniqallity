//
//  NotesViewController.swift
//  Uniquality
//
//  Created by Александр on 07.09.2020.
//  Copyright © 2020 AlexBugatti. All rights reserved.
//

import UIKit
import MBProgressHUD

class NotesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(NoteCell.self)
        }
    }
    private var notes: [Note] = [] {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getNotes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    func createNote() {
        let vc = CreateNoteViewController(nibName: nil, bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    private func getNotes() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        API.getNotes { (notes) in
            hud.hide(animated: true)
            Storage.shared.notes = notes
            self.notes = notes
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onDidActionTapped(_ sender: Any) {
        self.createNote()
    }
    
    @IBAction func onDidCreate(_ sender: Any) {
        self.addNote("Qwertyy qweqwe qweqwe wqe", author: "Alex")
    }
    
    func addNote(_ note: String, author: String) {
        self.createNote()
    }
    
}

extension NotesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = self.notes[indexPath.row]
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as NoteCell
        cell.configure(note: note)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = self.notes[indexPath.row]
        let vc = DetailController.init(note: note)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
