//
//  CreateReportView.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import SwiftUI
import MapKit

struct CreateReportView: View {
    @State private var viewModel: CreateReportViewModel
    
    let onCreate: (Report) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    init(stations: [TransitStation], onCreate: @escaping (Report) -> Void) {
        _viewModel = State(
            initialValue: CreateReportViewModel(
                stations: stations
            )
        )
        self.onCreate = onCreate
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Neue Meldung")
                .font(.title2)
                .fontWeight(.semibold)

            stationSelection

            if viewModel.selectedStation != nil {
                lineSelection
            }

            categorySelection

            Button("Meldung erstellen") {
                createReport()
            }
            .buttonStyle(.borderedProminent)
            .disabled(!viewModel.canCreateReport)
        }
        .padding()
    }
    
    // MARK: - Category Selection
    private var categorySelection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Kategorie")
                .font(.headline)

            ForEach(ReportCategory.allCases, id: \.self) { category in
                Button {
                    viewModel.selectedCategory = category
                } label: {
                    HStack {
                        Text(category.displayName)
                        Spacer()
                        if viewModel.selectedCategory == category {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - Station Selection
    private var stationSelection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Station")
                .font(.headline)

            ForEach(viewModel.stations) { station in
                Button {
                    viewModel.selectStation(station)
                } label: {
                    HStack {
                        Text(station.name)
                        Spacer()
                        if viewModel.selectedStation?.id == station.id {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - Line Selection
    private var lineSelection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Linie")
                    .font(.headline)

                Text("(optional)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(viewModel.availableLines) { line in
                Button {
                    viewModel.selectedLine = line
                } label: {
                    HStack {
                        Text(line.name)
                        Spacer()
                        if viewModel.selectedLine?.id == line.id {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                .buttonStyle(.plain)
            }
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
