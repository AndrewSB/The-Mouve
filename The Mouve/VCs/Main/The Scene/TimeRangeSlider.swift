//
//  TimeRangeSlider.swift
//
//  Created by Samuel Ojogbo & Hilal Habashi on 5/28/15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit

class TimeRangeSlider: RangeSlider {
    lazy var timeShift: Double = self.timeToDouble()
    var timeDuration: Double = 24.0
    var timeIncrements: Int = 30
    
    override init(frame: CGRect){
        super.init(frame: frame)

        self.lowerValue = 0//timeShift + 8
        self.maximumValue = timeShift + timeDuration
        self.minimumValue = floor(timeShift)
        self.upperValue = 8//self.lowerValue + 18 - 8


        println(self.lowerValue)
        println(self.upperValue)
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    func timeValues() -> (startVal:String, endVal:String){
        var startTimeString: String  = wholeDayTimeConverter(self.lowerValue)
        var endTimeString: String = wholeDayTimeConverter(self.upperValue)
        return(startTimeString, endTimeString)
    }
    func timeToDouble() -> Double{
        var doubleTime:Double = 0.0
        var currentTime = NSDate()
        doubleTime+=Double(currentTime.hour())
        doubleTime+=Double(currentTime.minute())/60.0
        return doubleTime
    }
    func wholeDayTimeConverter(sliderValue: Double) -> String{
        var processedInterval = intervalsAndShits(sliderValue)
        var processedTime = amPMOrNah(sliderValue)
        return processedTime.flatHour+processedInterval+processedTime.suffix
        }
        func amPMOrNah(timeValue: Double) -> (flatHour: String, suffix: String){
            let locale = NSLocale.currentLocale()
            let dateFormat = NSDateFormatter.dateFormatFromTemplate("j", options: 0, locale: locale)!
            var flatHour = ""
            var timeString = ""
            var rawTimeOnScale = Double(timeValue)
            // AM-PM Support
            if dateFormat.rangeOfString("a") != nil {
                while ((rawTimeOnScale/12.0) >= (13.0/12.0)){
                    rawTimeOnScale-=12.0
                }
                if((Int(timeValue)%24) >= 12){
                    timeString+="PM"
                }
                else{
                    timeString+="AM"
                }
            }
            //      Military Time Support
            else {
                if(rawTimeOnScale >= 24.0){
                    rawTimeOnScale-=24
                }
            }
            
            // To indicate the next day (Not been decided yet)
            if(timeValue > 24.0){
                //timeString+="(ND)"
            }
            flatHour = Int(rawTimeOnScale).toString()
            return (flatHour, timeString)
        }
    func intervalsAndShits(timeValue: Double) -> String{
        //Half-Hour Intervals
        var rawTimeOnScale = timeValue
        var flatHour = Int(rawTimeOnScale)
        var timeString = ""
        var incTime = 0
        var timeDelta = (rawTimeOnScale-Double(flatHour))
        let propOfInc = Double(timeIncrements)/(60.0)
        while(timeDelta >= propOfInc){
            timeDelta-=propOfInc
            incTime++
        }
        if(incTime*timeIncrements > 0){
            timeString=":"+(incTime*timeIncrements).toString()
        }
        else{
            
            timeString=":00"
        }
            //Detect whether next today or today

            //        Output Final String
            return timeString
        }



    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

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
        //Get Short Time String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.stringFromDate(self)
        
        //Return Short Time String
        return timeString
    }
}