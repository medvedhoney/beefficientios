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
    
    var users: [String: User]!
    var task: Task!
    var messages: [Chat] = []
    var minimalMessages: [ChatMessage] = []
    var deleted = false
    
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
        let owner = users[message.userId]?.name ?? ""
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
    
    func deleteTask(successHandler: @escaping () -> Void) {
        env.networkManager.deleteTask(taskId: task.id) { [weak self] (success, error) in
            if let error = error {
                self?.error = error
            } else if let success = success, success {
                self?.deleted = true
                successHandler()
            }
        }
    }
    
    func switchTaskStatus(status: String) {
        env.networkManager.switchTaskStatus(taskId: task.id, status: status) { [weak self] (task, error) in
            if let error = error {
                self?.error = error
            } else if let task = task {
                self?.configure(task: task)
            }
        }
    }
}

