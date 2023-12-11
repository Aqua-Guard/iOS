//
//  MyCalendar.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 28/11/2023.
//

import SwiftUI
import FSCalendar

struct MyCalendar: View {
    @State private var selectedDate = Date()
    @State private var participations: [Participation] = ParticipationViewModel().participations

    var body: some View {
        NavigationView {
            ZStack {
                // Background image
                Image("background_splash_screen")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Button(action: {
                            // Action for going to the previous month
                            selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text(getFormattedMonthAndYear(from: selectedDate))
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        Spacer()
                        
                        Button(action: {
                            // Action for going to the next month
                            selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    
                    CalendarView(selectedDate: $selectedDate, participations: $participations)
                        .frame(height: 300)
                        .padding()
                    
                    Spacer()
                }
            }
           
        } .navigationBarTitle("My Calendar")
            .onAppear {
                Task{
                    
                   await ParticipationViewModel().getAllParticipations()
                }
               
            }
    }
    
    private func getFormattedMonthAndYear(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
}

struct CalendarView: UIViewRepresentable {
    typealias UIViewType = FSCalendar
    
    @Binding var selectedDate: Date
    @Binding var participations: [Participation]

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {
        uiView.setCurrentPage(selectedDate, animated: true)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarView

        init(parent: CalendarView) {
            self.parent = parent
        }

        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            // Check if there are participations for the given date
            let count = parent.participations.filter { (event: Participation) -> Bool in
                return Calendar.current.isDate(event.dateEvent, inSameDayAs: date)
            }.count
            return count
        }

        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
            // Set the color for the event markers
            let events = parent.participations.filter { (event: Participation) -> Bool in
                return Calendar.current.isDate(date, inSameDayAs: event.dateEvent)
            }
            if events.isEmpty {
                return nil
            } else {
                return [UIColor.systemBlue]
            }
        }


    }
}

struct MyCalendar_Previews: PreviewProvider {
    static var previews: some View {
        MyCalendar()
    }
}
