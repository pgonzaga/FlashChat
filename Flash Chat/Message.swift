//
//  Message.swift
//  Flash Chat
//
//  This is the model class that represents the blueprint for a message

class Message {
    var sender: String = ""
    var body: String = ""

    init(senderParam: String, bodyParam: String) {
        sender = senderParam
        body = bodyParam
    }
}
