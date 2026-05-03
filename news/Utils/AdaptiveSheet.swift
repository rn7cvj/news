//
//  AdaptiveSheet.swift
//  news
//
//  Created by Codex on 03.05.2026.
//

import SwiftUI

extension View {
    func adaptiveSheet<Content: View>(
        isPresent: Binding<Bool>,
        @ViewBuilder sheetContent: () -> Content
    ) -> some View {
        modifier(AdaptiveSheetModifier(isPresented: isPresent, sheetContent))
    }
}

struct AdaptiveSheetModifier<SheetContent: View>: ViewModifier {

    @Binding var isPresented: Bool
    @State private var subHeight: CGFloat = 0
    var sheetContent: SheetContent

    init(isPresented: Binding<Bool>, @ViewBuilder _ content: () -> SheetContent) {
        _isPresented = isPresented
        sheetContent = content()
    }

    func body(content: Content) -> some View {
        content
            .background(
                sheetContent
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .task(id: proxy.size.height) {
                                    let newHeight = proxy.size.height
                                    if abs(subHeight - newHeight) > 0.5 {
                                        subHeight = newHeight
                                    }
                                }
                        }
                    )
                    .hidden()
            )
            .sheet(isPresented: $isPresented) {
                sheetContent
                    .presentationDetents([.height(max(subHeight, 1))])
            }
    }
}
