//
//  common.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 07/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import Foundation

func parseArrayOfStrings(_ res: NSDictionary, for key: String) -> [String]? {
    if let tmp = res[key] as? [String] {
        return tmp
    }
    return nil
}

func parseString(_ res: NSDictionary, for key: String) -> String {
    if let tmp = res[key] as? String {
        return tmp
    }
    return ""
}

func parseDouble(_ res: NSDictionary, key: String) -> Double {
    var out: String
    if let tmp = res[key] as? Double {
        return tmp
    }
    if let tmp = res[key] as? String {
        out = tmp
    } else {
        out = "0"
    }
    return out.toDouble
}

func parseInt(_ res: NSDictionary, key: String) -> Int {
    var out: Int
    if let tmp = res[key] as? Int {
        out = tmp
    }
    else if let tmp = res[key] as? String {
        out = tmp.toInt
    }
    else {
        out = 0
    }
    return out
}

func parseBool(_ res: NSDictionary, key: String) -> Bool {
    let out: Bool
    if let tmp = res[key] as? Bool {
        out = tmp
    }
    else if let tmp = res[key] as? String {
        if tmp.contains("true") {
            out = true
        } else {
            out = false
        }
    }
    else {
        out = false
    }
    return out
}

func convertDate(df: DateFormatter, date: String) -> NSDate {
    if let ddate = df.date(from: date) {
        return ddate as NSDate
    } else {
        return NSDate()
    }
}

func parseDate(_ d: NSDictionary, key: String, df: DateFormatter) -> NSDate {
    let sdate = parseString(d, for: key)
    return convertDate(df: df, date: sdate) as NSDate
}

func dateFormatterForParse() -> DateFormatter {
    let df = DateFormatter()
    df.locale = Locale(identifier: "en_US_POSIX")
    df.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
    return df
}
