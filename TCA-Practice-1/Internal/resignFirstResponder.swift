//
//  resignFirstResponder.swift
//  TCA-Practice-1
//
//  Created by KIM Hyung Jun on 3/28/24.
//

import SwiftUI

// Binding 타입에 대한 확장으로, 주로 키보드를 숨기는데 사용된다.
// 사용자가 UI 컨트롤에서 입력을 완료했을 때 키보드를 숨기기 위해 사용된다.
// 이 메서드는 UIApplication의 sendAction 메서드를 호출하여 resignFirstResponder 액션을
// 전역적으로 보냄으로써 현재 응답자(responder)에서 포커스를 제거한다.
extension Binding {
    @MainActor
    func resignFirstResponder() -> Self {
        Self(
            get: { self.wrappedValue },
            set: { newValue, transaction in
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
                )
                self.transaction(transaction).wrappedValue = newValue
            }
        )
    }
}
