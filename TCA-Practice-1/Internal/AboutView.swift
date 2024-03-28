//
//  AboutView.swift
//  TCA-Practice-1
//
//  Created by KIM Hyung Jun on 3/6/24.
//

import SwiftUI

struct AboutView: View {
  let readMe: String

  var body: some View {
    DisclosureGroup("About this case study") {
        Text(self.readMe)
    }
  }
}
