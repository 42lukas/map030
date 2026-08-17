//
//  CreateReportView.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import SwiftUI
import MapKit

struct CreateReportView: View {

    @State
    private var viewModel = CreateReportViewModel()

    let coordinate: CLLocationCoordinate2D
    let onCreate: (Report) -> Void

    @Environment(\.dismiss)
    private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Neue Meldung")
                .font(.title2)
                .fontWeight(.semibold)

            categorySelection

            Button("Meldung erstellen") {
                createReport()
            }
            .buttonStyle(.borderedProminent)
            .disabled(!viewModel.canCreateReport)
        }
        .padding()
    }

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

    private func createReport() {
        guard let report = viewModel.createReport(
            at: coordinate
        ) else {
            return
        }

        onCreate(report)
        dismiss()
    }
}
