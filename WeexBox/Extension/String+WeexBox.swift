//
//  String+WeexBox.swift
//  WeexBox
//
//  Created by Mario on 2018/8/28.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import Alamofire

public extension String {
    
    func encodeURIComponent() -> String {
        return URLEncoding.default.escape(self)
    }
    
    func decodeURIComponent() -> String {
        return self.removingPercentEncoding!
    }
    
    func queryToParameters() -> [String: String] {
        var parametersCombined = [String: [String]]()
        let pairs = self.components(separatedBy: "&")
        for pair in pairs {
            let keyValue = pair.components(separatedBy: "=")
            if(keyValue.count > 1) {
                let key = keyValue[0].decodeURIComponent()
                let value = keyValue[1].decodeURIComponent()
                if parametersCombined[key] != nil {
                    parametersCombined[key]!.append(value)
                } else {
                    parametersCombined[key] = [value]
                }
            }
        }
        var results = [String: String]()
        for parameterCombined in parametersCombined {
            let key = parameterCombined.key
            let values = parameterCombined.value
            let sortedValues = values.sorted()
            var valueString = sortedValues[0]
            for index in 1..<sortedValues.count {
                valueString += key + sortedValues[index]
            }
            results[key] = valueString
        }
        return results
    }
    
    func getParameters() -> [String: String] {
        let query = self.getQuery()
        if query != nil {
            return query!.queryToParameters()
        }
        return [String: String]()
    }
    
    func getQuery() -> String? {
        let range = self.range(of: "?")
        if range != nil {
            let query = String(self[range!.upperBound...])
            if query.isEmpty == false {
                return query
            }
        }
        return nil
    }
    
    func wb_compare(with version: String) -> ComparisonResult {
        return compare(version, options: .numeric, range: nil, locale: nil)
    }
    
    func isNewer(than aVersionString: String) -> Bool {
        return wb_compare(with: aVersionString) == .orderedDescending
    }
    
    func isOlder(than aVersionString: String) -> Bool {
        return wb_compare(with: aVersionString) == .orderedAscending
    }
    
    func isSame(to aVersionString: String) -> Bool {
        return wb_compare(with: aVersionString) == .orderedSame
    }
    
    func isNotOlder(than aVersionString: String) -> Bool {
        return isSame(to: aVersionString) || isNewer(than: aVersionString)
    }
    
    func isNotNewer(than aVersionString: String) -> Bool {
        return isSame(to: aVersionString) || isOlder(than: aVersionString)
    }
}
