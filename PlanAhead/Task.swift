//
//  Task.swift
//  PlanAhead
//
//  Created by Burak Kaya on 22.09.2024.
//

import SwiftData
import SwiftUI
import SwiftData

@Model
class Task: Identifiable {
    var id: UUID
    var title: String
    var caption: String
    var date: Date
    var isCompleted = false
    var tint: String

    init(id: UUID = UUID(), title: String, caption: String, date: Date, isCompleted: Bool = false, tint: String) {
        self.id = id 
        self.title = title
        self.caption = caption
        self.date = date
        self.isCompleted = isCompleted
        self.tint = tint
    }
    
    var tintColor: Color {
        switch tint {
        case "taskColor 1": return .taskColor1
        case "taskColor 2": return .taskColor2
        case "taskColor 3": return .taskColor3
        case "taskColor 4": return .taskColor4
        case "taskColor 5": return .taskColor5
        case "taskColor 6": return .taskColor6
        case "taskColor 7": return .taskColor7
        default: return .black
        }
    }
}

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: Date()) ?? Date()
    }
}
