//
//  TimeRangeSlider.swift
//
//  Created by Samuel Ojogbo & Hilal Habashi on 5/28/15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

class TimeRangeSlider: RangeSlider {
    //    let startDateComp = NSDateComponents()
    //    lazy var timeShift: Double = self.timeToDouble()
    var totalMinutes: Int = 24*60
    var timeIncrements: Int = 30
    var minDate: NSDate?
    var maxDate: NSDate?
    override init(frame: CGRect){
        super.init(frame: frame)
        minDate = NSDate().shiftedDate(timeIncrements)
        maxDate =  minDate!.tomorrowDate()
        self.lowerValue = (Double(totalMinutes)*0.118)
        self.minimumValue = 0
        self.maximumValue = Double(totalMinutes)
        self.upperValue = (Double(totalMinutes)*0.882)
        
        //        self.upperValue = 29.0
        println(self.lowerValue)
        println(self.upperValue)
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    func timeDates() -> (startDate: NSDate, endDate: NSDate ){
        let startDate = minDate!.shiftByMins(Int(self.lowerValue)).shiftedDate(timeIncrements)
        let endDate = minDate!.shiftByMins(Int(self.upperValue)).shiftedDate(timeIncrements)
        return (startDate, endDate)
    }
    
    
}
extension Int {
    func toString() -> String {
        return String(format: "%d",self)
    }
}
extension Double {
    func toString() -> String {
        return String(format: "%.0f",self)
    }
}
extension NSDate
{
    func shiftedDate(minInterval: Int) -> NSDate{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitYear | .CalendarUnitHour | .CalendarUnitMinute, fromDate: self)
        var tempMinutes = 0
        while (components.minute - minInterval > -minInterval){
            components.minute = components.minute-minInterval
            tempMinutes += minInterval
        }
        if (tempMinutes + minInterval > 60){
            components.hour++
            tempMinutes=0
        }
        
        components.minute = tempMinutes
        
        return calendar.dateFromComponents(components)!
    }
    func isToday() -> Bool{
        let currentDate = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let currComp = calendar.components(.CalendarUnitDay, fromDate: currentDate)
        let selfComp = calendar.components(.CalendarUnitDay, fromDate: self)
        return (selfComp.day == currComp.day)
        
    }
    
    func shiftByMins(minsToAdd: Int) -> NSDate{
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.minute=minsToAdd
        return calendar.dateByAddingComponents(components, toDate: self, options: nil)!
    }
    
    func tomorrowDate() -> NSDate{
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        
        components.day=1
        return calendar.dateByAddingComponents(components, toDate: self, options: nil)!
    }
    
    func hour() -> Int
    {
        //Get Hour
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour, fromDate: self)
        let hour = components.hour
        
        //Return Hour
        return hour
    }
    
    
    func minute() -> Int
    {
        //Get Minute
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitMinute, fromDate: self)
        let minute = components.minute
        
        //Return Minute
        return minute
    }
    
    func toShortTimeString() -> String
    {
        let locale = NSLocale.currentLocale()
        var formatter = NSDateFormatter()
        var localDateFormat = NSDateFormatter.dateFormatFromTemplate("j", options: 0, locale: locale)!
        if localDateFormat.rangeOfString("a") != nil {
            formatter.dateFormat = "h:mma"
        }
        else{
            formatter.dateFormat = "HH:mm"
        }
        //Get Short Time String
        let timeString = formatter.stringFromDate(self)
        
        //Return Short Time String
        return timeString
    }
}