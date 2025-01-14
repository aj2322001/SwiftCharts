//
//  ContentView.swift
//  SwiftCharts
//
//  Created by Archit Joshi on 14/01/25.
//

import SwiftUI
import Charts

struct ContentView: View {
    @State private var rawSelectedDate: Date?
    
    var selectedViewMonth: ViewMonth? {
        guard let rawSelectedDate = rawSelectedDate else {return nil}
        return self.viewMonths.first {
            let isSameMonth: Bool = Calendar.current.isDate(
                rawSelectedDate,
                equalTo: $0.date,
                toGranularity: .month
            )
            let isSameYear: Bool = Calendar.current.isDate(
                rawSelectedDate,
                equalTo: $0.date,
                toGranularity: .year
            )
            return isSameMonth && isSameYear
        }
    }
    
    private let viewMonths: [ViewMonth] = [
        ViewMonth(date: .from(year: 2025, month: 1, day: 1), viewCount: 55000),
        ViewMonth(date: .from(year: 2025, month: 2, day: 1), viewCount: 89000),
        ViewMonth(date: .from(year: 2025, month: 3, day: 1), viewCount: 64000),
        ViewMonth(date: .from(year: 2025, month: 4, day: 1), viewCount: 79000),
        ViewMonth(date: .from(year: 2025, month: 5, day: 1), viewCount: 130000),
        ViewMonth(date: .from(year: 2025, month: 6, day: 1), viewCount: 90000),
        ViewMonth(date: .from(year: 2025, month: 7, day: 1), viewCount: 88000),
        ViewMonth(date: .from(year: 2025, month: 8, day: 1), viewCount: 64000),
        ViewMonth(date: .from(year: 2025, month: 9, day: 1), viewCount: 74000),
        ViewMonth(date: .from(year: 2025, month: 10, day: 1), viewCount: 99000),
        ViewMonth(date: .from(year: 2025, month: 11, day: 1), viewCount: 110000),
        ViewMonth(date: .from(year: 2025, month: 12, day: 1), viewCount: 94000),
    ]
    private let viewCountGoal: Int = 80000
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Youtube Views")
                .font(.headline)
            
            Text("Total: \(self.viewMonths.reduce(0, {$0 + $1.viewCount}))")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .padding(.bottom, 16)
            
            Chart {
                RuleMark(y: .value("Goal", viewCountGoal))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundStyle(.blue)
//                    .annotation(alignment: .leading) {
//                        Text("Goal")
//                            .font(.caption)
//                            .foregroundStyle(.secondary)
//                    }
                
                ForEach(self.viewMonths) { viewMonth in
                    BarMark(
                        x: .value("Month", viewMonth.date, unit: .month),
                        y: .value("Views", viewMonth.viewCount)
                    )
                    .foregroundStyle(Color.pink.gradient)
                    .cornerRadius(4)
                    .opacity((self.rawSelectedDate == nil || viewMonth.date == self.selectedViewMonth?.date) ? 1.0 : 0.3)
                }
            }
            .frame(height: 180)
//            .chartPlotStyle { plotContent in
//                plotContent
//                    .background(.black.gradient.opacity(0.3))
//                    .border(.brown, width: 3)
//            }
            .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
            .chartXAxis {
                AxisMarks(values: self.viewMonths.map({$0.date})) { date in
//                    AxisGridLine()
//                    AxisTick()
                    AxisValueLabel(format: .dateTime.month(.narrow),centered: true)
                }
            }
            .chartYAxis {
                AxisMarks{ mark in
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
            
            HStack {
                Text("----")
                    .foregroundStyle(.blue)
                Text("Monthly Goal")
                    .foregroundStyle(.secondary)
            }
            .font(.caption2)
            .padding(.leading, 4)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

struct ViewMonth: Identifiable {
    let id = UUID()
    let date: Date
    let viewCount: Int
}

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components) ?? Date()
    }
}
