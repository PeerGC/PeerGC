//
//  ChatViewController.swift
//  PeerGC
//
//  Created by Artemas Radik on 7/2/20.
//  Copyright © 2020 AJ Radik. All rights reserved.
//

// MARK: Imports
import Foundation
import UIKit
import MessageKit
import Firebase
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    // MARK: Message Structure
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
        
        var representation: [String: Any] {
          
            var text: NSAttributedString
            
            switch kind {
            case .attributedText(let attributedText):
                text = attributedText
            default:
                return [:]
            }
            
            let toReturn: [String: Any] = [
                DatabaseKey.Sender_ID.name: sender.senderId,
                DatabaseKey.Sender_Display_Name.name: sender.displayName,
                DatabaseKey.Message_ID.name: messageId,
                DatabaseKey.Date_Stamp.name: sentDate,
                DatabaseKey.Content.name: text.string
            ]
          
          return toReturn
        }
    }
    
    // MARK: Sender Structure
    public struct Sender: SenderType {
        public let senderId: String

        public let displayName: String
    }
    
    // MARK: Variables
    private let database = Firestore.firestore()
    private var reference: CollectionReference?
    
    var identifier: String = ""
    var header: String = ""
    
    var currentSenderImage: UIImage?
    var remoteReceiverImage: UIImage?
    
    var customCell: CustomCell?
    
    private var messages: [Message] = []
    private var messageListener: ListenerRegistration?
    
    let fontName = "LexendDeca-Regular"
    
    // MARK: View Did Load
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
        self.navigationController!.navigationBar.titleTextAttributes = [.font: UIFont(name: fontName, size: 26)!]
        
        database.collection("chats").document(identifier).setData([
            "Student": identifier.components(separatedBy: "-")[0],
            "Tutor": identifier.components(separatedBy: "-")[1]
        ])
        
        reference = database.collection(["chats", identifier, "thread"].joined(separator: "/"))
        
        messageListener = reference?.addSnapshotListener { querySnapshot, error in
          guard let snapshot = querySnapshot else {
            print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
            return
          }
          
            if snapshot.isEmpty {
                self.firstMessageVC()
            }
            
          snapshot.documentChanges.forEach { change in
            self.handleDocumentChange(change)
          }
        }
        
    }
    
    func firstMessageVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "FirstMessageVC") as? FirstMessageVC else {
            Utilities.logError(customMessage: "Casting Error.", customCode: 4)
            return
        }
        viewController.modalPresentationStyle = .popover
        viewController.customCell = customCell
        viewController.chatVC = self
        present(viewController, animated: true, completion: nil)
    }
    
    deinit {
      messageListener?.remove()
    }
    
    // MARK: View Customization
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    private func setupCollectionView() {
        guard let flowLayout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout else {
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
    
    // MARK: Message Operations
    func newMessage(message: String) {
        let message = Message(sender: Sender(senderId: Auth.auth().currentUser!.uid,
                        displayName: Auth.auth().currentUser!.displayName!.components(separatedBy: " ")[0]),
                        messageId: UUID().uuidString, sentDate: Date(), kind: .attributedText(NSAttributedString(string: message)))
        
        saveMessageToDatabase(message)
    }
    
    private func saveMessageToDatabase(_ message: Message) {
      reference?.addDocument(data: message.representation) { error in
        if let error = error {
            Crashlytics.crashlytics().record(error: error)
            Utilities.logError(customMessage: "An error occured with Firebase.", customCode: 3)
        }
        
        guard let body = message.representation[DatabaseKey.Content.name] as? String else {
            Utilities.logError(customMessage: "Casting Error.", customCode: 4)
            return
        }
        
        if let remoteInstanceID = self.customCell?.data?[DatabaseKey.Token.name] {
            Utilities.sendPushNotification(to: remoteInstanceID,
                title: Auth.auth().currentUser!.displayName!.components(separatedBy: [" "])[0],
                body: body)
        }
        
        self.messagesCollectionView.scrollToBottom()
      }
    }
    
    private func insertNewMessageToCollectionView(_ message: Message) {
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
        
        guard let color: UIColor = (data[DatabaseKey.Sender_ID.name] as? String == Auth.auth().currentUser!.uid) ? .white : .black else {
            Utilities.logError(customMessage: "Casting Error.", customCode: 4)
            return
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: fontName, size: UIFont.labelFontSize)!,
            .foregroundColor: color
        ]
        
        guard let senderID = data[DatabaseKey.Sender_ID.name] as? String else {
            Utilities.logError(customMessage: "Casting Error.", customCode: 4)
            return
        }
        
        guard let senderDisplayName = data[DatabaseKey.Sender_Display_Name.name] as? String else {
            Utilities.logError(customMessage: "Casting Error.", customCode: 4)
            return
        }
        
        guard let messageID = data[DatabaseKey.Message_ID.name] as? String else {
            Utilities.logError(customMessage: "Casting Error.", customCode: 4)
            return
        }
        
        guard let dateStamp = (data[DatabaseKey.Date_Stamp.name] as? Timestamp)?.dateValue() else {
            Utilities.logError(customMessage: "Casting Error.", customCode: 4)
            return
        }
        
        guard let content = data[DatabaseKey.Content.name] as? String else {
            Utilities.logError(customMessage: "Casting Error.", customCode: 4)
            return
        }
        
        let message = Message(sender: Sender(senderId: senderID,
                                             displayName: senderDisplayName),
                                             messageId: messageID,
                                             sentDate: dateStamp,
                                             kind: .attributedText(NSAttributedString(string: content, attributes: attributes)))

        switch change.type {
        case .added:
            insertNewMessageToCollectionView(message)

        default:
            break
        }
        
    }
}

// MARK: Messages Data Source
extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return Sender(senderId: Auth.auth().currentUser?.uid ?? "nil",
                      displayName: Auth.auth().currentUser?.displayName?.components(separatedBy: " ")[0] ?? "nil")
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                                      attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                                                   NSAttributedString.Key.foregroundColor: UIColor.darkGray])
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

// MARK: Messages Display Delegate
extension ChatViewController: MessagesDisplayDelegate {
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        if message.sender.senderId == currentSender().senderId {
            avatarView.set(avatar: Avatar(image: currentSenderImage, initials: String(message.sender.senderId.prefix(1))))
        } else {
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

// MARK: Input Bar Delegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        newMessage(message: text)

        // 3
        inputBar.inputTextView.text = ""
    }
}

// MARK: Messages Layout Delegate
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

// MARK: Message Cell Delegate
extension ChatViewController: MessageCellDelegate {
    
}
