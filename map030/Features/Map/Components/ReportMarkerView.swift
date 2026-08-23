//
//  ReportMarkerView.swift
//  map030
//
//  Created by Lukas Karsten on 22.08.26.
//

import SwiftUI

struct ReportMarkerView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var isPulsing = false

    let report: Report
    let isSelected: Bool

    var body: some View {
        ZStack {
            if report.category == .control {
                controlPulse
            }

            marker
        }
        .frame(width: 68, height: 58)
        .scaleEffect(isSelected ? 1.12 : 1)
        .animation(
            .easeInOut(duration: 0.18),
            value: isSelected
        )
        .onAppear {
            startPulseIfNeeded()
        }
        .onDisappear {
            isPulsing = false
        }
    }

    private var marker: some View {
        VStack(spacing: -6) {
            RoundedRectangle(
                cornerRadius: AppRadius.md,
                style: .continuous
            )
            .fill(
                LinearGradient(
                    colors: [
                        report.category.tintColor.opacity(0.82),
                        report.category.tintColor
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 42, height: 42)
            .overlay {
                Image(systemName: report.category.systemImage)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(report.category.symbolColor)
            }
            .overlay {
                RoundedRectangle(
                    cornerRadius: AppRadius.md,
                    style: .continuous
                )
                .stroke(
                    Color(.systemBackground),
                    lineWidth: 2
                )
            }

            RoundedRectangle(cornerRadius: 2)
                .fill(report.category.tintColor)
                .frame(width: 10, height: 10)
                .rotationEffect(.degrees(45))
        }
        .shadow(
            color: .black.opacity(0.22),
            radius: 5,
            y: 3
        )
    }

    private var controlPulse: some View {
        Circle()
            .stroke(
                report.category.tintColor.opacity(0.7),
                lineWidth: 3
            )
            .frame(width: 44, height: 44)
            .scaleEffect(
                reduceMotion ? 1.18 : (isPulsing ? 1.65 : 1)
            )
            .opacity(
                reduceMotion ? 0.45 : (isPulsing ? 0 : 0.7)
            )
            .offset(y: -3)
    }

    private func startPulseIfNeeded() {
        guard
            report.category == .control,
            !reduceMotion
        else {
            return
        }

        withAnimation(
            .easeOut(duration: 1.5)
                .repeatForever(autoreverses: false)
        ) {
            isPulsing = true
        }
    }
}
