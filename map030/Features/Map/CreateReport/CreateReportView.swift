//
//  CreateReportView.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import SwiftUI
import CoreLocation

struct CreateReportView: View {

    @State private var viewModel: CreateReportViewModel

    let onCreate: (Report) -> Void
    let userLocation: CLLocation?

    @Environment(\.dismiss) private var dismiss

    init(
        transitRepository: any TransitRepository,
        userLocation: CLLocation?,
        onCreate: @escaping (Report) -> Void
    ) {
        _viewModel = State(
            initialValue: CreateReportViewModel(
                transitRepository: transitRepository
            )
        )

        self.userLocation = userLocation
        self.onCreate = onCreate
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            Group {
                if viewModel.isLoading {
                    loadingView
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(errorMessage)
                } else {
                    content(
                        searchText: $viewModel.searchText
                    )
                }
            }
            .navigationTitle("Neue Meldung")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(
                    placement: .topBarTrailing
                ) {
                    Button("Schließen") {
                        dismiss()
                    }
                }
            }
            .task {
                await viewModel.loadStations()
                if let userLocation {
                    viewModel.updateNearbyStations(
                        userLocation: userLocation
                    )
                }
            }
        }
    }

    private func content(
        searchText: Binding<String>
    ) -> some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 24
            ) {
                if !viewModel.nearbyStations.isEmpty {
                    NearbyStationsSection(
                        stations: viewModel.nearbyStations,
                        onSelect: viewModel.selectStation
                    )
                }
                
                StationSearchSection(
                    searchText: searchText,
                    selectedStation: viewModel.selectedStation,
                    stations: viewModel.filteredStations,
                    onSelect: viewModel.selectStation
                )

                if viewModel.selectedStation != nil {
                    LineSelectionSection(
                        lines: viewModel.availableLines,
                        selectedLine: viewModel.selectedLine,
                        onSelect: viewModel.selectLine
                    )
                }

                CategorySelectionSection(
                    selectedCategory: viewModel.selectedCategory
                ) { category in
                    viewModel.selectedCategory = category
                }

                createButton
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private var createButton: some View {
        Button {
            createReport()
        } label: {
            Text("Meldung erstellen")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
        }
        .buttonStyle(.borderedProminent)
        .disabled(!viewModel.canCreateReport)
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
        ContentUnavailableView(
            "Stationen nicht verfügbar",
            systemImage: "exclamationmark.triangle",
            description: Text(message)
        )
    }

    private func createReport() {
        guard let report = viewModel.createReport() else {
            return
        }

        onCreate(report)
        dismiss()
    }
}
