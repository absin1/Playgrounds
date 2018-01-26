//: Playground - noun: a place where people can play

import UIKit

extension Collection where Element == String {
    
    func longestCommonPrefix() -> String {
        guard var prefix = first else { return "" }
        for string in dropFirst() {
            while !string.hasPrefix(prefix) {
                prefix.removeLast()
            }
        }
        return prefix
    }
    
    func longestCommonSuffix() -> String {
        guard var suffix = first else { return "" }
        for string in dropFirst() {
            while !string.hasSuffix(suffix) {
                suffix.removeFirst()
            }
        }
        return suffix
    }
    
}

print(["A12[1]", "A13[1]", "A14[1]"].longestCommonPrefix()) // "A1"
print(["A12[1]", "A13[1]", "A14[1]"].longestCommonSuffix()) // "[1]"
print(["9-b", "10-b", "11-b"].longestCommonPrefix())        // ""
print(["9-b", "10-b", "11-b"].longestCommonSuffix())        // "-b"
print(["A12", "A14", "A6"].longestCommonPrefix())           // "A"
print(["A12", "A14", "A6"].longestCommonSuffix())           // ""


