//
//  ChatViewController.swift
//  swiftTestChat
//
//  Created by Alan Valdez on 9/20/16.
//  Copyright © 2016 ITESM. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    let databaseRef = FIRDatabase.database().reference(fromURL: "https://swift-chat-test-ab7a4.firebaseio.com")
    
    var messageRef : FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupBubbles()
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        //Name the object inside the database
        messageRef = databaseRef.child("sentMessages")
        
        // messages from someone else
        addMessage(id: "foo", text: "Hey person!")
        // messages sent from local sender
        addMessage(id: senderId, text: "Yo!")
        addMessage(id: senderId, text: "I like turtles!")
        
        observeMessages()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.white
        } else {
            cell.textView!.textColor = UIColor.black
        }
        
        return cell
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let itemRef = messageRef.childByAutoId()
        let messageItem = [
            "text": text!,
            "senderId": senderId!
        ]
        
        itemRef.setValue(messageItem)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
    }
    
    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        
        outgoingBubbleImageView = factory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        
        incomingBubbleImageView = factory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: "", text: text)
        
        messages.append(message!)
    }
    
    private func observeMessages() {
        let messagesQuery = messageRef.queryLimited(toLast: 25)
        
        messagesQuery.observe(.childAdded) { (snapshot: FIRDataSnapshot!) in
            
            if let data = snapshot.value as? [String : String] {
                
                print(data)
                
                let id = data["senderId"]! as String
                let text = data["text"]! as String
                
                self.addMessage(id: id, text: text)
            }
            
            self.finishReceivingMessage()
        }
    }
}
