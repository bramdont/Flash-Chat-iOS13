//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    
    var messages: [Message] = [
        Message(sender: "1@1.com", body: "Hey there!"),
        Message(sender: "a@a.com", body: "Hello!"),
        Message(sender: "1@1.com", body: "What's up?")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {
        //addSnapshotListener method is use to listen for changes in the database and retieve it instantly.
        //For more information, see the firebase documentation.
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener
            { (querySnapshot, error) in
                if let e = error {
                    print("Something went wrong while retrieving your data. Error details: \(e.localizedDescription)")
                } else {
                    self.messages.removeAll()
                    if let document = querySnapshot?.documents {
                        for doc in document {
                            let data = doc.data()
                            if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String{
                                let newMessage = Message(sender: messageSender, body: messageBody)
                                self.messages.append(newMessage)
                                
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            //Automatically scroll to the button of the tableView every time a new message is send
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        }
                    }
                }
            }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        //Using firestore to save messages
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(
                data: [
                    K.FStore.senderField: messageSender,
                    K.FStore.bodyField: messageBody,
                    K.FStore.dateField: Date().timeIntervalSince1970
                ])
            { (error) in
                if let e = error{
                    print("There was an error trying to save your data. Error details: \(e)")
                } else {
                    print("Your data has been saved successfully.")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
            
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            //This code take us strigth to the entry screen of the app
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        //CHECK WHETHER THE MESSAGE IS FROM THE SAME LOGGED IN USER OR FROM ANOTHER USER.
        //Check if the message if from the current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.rightImageView.isHidden = false
            cell.leftImageView.isHidden = true
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
            cell.messageCell.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
        }
        //Check if the messasge is from another user
        else {
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
            cell.messageCell.backgroundColor = UIColor(named: K.BrandColors.purple)
        }
        
        return cell
    }
    
    
}
