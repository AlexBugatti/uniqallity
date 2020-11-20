//
//  CreateNoteViewController.swift
//  Uniquality
//
//  Created by Александр on 07.09.2020.
//  Copyright © 2020 AlexBugatti. All rights reserved.
//

import UIKit
import MBProgressHUD

class CreateNoteViewController: UIViewController {

    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var authorTextView: UITextField!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var uniqButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    
    private var observers = [NSObjectProtocol]()
    
    override func viewWillAppear(_ animated: Bool) {
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unregisterKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.uniqButton.layer.cornerRadius = 6
        self.uniqButton.layer.masksToBounds = true
        self.saveButton.layer.cornerRadius = 6
        self.saveButton.layer.masksToBounds = true
        
        self.textView.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onDidSaveTapped(_ sender: Any) {
        self.createNote()
    }
    
    @IBAction func onDidDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDidUniq(_ sender: Any) {
        
        guard self.textView.text.isEmpty == false else {
            self.showAlert(message: "Введите текст статьи")
            return
        }
        
        let cannonocal = Cannonical(text: textView.text)
        let result = cannonocal.toResult()
        
        if let errorString = cannonocal.isValid() {
            self.showAlert(message: errorString)
            return
        }
        
        let md5 = result.getShingles(crypt: .md5)
        let sha1 = result.getShingles(crypt: .sha1)
        
        let note = Note(note: result, username: "Author", md5: md5, sha1: sha1)

        var uniqs: [Uniq] = []
        for not in Storage.shared.notes {
            let uniq = Uniq(title: not.note, percent: note.isEqual(note: not))
            uniqs.append(uniq)
        }
        
        let vc = PresentUniqueController(uniqs: uniqs)
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func createNote() {
        
        guard self.textView.text.isEmpty == false else {
            self.showAlert(message: "Не все поля заполнены")
            return
        }
        
        guard let author = authorTextView.text, author.isEmpty == false else {
            self.showAlert(message: "Введите автора")
            return
        }
        
        let cannonocal = Cannonical(text: textView.text)
        let result = cannonocal.toResult()
        
        if let errorString = cannonocal.isValid() {
            self.showAlert(message: errorString)
            return
        }
        
        let md5 = result.getShingles(crypt: .md5)
        let sha1 = result.getShingles(crypt: .sha1)
        
        let note = Note(note: textView.text, username: author, md5: md5, sha1: sha1)
        
        print(note)
        print("\(result)")

        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        API.add(note: note) { (success) in
            hud.hide(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
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

extension CreateNoteViewController {
    
    // MARK: - Keyboard Observations
    
    func registerKeyboardNotifications() {
        let center = NotificationCenter.default
        
        let willShowObserver = center.addObserver(with: UIViewController.keyboardWillShow) { payload in
            self.bottomConstraint.constant = payload.endFrame.height
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }) { (success) in
            }
        }
        
        let willHideObserver = center.addObserver(with: UIViewController.keyboardWillHide) { payload in
            self.bottomConstraint.constant = 0
            UIView.animate(withDuration: 0.2, animations: { self.view.layoutIfNeeded() })
        }
        
        observers = [willShowObserver, willHideObserver]
    }
    
    func unregisterKeyboardNotifications() {
        observers.forEach({ NotificationCenter.default.removeObserver($0) })
    }
}
