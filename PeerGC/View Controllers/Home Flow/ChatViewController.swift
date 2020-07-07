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
    
    var currentSenderImage : UIImage? = nil
    var remoteReceiverImage : UIImage? = nil
    
    private var messages: [Message] = []
    private var messageListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = .secondarySystemGroupedBackground
        setupCollectionView()
        inputStyle()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        messageInputBar.delegate = self
        title = header
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.titleTextAttributes = [.font: UIFont(name: "LexendDeca-Regular", size: 26)!]
        
        
        
        db.collection("chats").document(id).setData([
            "Student": id.components(separatedBy: "-")[0],
            "Tutor": id.components(separatedBy: "-")[1]
        ])
        
        reference = db.collection(["chats", id, "thread"].joined(separator: "/"))
        
        messageListener = reference?.addSnapshotListener { querySnapshot, error in
          guard let snapshot = querySnapshot else {
            print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
            return
          }
          
          snapshot.documentChanges.forEach { change in
            self.handleDocumentChange(change)
          }
        }
    }
    
    deinit {
      messageListener?.remove()
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
    
    private func handleDocumentChange(_ change: DocumentChange) {
        let data = change.document.data()
        
        let color : UIColor = (data["senderID"] as! String == Auth.auth().currentUser!.uid) ? .white : .black
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "LexendDeca-Regular", size: UIFont.labelFontSize)!,
            .foregroundColor: color
        ]
        
        let message = Message(sender: Sender(senderId: data["senderID"] as! String, displayName: data["senderDisplayName"] as! String), messageId: data["messageID"] as! String, sentDate: (data["dateStamp"] as! Timestamp).dateValue(), kind: .attributedText(NSAttributedString(string: data["content"] as! String, attributes: attributes)))

        switch change.type {
            case .added:
                insertNewMessage(message)

            default:
                break
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

extension ChatViewController: MessagesDataSource, MessageCellDelegate {

    public struct Sender: SenderType {
        public let senderId: String

        public let displayName: String
    }
    
    func currentSender() -> SenderType {
        return Sender(senderId: Auth.auth().currentUser?.uid ?? "nil", displayName: Auth.auth().currentUser?.displayName?.components(separatedBy: " ")[0] ?? "nil")
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter
        }()
        
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
    
}

extension ChatViewController: MessagesDisplayDelegate {
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        if message.sender.senderId == currentSender().senderId {
            avatarView.set(avatar: Avatar(image: currentSenderImage, initials: String(message.sender.senderId.prefix(1))))
        }
        
        else {
            avatarView.set(avatar: Avatar(image: remoteReceiverImage, initials: String(message.sender.senderId.prefix(1))))
        }
        
    }
    
    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .black
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .systemPink : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .curved)
    }
    
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print("called HIIII")
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        // 1
          let message = Message(sender: Sender(senderId: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser!.displayName!.components(separatedBy: " ")[0]), messageId: UUID().uuidString, sentDate: Date(), kind: .attributedText(NSAttributedString(string: text)))

        // 2
        save(message)

        // 3
        inputBar.inputTextView.text = ""
    }
}

extension ChatViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
}
