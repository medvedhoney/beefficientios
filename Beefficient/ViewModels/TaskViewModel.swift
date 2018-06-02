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
    
    var task: Task!
    var messages: [Chat] = []
    var minimalMessages: [ChatMessage] = []
    
    let timeWork = TimeWork()
    
    func configure(task: Task) {
        self.task = task
        self.messages = task.chat
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
    
    func postMessage(message: String) {
        env.networkManager.postChatMessage(message: message, taskId: task.id) { [weak self] (task, error) in
            if let task = task {
                self?.configure(task: task)
            } else if let error = error {
                self?.error = error
            }
        }
    }
}

