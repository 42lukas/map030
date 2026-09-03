//
//  ControlReportMarkerView.swift
//  map030
//
//  Created by Lukas Karsten on 04.09.26.
//

import SwiftUI

struct ControlReportMarkerView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var isPulsing = false

    let count: Int
    let isSelected: Bool

    var body: some View {
        ZStack {
            pulse
            marker
        }
        .frame(width: 82, height: 72)
        .scaleEffect(isSelected ? 1.12 : 1)
        .animation(
            .easeInOut(duration: 0.18),
            value: isSelected
        )
        .onAppear {
            startPulse()
        }
        .onDisappear {
            isPulsing = false
        }
        .accessibilityLabel(accessibilityText)
    }

    private var marker: some View {
        VStack(spacing: AppSpacing.xs) {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.red.opacity(0.78), .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 46, height: 46)
                .overlay {
                    Image(systemName: ReportCategory.control.systemImage)
                        .font(.system(size: 19, weight: .bold))
                        .foregroundStyle(.white)
                }
                .overlay {
                    Circle()
                        .stroke(Color(.systemBackground), lineWidth: 3)
                }

            Text(markerText)
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .tracking(0.4)
                .foregroundStyle(.white)
                .padding(.horizontal, AppSpacing.sm)
                .padding(.vertical, 3)
                .background(.red)
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(Color(.systemBackground), lineWidth: 1.5)
                }
        }
        .shadow(
            color: .red.opacity(0.3),
            radius: AppRadius.sm,
            y: AppSpacing.xs
        )
    }

    private var pulse: some View {
        Circle()
            .stroke(.red.opacity(0.8), lineWidth: 3)
            .frame(width: 46, height: 46)
            .scaleEffect(
                reduceMotion ? 1.2 : (isPulsing ? 1.7 : 1)
            )
            .opacity(
                reduceMotion ? 0.4 : (isPulsing ? 0 : 0.75)
            )
            .offset(y: -13)
    }

    private func startPulse() {
        guard !reduceMotion else {
            return
        }

        withAnimation(
            .easeOut(duration: 1.4)
                .repeatForever(autoreverses: false)
        ) {
            isPulsing = true
        }
    }

    private var markerText: String {
        count == 1 ? "KONTROLLE" : "\(count) KONTROLLEN"
    }

    private var accessibilityText: String {
        count == 1 ? "Kontrolle" : "\(count) Kontrollen"
    }
}
