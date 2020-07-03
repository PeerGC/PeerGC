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
import InputBarAccessoryView

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
        
        var representation: [String : Any] {
          
            var text: NSAttributedString
            
            switch kind {
                case .attributedText(let attributedText):
                    text = attributedText
                default:
                    return [:]
            }
            
            let rep: [String : Any] = [
            "senderID": sender.senderId,
            "senderDisplayName": sender.displayName,
            "messageID": messageId,
            "dateStamp": sentDate,
            "content": text.string
          ]
          
          return rep
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
        messageInputBar.delegate = self
        title = header
        
        db.collection("chats").document(id).setData([
            "Student": id.components(separatedBy: "-")[0],
            "Tutor": id.components(separatedBy: "-")[1]
        ])
        
        reference = db.collection(["chats", id, "thread"].joined(separator: "/"))
    }
    
    private func save(_ message: Message) {
      reference?.addDocument(data: message.representation) { error in
        if let e = error {
          print("Error sending message: \(e.localizedDescription)")
          return
        }
        
        self.messagesCollectionView.scrollToBottom()
      }
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

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print("called HIIII")
        
        // 1
          let message = Message(sender: Sender(senderId: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser!.displayName!.components(separatedBy: " ")[0]), messageId: UUID().uuidString, sentDate: Date(), kind: .attributedText(NSAttributedString(string: text)))

        // 2
        save(message)

        // 3
        inputBar.inputTextView.text = ""
    }
}
