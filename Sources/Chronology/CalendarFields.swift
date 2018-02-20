//
//  CalendarFields.swift
//  Chronology
//
//  Created by Dave DeLong on 2/19/18.
//

import Foundation

public protocol Anchored: CalendarValue {
    var range: ClosedRange<Instant> { get }
}

extension Anchored {
    
    public var range: ClosedRange<Instant> {
        let date = calendar.date(from: dateComponents).unwrap("Anchored values must always be convertible to a concrete NSDate")
        let unit = type(of: self).smalledRepresentedComponent
        
        var start = Date()
        var length: TimeInterval = 0
        let succeeded = calendar.dateInterval(of: unit, start: &start, interval: &length, for: date)
        require(succeeded, "We should always be able to get the range of a calendar component")
        
        let startInsant = Instant(date: start)
        let endInstant = Instant(date: start.addingTimeInterval(length))
        return startInsant...endInstant
    }
    
    internal var approximateMidPoint: Instant {
        let r = self.range
        let lower = r.lowerBound
        let upper = r.upperBound.converting(to: lower.epoch)
        let duration = upper.intervalSinceEpoch - lower.intervalSinceEpoch
        let midPoint = lower + (duration / 2.0)
        return max(lower, midPoint)
    }
}

/// A marker protocol for generic constraints.
/// A value that is not Anchored is Floating.
public protocol Floating: CalendarValue { }

public protocol CalendarValueField { }

public protocol EraField: CalendarValueField {
    var eraValue: Int { get }
}

public protocol YearField: CalendarValueField {
    var yearValue: Int { get }
}

public protocol MonthField: CalendarValueField {
    var monthValue: Int { get }
}

public protocol DayField: CalendarValueField {
    var dayValue: Int { get }
}

public protocol HourField: CalendarValueField {
    var hourValue: Int { get }
}

public protocol MinuteField: CalendarValueField {
    var minuteValue: Int { get }
}

public protocol SecondField: CalendarValueField {
    var secondValue: Int { get }
}

public protocol NanosecondField: CalendarValueField {
    var nanosecondValue: Int { get }
}