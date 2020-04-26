//
//  CalendarView.swift
//  TestCalendar
//
//  Created by Andy Qua on 26/04/2020.
//  Copyright © 2020 Andy Qua. All rights reserved.
//

import SwiftUI




struct CalendarView: View {
    @Binding var startDate : Date
    @Binding var endDate : Date
    @State private var selected =  [Int: String]()
    
    private let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        
    var body: some View {
        let days = Date.daysBetween( startDate, endDate )
        return HStack {
            
            VStack {
                ForEach( 0..<7, id: \.self ) { d in
                    Text( "\(self.days[d])" )
                        .padding( 5 )
                        . frame(width: 50, height: 25, alignment: .leading)
                        .padding(EdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 0))
                    
                }
            }
            ScrollView(.horizontal, content: {
                HStack {
                    
                    ForEach( Array(stride(from:0, to:days, by:7) ), id: \.self ) { w in
                        VStack {
                            Text( self.getMonthTextForWeek( offset:w ) )
                            
                            ForEach( w..<w+7, id: \.self ) { d in
                                Button( action: {
                                    self.select( offset:d )
                                }) {
                                    Text( "\(self.getDateOffset( self.startDate, d))" )
                                        .font(Font.caption)
                                        .foregroundColor(Color.white)
                                        . frame(width: 30, height: 30, alignment: .topLeading)
                                }
                                .background(self.getColorForButton(offset:d))
                                .cornerRadius(3)
                                .padding(EdgeInsets(top: 2, leading: 1, bottom: 2, trailing: 1))
                            }
                        }
                    }
                }
            })
        }
    }
}

extension CalendarView {
    func getMonthTextForWeek( offset : Int ) -> String {
        var text = " "
        let start = getDateOffset( self.startDate, offset)
        let end = getDateOffset( self.startDate, offset+6)
        if  start == 1 || start > end {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLL"
            
            let enddt = Calendar.current.date(byAdding: .day, value: offset+6, to: self.startDate)!
            
            text = dateFormatter.string(from: enddt)
        }
        
        return text
    }
    
    func getColorForButton( offset: Int ) -> Color {
        switch  selected[offset] {
            case "M":
                return .red
            case "R":
                return .blue
            default:
                return .gray
        }
    }
    
    func select( offset: Int ) {
        if selected[offset] == "M" {
            selected[offset] = "R"
        } else if selected[offset] == "R" {
            selected.removeValue(forKey: offset)
        } else {
            selected[offset] = "M"
        }
    }
    
    func getDateOffset( _ date : Date, _ offset : Int) -> Int {
        let new = Calendar.current.date(byAdding: .day, value: offset, to: date)!
        return Calendar.current.dateComponents([.day], from: new).day ?? 0
    }
    
    
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(startDate: .constant(Date(2020,4,1)), endDate: .constant(Date(2020,12,31)))
    }
}

