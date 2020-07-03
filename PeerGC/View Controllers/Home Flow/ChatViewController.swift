//
//  ChatViewController.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/2/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

import Foundation
import UIKit
import MessageKit
import Firebase

class ChatViewController: MessagesViewController {
    
    public struct Message: MessageType, Equatable, Comparable {
        
        public var sender: SenderType
        
        public var messageId: String
        
        public var sentDate: Date
        
        public var kind: MessageKind
        
        public static func == (lhs: Message, rhs: Message) -> Bool {
            return lhs.messageId == rhs.messageId
        }
        
        public static func < (lhs: Message, rhs: Message) -> Bool {
            return lhs.sentDate < rhs.sentDate
        }
        
    }
    
    private let db = Firestore.firestore()
    private var reference: CollectionReference?
    
    var id: String = ""
    var header: String = ""
    
    private var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .secondarySystemGroupedBackground
        setupCollectionView()
        inputStyle()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        title = header
        
        reference = db.collection(["chats", id, "thread"].joined(separator: "/"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      
        let testMessage = Message(sender: Sender(senderId: Auth.auth().currentUser!.uid, displayName: "AJ"), messageId: "abcdefg", sentDate: Date(), kind: .text("Hello There!"))
      insertNewMessage(testMessage)
        let testMessage2 = Message(sender: Sender(senderId: Auth.auth().currentUser!.uid, displayName: "AJ"), messageId: "abcdefg2", sentDate: Date(), kind: .text("Hello There!"))
        insertNewMessage(testMessage)
        insertNewMessage(testMessage2)
    }
    
    private func insertNewMessage(_ message: Message) {
        guard !messages.contains(message) else {
            return
        }
      
        messages.append(message)
        messages.sort()
      
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = isLatestMessage //isAtBottom?
      
        messagesCollectionView.reloadData()
      
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        print("nav bar not hidden")
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    private func setupCollectionView() {
        guard let flowLayout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout else {
            print("Can't get flowLayout")
            return
        }
        if #available(iOS 13.0, *) {
            flowLayout.collectionView?.backgroundColor = .secondarySystemGroupedBackground
        }
    }
    
    func inputStyle() {
        if #available(iOS 13.0, *) {
            messageInputBar.inputTextView.textColor = .label
            messageInputBar.inputTextView.placeholderLabel.textColor = .secondaryLabel
            messageInputBar.backgroundView.backgroundColor = .secondarySystemGroupedBackground
        }
    }
}

extension ChatViewController: MessagesDataSource {

    public struct Sender: SenderType {
        public let senderId: String

        public let displayName: String
    }
    
    func currentSender() -> SenderType {
        return Sender(senderId: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser!.displayName!.components(separatedBy: " ")[0])
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
}

extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 16)
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .systemPink
    }
    
}
