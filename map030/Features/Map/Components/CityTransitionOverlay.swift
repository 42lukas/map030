//
//  CityTransitionOverlay.swift
//  map030
//
//  Created by Lukas Karsten on 04.09.26.
//

import SwiftUI

struct CityTransitionOverlay: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let city: TransitCity

    var body: some View {
        ZStack {
            Color(.systemBackground)

            GeometryReader { geometry in
                ZStack {
                    ForEach(routes) { route in
                        MovingTransitLine(
                            route: route,
                            availableSize: geometry.size,
                            reduceMotion: reduceMotion
                        )
                    }
                }
                .clipped()
            }

            loadingCard
        }
        .ignoresSafeArea()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(city.displayName) wird geladen")
    }

    private var loadingCard: some View {
        VStack(spacing: AppSpacing.lg) {
            Image("map030")
                .resizable()
                .interpolation(.high)
                .scaledToFit()
                .frame(width: 88, height: 88)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: AppRadius.lg,
                        style: .continuous
                    )
                )
                .shadow(
                    color: .black.opacity(0.14),
                    radius: 12,
                    y: 6
                )

            VStack(spacing: AppSpacing.xs) {
                Text("Auf nach \(city.displayName)")
                    .font(AppTypography.title)

                Text("Verkehrsnetz wird geladen")
                    .font(AppTypography.secondary)
                    .foregroundStyle(.secondary)
            }

            ProgressView()
                .controlSize(.small)
        }
        .padding(AppSpacing.xl)
        .background(.regularMaterial)
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppRadius.xl,
                style: .continuous
            )
        )
        .overlay {
            RoundedRectangle(
                cornerRadius: AppRadius.xl,
                style: .continuous
            )
            .stroke(.primary.opacity(0.08))
        }
        .shadow(color: .black.opacity(0.12), radius: 24, y: 12)
        .padding(AppSpacing.xl)
    }

    private var routes: [TransitAnimationRoute] {
        [
            TransitAnimationRoute(
                id: 0,
                color: .red,
                verticalPosition: 0.18,
                angle: 10,
                duration: 1.35,
                delay: 0
            ),
            TransitAnimationRoute(
                id: 1,
                color: .blue,
                verticalPosition: 0.38,
                angle: -7,
                duration: 1.55,
                delay: 0.18
            ),
            TransitAnimationRoute(
                id: 2,
                color: .green,
                verticalPosition: 0.64,
                angle: 8,
                duration: 1.45,
                delay: 0.08
            ),
            TransitAnimationRoute(
                id: 3,
                color: .orange,
                verticalPosition: 0.84,
                angle: -11,
                duration: 1.65,
                delay: 0.28
            ),
        ]
    }
}

private struct MovingTransitLine: View {
    let route: TransitAnimationRoute
    let availableSize: CGSize
    let reduceMotion: Bool

    @State private var progress: CGFloat = 0

    var body: some View {
        let trackLength = hypot(
            availableSize.width,
            availableSize.height
        ) * 1.35

        ZStack {
            Capsule()
                .fill(route.color.opacity(0.24))
                .frame(width: trackLength, height: 5)

            Capsule()
                .fill(route.color)
                .frame(width: 44, height: 11)
                .overlay {
                    Capsule()
                        .stroke(.white.opacity(0.9), lineWidth: 2)
                }
                .shadow(color: route.color.opacity(0.35), radius: 6)
                .offset(
                    x: reduceMotion
                        ? 0
                        : -trackLength / 2 + progress * trackLength
                )
        }
        .frame(width: trackLength, height: 24)
        .rotationEffect(.degrees(route.angle))
        .position(
            x: availableSize.width / 2,
            y: availableSize.height * route.verticalPosition
        )
        .onAppear {
            guard !reduceMotion else {
                return
            }

            withAnimation(
                .linear(duration: route.duration)
                    .delay(route.delay)
                    .repeatForever(autoreverses: false)
            ) {
                progress = 1
            }
        }
    }
}

private struct TransitAnimationRoute: Identifiable {
    let id: Int
    let color: Color
    let verticalPosition: CGFloat
    let angle: Double
    let duration: TimeInterval
    let delay: TimeInterval
}
