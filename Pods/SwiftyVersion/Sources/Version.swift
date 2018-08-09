//
//  Version.swift
//  Version
//
//  Created by David Cordero on 23/09/14.
//  Copyright (c) 2014 David Cordero. All rights reserved.
//

import Foundation


public class Version: Equatable, CustomStringConvertible {
    let components: [String]
    
    public convenience init (_ version: String) {
        self.init(version, usingSeparator: ".")
    }
    
    public init (_ version: String, usingSeparator separator: String) {
        components = version.components(separatedBy: separator)
    }
    
    public var description: String {
        return components.joined(separator: ".")
    }
    
    fileprivate func compare(_ otherVersion: Version) -> ComparisonResult {
        
        let length = max(self.components.count, otherVersion.components.count)
        for index in 0..<length {
            let itemVersion: String = (self.components.count > index) ? self.components[index] : "0"
            let otherItemVersion: String = (otherVersion.components.count > index) ?otherVersion.components[index] : "0"
            
            let resultCompare = itemVersion.compare(otherItemVersion)
            if (resultCompare != .orderedSame) {
                return resultCompare
            }
        }
        return .orderedSame
    }
}

public func == (left: Version, right: Version) -> Bool {
    return (left.compare(right) == .orderedSame)
}

public func < (left: Version, right: Version) -> Bool {
    return (left.compare(right) == .orderedAscending)
}

public func > (left: Version, right: Version) -> Bool {
    return (left.compare(right) == .orderedDescending)
}

public func <= (left: Version, right: Version) -> Bool {
    return !(left > right)
}

public func >= (left: Version, right: Version) -> Bool {
    return !(left < right)
}
