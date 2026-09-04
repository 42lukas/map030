//
//  CreateReportView.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import CoreLocation
import SwiftUI

struct CreateReportView: View {

    @Environment(LocationManager.self) private var locationManager
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: CreateReportViewModel

    let onCreate: (Report) -> Void

    init(
        transitRepository: any TransitRepository,
        city: TransitCity,
        onCreate: @escaping (Report) -> Void
    ) {
        _viewModel = State(
            initialValue: CreateReportViewModel(
                transitRepository: transitRepository,
                city: city
            )
        )

        self.onCreate = onCreate
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.isLoading {
                    loadingView
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(errorMessage)
                } else {
                    CreateReportProgressView(step: viewModel.step)

                    Divider()

                    stepContent(
                        searchText: $viewModel.searchText,
                        step: viewModel.step
                    )
                }
            }
            .navigationTitle("Meldung erstellen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(
                    placement: .topBarLeading
                ) {
                    if viewModel.canGoBack {
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.goBack()
                            }
                        } label: {
                            Label("Zurück", systemImage: "chevron.left")
                        }
                    }
                }

                ToolbarItem(
                    placement: .topBarTrailing
                ) {
                    Button("Schließen") {
                        dismiss()
                    }
                }
            }
            .task {
                await loadStations()
            }
            .task(id: locationManager.location?.timestamp) {
                updateNearestStation()
            }
        }
    }

    private func stepContent(
        searchText: Binding<String>,
        step: CreateReportStep
    ) -> some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: AppSpacing.xl
            ) {
                switch step {
                case .station:
                    StationSearchSection(
                        searchText: searchText,
                        selectedStation: viewModel.selectedStation,
                        stations: viewModel.filteredStations,
                        onSelect: viewModel.selectStation
                    )

                    if searchText.wrappedValue.isEmpty {
                        if let nearestStation = viewModel.nearestStation {
                            NearbyStationsSection(
                                station: nearestStation,
                                onSelect: viewModel.selectStation
                            )
                        } else {
                            nearbyStationPlaceholder
                        }
                    }

                case .category:
                    selectedStationSummary

                    CategorySelectionSection(
                        selectedCategory: viewModel.selectedCategory,
                        onSelect: viewModel.selectCategory
                    )

                case .review:
                    reportSummary

                    LineSelectionSection(
                        lines: viewModel.availableLines,
                        selectedLine: viewModel.selectedLine,
                        onSelect: viewModel.selectLine,
                        onClear: viewModel.clearSelectedLine
                    )
                }
            }
            .padding(AppSpacing.lg)
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            primaryAction
        }
        .id(step)
        .transition(.opacity.combined(with: .move(edge: .trailing)))
    }

    private var primaryAction: some View {
        Button {
            if viewModel.step == .review {
                createReport()
            } else {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.continueToNextStep()
                }
            }
        } label: {
            Text(viewModel.step.primaryActionTitle)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
        }
        .buttonStyle(.borderedProminent)
        .disabled(!viewModel.canContinue)
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .background(.bar)
    }

    private var selectedStationSummary: some View {
        selectionRow(
            title: "Station",
            value: viewModel.selectedStation?.name ?? "Keine Station",
            systemImage: "tram.fill"
        )
        .background(AppColors.surface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppRadius.lg,
                style: .continuous
            )
        )
    }

    private var nearbyStationPlaceholder: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Label(
                "In deiner Nähe",
                systemImage: "location.fill"
            )
            .font(AppTypography.sectionTitle)

            HStack(spacing: AppSpacing.md) {
                if locationManager.authorizationStatus == .denied
                    || locationManager.authorizationStatus == .restricted
                {
                    Image(systemName: "location.slash.fill")
                        .foregroundStyle(.secondary)

                    Text("Standort nicht verfügbar. Du kannst die Station weiterhin suchen.")
                        .font(AppTypography.secondary)
                        .foregroundStyle(.secondary)
                } else {
                    ProgressView()

                    Text("Nächste Station wird ermittelt …")
                        .font(AppTypography.secondary)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding(AppSpacing.md)
            .background(.thinMaterial)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: AppRadius.lg,
                    style: .continuous
                )
            )
        }
    }

    private var reportSummary: some View {
        VStack(spacing: 0) {
            selectionRow(
                title: "Station",
                value: viewModel.selectedStation?.name ?? "Keine Station",
                systemImage: "tram.fill"
            )

            Divider()
                .padding(.leading, 52)

            selectionRow(
                title: "Meldung",
                value: viewModel.selectedCategory?.displayName ?? "Keine Kategorie",
                systemImage: viewModel.selectedCategory?.systemImage
                    ?? "exclamationmark.circle.fill"
            )
        }
        .background(AppColors.surface)
        .clipShape(
            RoundedRectangle(
                cornerRadius: AppRadius.lg,
                style: .continuous
            )
        )
    }

    private func selectionRow(
        title: String,
        value: String,
        systemImage: String
    ) -> some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: systemImage)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppColors.accent)
                .frame(width: AppSpacing.xxl, height: AppSpacing.xxl)
                .background(AppColors.accent.opacity(0.12))
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: AppRadius.sm,
                        style: .continuous
                    )
                )

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(title)
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(AppTypography.body.weight(.semibold))
            }

            Spacer()
        }
        .padding(AppSpacing.md)
    }

    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()

            Text("Stationen werden geladen …")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }

    private func errorView(
        _ message: String
    ) -> some View {
        ContentUnavailableView {
            Label(
                "Stationen nicht verfügbar",
                systemImage: "exclamationmark.triangle"
            )
        } description: {
            Text(message)
        } actions: {
            Button("Erneut versuchen") {
                Task {
                    await loadStations()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func loadStations() async {
        await viewModel.loadStations()
        locationManager.requestLocationIfNeeded()
        updateNearestStation()
    }

    private func updateNearestStation() {
        if let location = locationManager.location {
            viewModel.updateNearestStation(
                userLocation: location
            )
        }
    }

    private func createReport() {
        guard let report = viewModel.createReport() else {
            return
        }

        onCreate(report)
        dismiss()
    }
}
