//
//  MyCalendar.swift
//  Aqua Guard
//
//  Created by Malek Labidi on 28/11/2023.
//

import SwiftUI
import FSCalendar

extension Participation: Equatable {
    static func == (lhs: Participation, rhs: Participation) -> Bool {
        return lhs._id == rhs._id
    }
}



struct MyCalendar: View {
    @State private var selectedDate = Date()
    @State private var participations: [Participation] = []

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
                    Text("Events")
                        .foregroundColor(.black)
                                            .font(.headline)
                    if let selectedEvent = selectedEvent(for: selectedDate) {
                        Text(selectedEvent.Eventname)
                            .foregroundColor(.white)
                            .font(.headline)
                            .background(Color.black)  // Add a background color
                    } else {
                        Text("No event selected")
                            .foregroundColor(.white)
                            .font(.headline)
                            .background(Color.black)  // Add a background color
                    }

                    
                    Spacer()
                }
            }
           
        } .navigationBarTitle("My Calendar")
            .onAppear {
                Task {
                    let viewModel = ParticipationViewModel()
                    await viewModel.getAllParticipations()
                    participations = viewModel.participations
                   
                }
            }

    }
    
    private func getFormattedMonthAndYear(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    private func selectedEvent(for date: Date) -> Participation? {
          return participations.first { Calendar.current.isDate($0.DateEvent, inSameDayAs: date) }
      }
}

struct CalendarView: UIViewRepresentable {
    typealias UIViewType = FSCalendar
    
    @Binding var selectedDate: Date
    @Binding var participations: [Participation]

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
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
            var calendarWithTimeZone = Calendar.current
            calendarWithTimeZone.timeZone = TimeZone(secondsFromGMT: 0) ?? TimeZone.current 
            print("Calendar Date: \(date)")

            let count = parent.participations.filter { (event: Participation) -> Bool in
                let isInSameDay = calendarWithTimeZone.isDate(event.DateEvent, inSameDayAs: date)
                print("Event: \(event.Eventname), Date: \(event.DateEvent), isInSameDay: \(isInSameDay)")
                return isInSameDay
            }.count
            return count
        }

        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
            // Set the color for the event markers
            let events = parent.participations.filter { (event: Participation) -> Bool in
                return Calendar.current.isDate(date, inSameDayAs: event.DateEvent)
            }
            if !events.isEmpty {
                return [UIColor.systemBlue]
            } else {
                return nil
            }
        }
    }

}
/*
struct MyCalendar_Previews: PreviewProvider {
    static var previews: some View {
        MyCalendar()
    }
}*/
