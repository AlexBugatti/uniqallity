//
//  Extension+KeyboardObserver.swift
//  BertaApp
//
//  Created by Pavel Aristov on 17/05/2019.
//  Copyright © 2019 aristovz. All rights reserved.
//

import Foundation
import UIKit

struct NotificationDescriptor<Payload> {
    let name: Notification.Name
    let convert: (Notification) -> Payload
}

extension NotificationCenter {
    
    @discardableResult
    func addObserver<Payload>(with descriptor: NotificationDescriptor<Payload>, block: @escaping (Payload) -> ()) -> NSObjectProtocol {
        return addObserver(forName: descriptor.name, object: nil, queue: nil) { (note) in
            block(descriptor.convert(note))
        }
    }
}

struct KeyboardPayload {
    let beginFrame: CGRect
    let endFrame: CGRect
    let curve: UIView.AnimationCurve
    let duration: TimeInterval
    let isLocal: Bool
}

extension KeyboardPayload {
    init(note: Notification) {
        let userInfo = note.userInfo
        beginFrame = userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        endFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        curve = UIView.AnimationCurve(rawValue: userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        isLocal = userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as! Bool
    }
}

extension UIViewController {
    static let keyboardWillShow = NotificationDescriptor(name: UIResponder.keyboardWillShowNotification, convert: KeyboardPayload.init)
    static let keyboardWillHide = NotificationDescriptor(name: UIResponder.keyboardWillHideNotification, convert: KeyboardPayload.init)
}

extension UITextView {
    func removePaddings() {
        self.textContainerInset = UIEdgeInsets.init(top: 10, left: 5, bottom: 10, right: 10)
//        self.contentInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
    }
}

protocol PlaceholderTextViewDelegate {
    func placeholderTextViewDidChangeText(_ text:String)
    func placeholderTextViewDidEndEditing(_ text:String)
}

//@IBDesignable
final class PlaceholderTextView: UITextView {
    
    var notifier: PlaceholderTextViewDelegate?
    
    @IBInspectable var placeholder: String? {
        didSet {
            placeholderLabel?.text = placeholder
        }
    }
    
    fileprivate var placeholderLabel: UILabel?
    
    // MARK: - LifeCycle
    
    init() {
        super.init(frame: CGRect.zero, textContainer: nil)
        awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(PlaceholderTextView.textDidChangeHandler(notification:)), name: UITextView.textDidChangeNotification, object: nil)
        
        placeholderLabel = UILabel()
        placeholderLabel?.text = placeholder
        placeholderLabel?.textAlignment = .left
        placeholderLabel?.numberOfLines = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        var height: CGFloat = 0
        if let data = placeholderLabel?.text {
            
            let expectedDefaultWidth:CGFloat = bounds.size.width
//            let fontSize: CGFloat = placeholderFont.pointSize
            
            let textView = UITextView()
            textView.text = data
//            textView.font = appFont
            let sizeForTextView = textView.sizeThatFits(CGSize(width: expectedDefaultWidth,
                                                               height: CGFloat.greatestFiniteMagnitude))
            let expectedTextViewHeight = sizeForTextView.height
            
            if expectedTextViewHeight > height {
                height = expectedTextViewHeight
            }
        }
        
        placeholderLabel?.frame = CGRect(x: 12, y: 2, width: bounds.size.width - 20, height: height)
        
        if text.isEmpty {
            addSubview(placeholderLabel!)
            bringSubviewToFront(placeholderLabel!)
        } else {
            placeholderLabel?.removeFromSuperview()
        }
    }
    
    @objc func textDidChangeHandler(notification: Notification) {
        layoutSubviews()
    }
    
}

extension PlaceholderTextView : UITextViewDelegate {
    // MARK: - UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        notifier?.placeholderTextViewDidChangeText(textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        notifier?.placeholderTextViewDidEndEditing(textView.text)
    }
}
