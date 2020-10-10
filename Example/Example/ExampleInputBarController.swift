//
//  CommonTableViewController.swift
//  Example
//
//  Created by Nathan Tannar on 2018-07-10.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import BinartSwiftInputBar

class ExampleInputBarController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let inputBar: InputBarAccessoryView
    
    let tableView = UITableView()
    
    let conversation: SampleData.Conversation
    
    private var keyboardManager = KeyboardManager()
    
    /// The object that manages attachments
    open lazy var attachmentManager: AttachmentManager = { [unowned self] in
        let manager = AttachmentManager()
        manager.delegate = self
        return manager
    }()
    
    /// The object that manages autocomplete
//    open lazy var autocompleteManager: AutocompleteManager = { [unowned self] in
//        let manager = AutocompleteManager(for: self.inputBar.inputTextView)
//        manager.delegate = self
//        manager.dataSource = self
//        return manager
//    }()
    
    var hashtagAutocompletes: [AutocompleteCompletion] = {
        var array: [AutocompleteCompletion] = []
        for _ in 1...100 {
            array.append(AutocompleteCompletion(text: Lorem.word(), context: nil))
        }
        return array
    }()
    
    // Completions loaded async that get appeneded to local cached completions
    var asyncCompletions: [AutocompleteCompletion] = []
    
    init(style: InputBarStyle, conversation: SampleData.Conversation) {
        self.conversation = conversation
        self.inputBar = style.generate()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .interactive
        tableView.register(ConversationCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
        
        inputBar.delegate = self
//        inputBar.inputTextView.keyboardType = .twitter
 
        // Configure AutocompleteManager
//        autocompleteManager.register(prefix: "@", with: [.font: UIFont.preferredFont(forTextStyle: .body),.foregroundColor: UIColor(red: 0, green: 122/255, blue: 1, alpha: 1),.backgroundColor: UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.1)])
//        autocompleteManager.register(prefix: "#")
//        autocompleteManager.maxSpaceCountDuringCompletion = 1 // Allow for autocompletes with a space
//
        // Set plugins
//        inputBar.inputPlugins = [autocompleteManager, attachmentManager]
        
        // RTL Support
//        autocompleteManager.paragraphStyle.baseWritingDirection = .rightToLeft
//        inputBar.inputTextView.textAlignment = .right
//        inputBar.inputTextView.placeholderLabel.textAlignment = .right
        
        view.addSubview(inputBar)
        
        // Binding the inputBar will set the needed callback actions to position the inputBar on top of the keyboard
        keyboardManager.bind(inputAccessoryView: inputBar)
        
        // Binding to the tableView will enabled interactive dismissal
        keyboardManager.bind(to: tableView)
        
        // Add some extra handling to manage content inset
        keyboardManager.on(event: .didChangeFrame) { [weak self] (notification) in
            let barHeight = self?.inputBar.bounds.height ?? 0
            self?.tableView.contentInset.bottom = barHeight + notification.endFrame.height
            self?.tableView.scrollIndicatorInsets.bottom = barHeight + notification.endFrame.height
            }.on(event: .didHide) { [weak self] _ in
                let barHeight = self?.inputBar.bounds.height ?? 0
                self?.tableView.contentInset.bottom = barHeight
                self?.tableView.scrollIndicatorInsets.bottom = barHeight
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.image = conversation.messages[indexPath.row].user.image
        cell.imageView?.layer.cornerRadius = 5
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = conversation.messages[indexPath.row].user.name
        cell.textLabel?.font = .boldSystemFont(ofSize: 15)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.textColor = .darkGray
        cell.detailTextLabel?.font = .systemFont(ofSize: 14)
        cell.detailTextLabel?.text = conversation.messages[indexPath.row].text
        cell.detailTextLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        return cell
    }
}

extension ExampleInputBarController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeTextIn range: NSRange, toText text: String) {
        
    }
    
    // MARK: - InputBarAccessoryViewDelegate
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        print("send \(text)")
        // Here we can parse for which substrings were autocompleted
//        let attributedText = inputBar.inputTextView.attributedText!
//        let range = NSRange(location: 0, length: attributedText.length)
//        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (attributes, range, stop) in
//
//            let substring = attributedText.attributedSubstring(from: range)
//            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
//            print("Autocompleted: `", substring, "` with context: ", context ?? [])
//        }
//
//        inputBar.inputTextView.text = String()
//        inputBar.invalidatePlugins()

        // Send button activity animation
