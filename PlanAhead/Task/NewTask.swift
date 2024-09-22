//
//  NewTask.swift
//  PlanAhead
//
//  Created by Burak Kaya on 22.09.2024.
//

import SwiftUI
import SwiftData

struct NewTask: View {
    
    @Environment(\.dismiss) var dissmiss
    @State private var taskTitle: String = ""
    @State private var taskCaption: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskColor: String = "taskColor 1"
     
    @Environment(\.modelContext) private var context
    
    var body: some View {
        VStack(alignment: .leading, content: {
            VStack(alignment: .leading, content: {
                Label("Anasayfa", systemImage: "arrow.left")
                    .onTapGesture {
                        dissmiss()
                    }
                
            })
            .hSpacing(.leading)
            .padding(30)
            .frame(maxWidth: .infinity)
            .background {
                Rectangle().fill(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .ignoresSafeArea()
            }
            .hSpacing(.leading)
            
            
            //Task Title
            VStack(alignment: .leading, spacing: 30, content: {
                VStack(spacing: 20, content: {
                    TextField("Başlık Ekle", text: $taskTitle)
                    Divider()
                })
                
                VStack(spacing: 20, content: {
                    TextField("İçerik Ekle", text: $taskCaption)
                    Divider()
                })
                
                VStack(alignment: .leading, spacing: 20, content: {
                    Text("Zaman Seç")
                        .font(.title3)
                    
                    DatePicker("", selection: $taskDate)
                        .datePickerStyle(.compact)
                })
                
                VStack(alignment: .leading, spacing: 20, content: {
                    Text("Renk Belirle")
                        .font(.title3)
                    
                    let colors: [String] = (1...7).compactMap { index -> String in
                        return "taskColor \(index)"
                    }
                    
                    HStack(spacing: 10, content: {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(Color(color).opacity(0.4))
                                .background {
                                    Circle().stroke(lineWidth: 2)
                                        .opacity(taskColor == color ? 1 : 0)
                                }
                                .hSpacing(.center)
                                .onTapGesture {
                                    withAnimation(.snappy) {
                                        taskColor = color
                                    }
                                }
                        }
                    })
                })
                
                
            })
            .padding(30)
            .vSpacing(.top)
            Button {
                let task = Task(title: taskTitle, caption: taskCaption, date: taskDate, tint: taskColor)
                do {
                    context.insert(task)
                    try context.save()
                    DispatchQueue.main.async {
                                dissmiss()
                            }
                }
                catch {
                    print(error.localizedDescription)
                }
                
            } label: {
                Text("Görev Oluştur")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .frame(height: 60)
                    .foregroundColor(.white)
                    .background(.black)
                    .clipShape(.rect(cornerRadius: 20))
                    .padding(.horizontal, 30)
            }
            
        })
        .vSpacing(.top)
    }
}

#Preview {
    NewTask()
}
