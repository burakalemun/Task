//
//  OffsetKey.swift
//  PlanAhead
//
//  Created by Burak Kaya on 22.09.2024.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
} 
