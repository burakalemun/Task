//
//  ContentView.swift
//  PlanAhead
//
//  Created by Burak Kaya on 22.09.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentDate: Date = .init()
    
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    
    @State private var previousWeekIndex: Int = 0
    
    @Namespace private var animation
        
    @State private var createNewTask: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading) {
                // Header
                Text("Takvim")
                    .font(.system(size: 36, weight: .semibold))
                
                Text(currentDate.format("YYYY"))
                
                // Slider
                TabView(selection: $currentWeekIndex) {
                    ForEach(weekSlider.indices, id: \.self) { index in
                        let week = weekSlider[index]
                        weekView(week)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 90)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                Rectangle().fill(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .ignoresSafeArea()
            }
            .onChange(of: currentWeekIndex) { newValue in
                if newValue == 0 || newValue == (weekSlider.count - 1) {
                    createWeek = true
                }
                previousWeekIndex = newValue
            }
            
            
            ScrollView(.vertical) {
                VStack {
                    //Task View
                    TaskView(date: $currentDate)
                    
                }
                .hSpacing(.center)
                .vSpacing(.center)
            }
            .scrollIndicators(.hidden)
            
        }
        .vSpacing(.top)
        .frame(maxWidth: .infinity)
        .onAppear() {
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()
                
                if let firstDate = currentWeek.first?.date {
                    weekSlider.append(firstDate.createPreviousWeek())
                }
                
                weekSlider.append(currentWeek)
                
                if let lastDate = currentWeek.first?.date {
                    weekSlider.append(lastDate.createNextWeek())
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            //New Task
            Button(action: {
                createNewTask.toggle()
            }, label: {
                Image(systemName: "plus")
                    .imageScale(.large)
                    .padding(24)
                    .background(.black)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .padding(.horizontal)
                    .foregroundColor(.white)
            })
            .fullScreenCover(isPresented: $createNewTask, content: {
                NewTask()
                    .modelContainer(for: Task.self)
            })
        }
    }
    
    @ViewBuilder
    func weekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack {
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                        .modifier(ConditionalTextScale())
                    
                    Text(day.date.format("dd"))
                        .font(.system(size: 20))
                        .frame(width: 50, height: 55)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .black)
                        .background {
                            if isSameDate(day.date, currentDate) {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.black)
                                    .offset(y: 3)
                                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                            }
                            
                            if day.date.isToday {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                            }
                        }
                }
                .hSpacing(.center)
                .onTapGesture {
                    withAnimation(.snappy) {
                        currentDate = day.date
                    }
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self, perform: { value in
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                    })
            }
        }
    }
    
    func paginateWeek() {
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
    }
}


struct ConditionalTextScale: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.textScale(.secondary)
        } else {
            content
        }
    }
}

#Preview {
    ContentView()
}
