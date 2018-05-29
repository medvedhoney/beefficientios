//
//  TaskViewModel.swift
//  Beefficient
//
//  Created by Eugen on 28/05/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

@objcMembers class TaskViewModel: NSObject {
    let env = Environment.shared
    
    dynamic var success = false
    dynamic var error: String?
    
    var messages: [Chat] = []
    var minimalMessages: [ChatMessage] = []
    
    let timeWork = TimeWork()
    
    func configure(messages: [Chat]) {
        self.messages = messages
        self.minimalMessages = messages.map({ minimizeChat(message: $0) })
        success = true
    }
    
    func minimizeChat(message: Chat) -> ChatMessage {
        let description = message.message
        let date = timeWork.dateFromString(message.time)
        let time = timeWork.timeFromDate(date)
        let owner = "Owner"
        let type: MessageType = env.user?.id == message.userId ? .own : .reply
        return ChatMessage(owner: owner, message: description, time: time, type: type)
    }
}