//        inputBar.sendButton.startAnimating()
//        inputBar.inputTextView.placeholder = "Sending..."
//        DispatchQueue.global(qos: .default).async {
//            // fake send request task
//            sleep(1)
//            DispatchQueue.main.async { [weak self] in
//                inputBar.sendButton.stopAnimating()
//                inputBar.inputTextView.placeholder = "Aa"
//                self?.conversation.messages.append(SampleData.Message(user: SampleData.shared.currentUser, text: text))
//                let indexPath = IndexPath(row: (self?.conversation.messages.count ?? 1) - 1, section: 0)
//                self?.tableView.insertRows(at: [indexPath], with: .automatic)
//                self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//            }
//        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        // Adjust content insets
        print(size)
        tableView.contentInset.bottom = size.height + 300 // keyboard size estimate
    }
    
    @objc(inputBar:textViewBeginEditing:) func inputBar(_ inputBar: InputBarAccessoryView, textViewBeginEditing text: String) {
//
//        guard autocompleteManager.currentSession != nil, autocompleteManager.currentSession?.prefix == "#" else { return }
//        // Load some data asyncronously for the given session.prefix
//        DispatchQueue.global(qos: .default).async {
//            // fake background loading task
//            var array: [AutocompleteCompletion] = []
//            for _ in 1...10 {
//                array.append(AutocompleteCompletion(text: Lorem.word()))
//            }
//            sleep(1)
//            DispatchQueue.main.async { [weak self] in
//                self?.asyncCompletions = array
//                self?.autocompleteManager.reloadData()
//            }
//        }
    }
    
}

extension ExampleInputBarController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        dismiss(animated: true, completion: {
            if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                let handled = self.attachmentManager.handleInput(of: pickedImage)
                if !handled {
                    // throw error
                }
            }
        })
    }
}

extension ExampleInputBarController: AttachmentManagerDelegate {
    // MARK: - AttachmentManagerDelegate
    
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
//        inputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
//        inputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
//        inputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - AttachmentManagerDelegate Helper
    
    func setAttachmentManager(active: Bool) {
        
//        let topStackView = inputBar.topStackView
//        if active && !topStackView.subviews.contains(attachmentManager.attachmentView) {
//            topStackView.insertSubview(attachmentManager.attachmentView, at: topStackView.subviews.count)
//            topStackView.layoutIfNeeded()
//        } else if !active && topStackView.subviews.contains(attachmentManager.attachmentView) {
////            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
//            topStackView.layoutIfNeeded()
//        }
    }
}

extension ExampleInputBarController: AutocompleteManagerDelegate, AutocompleteManagerDataSource {
    
    // MARK: - AutocompleteManagerDataSource
    
    func autocompleteManager(_ manager: AutocompleteManager, autocompleteSourceFor prefix: String) -> [AutocompleteCompletion] {
        
        if prefix == "@" {
            return conversation.users
                .filter { $0.name != SampleData.shared.currentUser.name }
                .map { user in
                    return AutocompleteCompletion(text: user.name,
                                                  context: ["id": user.id])
            }
        } else if prefix == "#" {
            return hashtagAutocompletes + asyncCompletions
        }
        return []
    }
    
    func autocompleteManager(_ manager: AutocompleteManager, tableView: UITableView, cellForRowAt indexPath: IndexPath, for session: AutocompleteSession) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AutocompleteCell.reuseIdentifier, for: indexPath) as? AutocompleteCell else {
            fatalError("Oops, some unknown error occurred")
        }
        let users = SampleData.shared.users
        let name = session.completion?.text ?? ""
        let user = users.filter { return $0.name == name }.first
        cell.imageView?.image = user?.image
        cell.textLabel?.attributedText = manager.attributedText(matching: session, fontSize: 15)
        return cell
    }
    
    // MARK: - AutocompleteManagerDelegate
    
    func autocompleteManager(_ manager: AutocompleteManager, shouldBecomeVisible: Bool) {
        setAutocompleteManager(active: shouldBecomeVisible)
    }
    
    // Optional
    func autocompleteManager(_ manager: AutocompleteManager, shouldRegister prefix: String, at range: NSRange) -> Bool {
        return true
    }
    
    // Optional
    func autocompleteManager(_ manager: AutocompleteManager, shouldUnregister prefix: String) -> Bool {
        return true
    }
    
    // Optional
    func autocompleteManager(_ manager: AutocompleteManager, shouldComplete prefix: String, with text: String) -> Bool {
        return true
    }
    
    // MARK: - AutocompleteManagerDelegate Helper
    
    func setAutocompleteManager(active: Bool) {
//        let topStackView = inputBar.topStackView
//        if active && !topStackView.arrangedSubviews.contains(autocompleteManager.tableView) {
//            topStackView.insertArrangedSubview(autocompleteManager.tableView, at: topStackView.arrangedSubviews.count)
//            topStackView.layoutIfNeeded()
//        } else if !active && topStackView.arrangedSubviews.contains(autocompleteManager.tableView) {
//            topStackView.removeArrangedSubview(autocompleteManager.tableView)
//            topStackView.layoutIfNeeded()
//        }
//        inputBar.invalidateIntrinsicContentSize()
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
