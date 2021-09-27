//
//  LGDateTool.swift
//  Integraler
//
//  Created by 刘盖 on 2020/5/22.
//  Copyright © 2020 刘盖. All rights reserved.
//

import UIKit

extension Date{
    
    public enum LGDateOfStringMode:String{
        case yyyy = "yyyy"
        case yyyy_MM = "yyyy-MM"
        case MM = "MM"
        case dd = "dd"
        case MM_dd = "MM-dd"
        case HH_mm = "HH:mm"
        case HH_mm_ss = "HH:mm:ss"
        case MM_dd_HH_mm_ss = "MM_dd HH:mm:ss"
        case yyyyMMdd = "yyyyMMdd"
        case yyyy_MM_dd = "yyyy-MM-dd"
        case yyyy_MM_dd_HH_mm = "yyyy-MM-dd HH:mm"
        case yyyy_MM_dd_HH_mm_ss = "yyyy-MM-dd HH:mm:ss"
    }
    
    public func stringWithMode(_ mode:LGDateOfStringMode = .yyyy_MM_dd) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = mode.rawValue
        return dateformat.string(from: self)
    }
    
    public func stringWithCustomMode(_ mode:String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = mode
        return dateformat.string(from: self)
    }
    
    public static func dateFrom(string: String, mode:LGDateOfStringMode) -> Date?{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = mode.rawValue
        return dateFormat.date(from: string)
    }
    
    public static func dateFromTimestamp(_ timestamp:String) -> Date? {
        guard let timeStampTemp = TimeInterval(timestamp) else{
            return nil
        }
        let date = Date(timeIntervalSince1970: timeStampTemp)
        return date
    }
    
    public static func stringOfDateFromeTimeStamp(_ timestamp:String, mode:LGDateOfStringMode = .yyyy_MM_dd) -> String? {
        guard let date = self.dateFromTimestamp(timestamp) else{
            return nil
        }
        return date.stringWithMode(mode)
    }
    
    public func isSameDay(anotherDate:Date) -> Bool {
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        let component = gregorian.dateComponents(Set<Calendar.Component>([.year,.month,.day]), from: self)
        let componentAnother = gregorian.dateComponents(Set<Calendar.Component>([.year,.month,.day]), from: anotherDate)
        return component.year == componentAnother.year && component.month == componentAnother.month && component.day == componentAnother.day
    }
    
    // MARK: - 根据传入的时间，对比当前时间，返回时间样式(当天返回：HH:mm,7天以内返回：几天前，超过7天返回：具体年月日)
    public static func stringShowFromDate(date:Date) -> String {
        
        let dateNow = Date()
        
        
        // 是否七天之内
        let timeGap = dateNow.timeIntervalSince(date)
        
        if timeGap<=60{
            return "刚刚"
        }
        else if timeGap<=60*60{
            return String(Int(timeGap)%60)+"分钟以前"
        }
        else if timeGap <= 24*60*60{
            return String(Int(timeGap)%(60*60))+"小时以前"
        }
        else if timeGap <= 7*24*60*60{
            return String(Int(timeGap)%(24*60*60))+"天前"
        }
        else{
            let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
            let componentNow = gregorian.dateComponents(Set<Calendar.Component>([.year,.month,.day]), from: dateNow)
            let component = gregorian.dateComponents(Set<Calendar.Component>([.year,.month,.day]), from: date)
            if component.year == componentNow.year{
                return date.stringWithMode(.MM_dd)
            }
            else{
                return date.stringWithMode(.yyyy_MM_dd)
            }
        }
    }
    
    public static func stringShowFromDateString(dateString:String,mode:LGDateOfStringMode) -> String {
        
        let date = self.dateFrom(string: dateString, mode: mode) ?? Date()
        return self.stringShowFromDate(date: date)
    }
    
    // MARK: - 系统运行时间
    
}
