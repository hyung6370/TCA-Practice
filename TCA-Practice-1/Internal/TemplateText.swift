//
//  TemplateText.swift
//  TCA-Practice-1
//
//  Created by KIM Hyung Jun on 3/29/24.
//

import SwiftUI

// Text 뷰를 확장하여 복잡한 스타일을 적용할 수 있는 기능을 추가한다.
// 텍스트 내에서 특정문자를 사용하여 강조, 이텔릭, 코드 스타일 등을 적용할 수 있게 한다.
// 이는 마크다운과 유사한 형태로, 텍스트 스타일을 선언적으로 정의할 수 있게 한다.
extension Text {
    init(template: String, _ style: Font.TextStyle = .body) {
        enum Style: Hashable {
            case code
            case emphasis
            case strong
        }
        
        var segments: [Text] = []
        var currentValue = ""
        var currentStyles: Set<Style> = []
        
        func flushSegment() {
            var text = Text(currentValue)
            if currentStyles.contains(.code) {
                text = text.font(.system(style, design: .monospaced))
            }
            if currentStyles.contains(.emphasis) {
                text = text.italic()
            }
            if currentStyles.contains(.strong) {
                text = text.bold()
            }
            segments.append(text)
            currentValue.removeAll()
        }
        
        for character in template {
            switch character {
            case "*":
                flushSegment()
                currentStyles.toggle(.strong)
            case "_":
                flushSegment()
                currentStyles.toggle(.emphasis)
            case "`":
                flushSegment()
                currentStyles.toggle(.code)
            default:
                currentValue.append(character)
            }
        }
        flushSegment()
        
        self = segments.reduce(Text(verbatim: ""), +)
    }
}

extension Set {
    fileprivate mutating func toggle(_ element: Element) {
        if self.contains(element) {
            self.remove(element)
        }
        else {
            self.insert(element)
        }
    }
}
