import Foundation

let red = "\u{001B}[0;31m"
let green = "\u{001B}[0;32m"
let yellow = "\u{001B}[0;33m"
let blue = "\u{001B}[0;34m"
let reset = "\u{001B}[0;0m"

func currentOSName() -> String {
    #if os(macOS)
        return "macOS"
    #elseif os(iOS)
        return "iOS"
    #elseif os(Linux)
        return "Linux"
    #elseif os(Windows)
        return "Windows"
    #else
        return "Unknown OS"
    #endif
}


func extractJSON(from text: String) -> [String: String]? {
    // Match the first JSON object in the text
    let pattern = #"\{[^}]*\}"#
    
    guard let range = text.range(of: pattern, options: .regularExpression) else {
        return nil
    }
    
    let jsonSubstring = text[range]
    let jsonString = String(jsonSubstring)
    
    guard let data = jsonString.data(using: .utf8) else { return nil }
    
    do {
        let result = try JSONDecoder().decode([String: String].self, from: data)
        return result
    } catch {
        print("JSON decode error: \(error)")
        return nil
    }
}
