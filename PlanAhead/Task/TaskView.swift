//
//  TaskView.swift
//  PlanAhead
//
//  Created by Burak Kaya on 22.09.2024.
//

import SwiftUI
import SwiftData

struct TaskView: View {
    
    @Binding var date: Date
    
    @Query private var tasks: [Task]
    init(date: Binding<Date>) {
        self._date = date
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date.wrappedValue)
        let endOfDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        let predicate = #Predicate<Task> {
            return $0.date >= startDate && $0.date < endOfDate
        }
        
        let shortDescriptor = [
            SortDescriptor(\Task.date, order: .reverse)
        ]
        self._tasks = Query(filter: predicate, sort: shortDescriptor, animation: .snappy)
    }
    
    var body: some View {
        VStack(alignment: .leading, content: {
            ForEach(tasks) { task in
                TaskItem(task: task)
                    .background(alignment: .leading) {
                        if tasks.last?.id != task.id {
                            Rectangle()
                                .frame(width: 1)
                                .offset(x: 24, y: 2)
                        }
                    }
            }
        })
        .padding(.top)
        .overlay {
            if tasks.isEmpty {
                Text("Hiçbir Görev Yok!")
                    .font(.caption)
                    .frame(width: 150)
            }
        }
    }
}

#Preview {
    ContentView()
}
