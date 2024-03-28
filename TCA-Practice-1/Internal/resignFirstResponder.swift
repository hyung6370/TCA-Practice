//
//  resignFirstResponder.swift
//  TCA-Practice-1
//
//  Created by KIM Hyung Jun on 3/28/24.
//

import SwiftUI

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
