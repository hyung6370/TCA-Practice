//
//  BindingForm.swift
//  TCA-Practice-1
//
//  Created by KIM Hyung Jun on 3/28/24.
//

import SwiftUI
import ComposableArchitecture

private let readMe = """
  This file demonstrates how to handle two-way bindings in the Composable Architecture using \
  bindable actions and binding reducers.

  Bindable actions allow you to safely eliminate the boilerplate caused by needing to have a \
  unique action for every UI control. Instead, all UI bindings can be consolidated into a single \
  `binding` action, which the `BindingReducer` can automatically apply to state.

  It is instructive to compare this case study to the "Binding Basics" case study.
  """

@Reducer
struct BindingForm {
    @ObservableState // 프로퍼티 래퍼를 사용해 관찰 가능하게 선언
    struct State: Equatable {
        var sliderValue = 5.0
        var stepCount = 10
        var text = ""
        var toggleIsOn = false // 토글 스위치 상태
    }
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case resetButtonTapped  // 폼을 초기 상태로 리셋
    }
    var body: some Reducer<State, Action> { // 리듀서는 액션에 따라 상태를 어떻게 변경할지 정의한다.
        BindingReducer() // 자동으로 바인딩 액션을 상태에 적용
        Reduce { state, action in
            switch action {
            case .binding(\.stepCount):
                state.sliderValue = .minimum(state.sliderValue, Double(state.stepCount))
                return .none
                
            case .binding:
                return .none
                
            case .resetButtonTapped:
                state = State()
                return .none
            }
        }
    }
}

struct BindingFormView: View {
    @Bindable var store: StoreOf<BindingForm>
    
    var body: some View {
        Form {
            Section {
                AboutView(readMe: readMe)
            }
            
            HStack {
                TextField("Type here", text: $store.text)
                    .disableAutocorrection(true)
                    .foregroundStyle(store.toggleIsOn ? Color.secondary : .primary)
                Text(alternate(store.text))
            }
            .disabled(store.toggleIsOn)
            
            Toggle("Disable other controls", isOn: $store.toggleIsOn.resignFirstResponder())
            
            Stepper(
                "Max slider value: \(store.stepCount)",
                value: $store.stepCount,
                in: 0...100
            )
            .disabled(store.toggleIsOn)
            
            HStack {
                Text("Slider value: \(Int(store.sliderValue))")
                
                Slider(value: $store.sliderValue, in: 0...Double(store.stepCount))
                    .tint(.accentColor)
            }
            .disabled(store.toggleIsOn)
            
            Button("Reset") {
                store.send(.resetButtonTapped)
            }
            .tint(.red)
        }
        .monospacedDigit()
        .navigationTitle("Bindings form")
    }
}

// 텍스트필드에 입력된 텍스트를 교대로 대소문자로 변환하여 보여준다
private func alternate(_ string: String) -> String {
    string
        .enumerated()
        .map { idx, char in
            idx.isMultiple(of: 2)
            ? char.uppercased()
            : char.lowercased()
        }
        .joined()
}

#Preview {
    NavigationStack {
        BindingFormView(
            store: Store(initialState: BindingForm.State()) {
                BindingForm()
            }
        )
    }
}
