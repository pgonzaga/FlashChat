//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    var messages : [Message] = [Message]()
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextfield.delegate = self
        messageTableView.register(
            UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell"
        )

        configureTableView()
        
        
        
        //TODO: Set yourself as the delegate of the text field here:

        
        
        //TODO: Set the tapGesture here:
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(tableViewTapped)
        )

        messageTableView.addGestureRecognizer(tapGesture)
        self.retrieveMessages()
        
        

        //TODO: Register your MessageCell.xib file here:

        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "customMessageCell", for: indexPath
        ) as! CustomMessageCell

        cell.messageBody.text = messages[indexPath.row].body
        cell.senderUsername.text = messages[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    //TODO: Declare tableViewTapped here:

    @objc func tableViewTapped() {
        messageTextfield.endEditing(true)
    }
    
    
    
    //TODO: Declare configureTableView here:

    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:

    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    //TODO: Declare textFieldDidEndEditing here:

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false

        let messageDB = Database.database().reference().child("messages")
        let newMessage: [String : String] = [
            "sender": (Auth.auth().currentUser?.email)!,
            "body": messageTextfield.text!
        ]

        messageDB.childByAutoId().setValue(newMessage) {
            (error, message) in

            if error != nil {
                print("error")
            } else {
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
    }

    func retrieveMessages() {
        let messagesDB = Database.database().reference().child("messages")

        messagesDB.observe(.childAdded) { (snapshot) in
            let snapshotValue: [String : String] = snapshot.value as! Dictionary<String, String>
            let newMessage: Message = Message(
                senderParam: snapshotValue["sender"]!, bodyParam: snapshotValue["body"]!
            )

            self.messages.append(newMessage)
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }

    @IBAction func logOutPressed(_ sender: AnyObject) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error on sign out")
        }

    }
    


}
