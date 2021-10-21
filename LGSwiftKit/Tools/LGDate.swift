//
//  LGDateTool.swift
//  Integraler
//
//  Created by 刘盖 on 2020/5/22.
//  Copyright © 2020 刘盖. All rights reserved.
//

import UIKit

//MARK: - 定义常用字符串格式
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

//MARK: -
extension Date{
    
    //MARK: 返回指定格式的时间字符串
    public func stringWithMode(_ mode: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = mode
        return dateformat.string(from: self)
    }
    
    //MARK: 通过指定格式的时间字符串生成时间
    public static func dateFrom(string: String, mode:String) -> Date?{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = mode
        return dateFormat.date(from: string)
    }
    
    //MARK: 通过时间戳字符串生成时间
    public static func dateFromTimestamp(_ timestamp:String) -> Date? {
        guard let timeStampTemp = TimeInterval(timestamp) else{
            return nil
        }
        let date = Date(timeIntervalSince1970: timeStampTemp)
        return date
    }
    
    //MARK: 通过时间戳字符串生成指定格式的时间字符串
    public static func stringOfDateFromeTimeStamp(_ timestamp:String, mode: String) -> String? {
        guard let date = self.dateFromTimestamp(timestamp) else{
            return nil
        }
        return date.stringWithMode(mode)
    }
    
    //MARK: 比较两个日期是否为同一天
    public func isSameDay(anotherDate:Date) -> Bool {
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
        let component = gregorian.dateComponents(Set<Calendar.Component>([.year,.month,.day]), from: self)
        let componentAnother = gregorian.dateComponents(Set<Calendar.Component>([.year,.month,.day]), from: anotherDate)
        return component.year == componentAnother.year && component.month == componentAnother.month && component.day == componentAnother.day
    }
    
    // MARK:  根据传入的时间，对比当前时间，返回时间样式(当天返回：HH:mm,7天以内返回：几天前，超过7天返回：具体年月日)
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
                return date.stringWithMode(LGDateOfStringMode.MM_dd.rawValue)
            }
            else{
                return date.stringWithMode(LGDateOfStringMode.yyyy_MM_dd.rawValue)
            }
        }
    }
    
    //MARK: 将一个时间字符串转化为另一个格式的时间字符串
    public static func stringShowFromDateString(dateString: String,mode: String) -> String {
        
        let date = self.dateFrom(string: dateString, mode: mode) ?? Date()
        return self.stringShowFromDate(date: date)
    }
    
}
