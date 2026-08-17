//
//  MapView.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Environment(LocationManager.self) private var locationManager
    
    @State private var viewModel = MapViewModel()
    
    var body: some View {
        @Bindable var viewModel = viewModel
        Map(position: $viewModel.cameraPosition) {
            UserAnnotation()
            
            ForEach(viewModel.reports) { report in
                Annotation(
                    report.category.displayName,
                    coordinate: report.coordinate
                ) {
                    Button {
                        viewModel.selectReport(report)
                    } label: {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                    }
                    .buttonStyle(.plain)
                }
            }
        }.ignoresSafeArea()
            .overlay(alignment: .bottomTrailing) {
                RecenterButton(action: {
                    withAnimation(.easeInOut) {
                        viewModel.recenter()
                    }
                }, systemName: viewModel.isUserFocused ? "location.fill" : "location")
                .padding()
            }
            .task {
                locationManager.requestLocationIfNeeded()
            }
            .sheet(
                item: Binding(
                    get: { viewModel.selectedReport },
                    set: { newValue in
                        if newValue == nil {
                            viewModel.clearSelection()
                        }
                    }
                )
            ) { report in
                ReportDetailView(report: report)
                    .presentationDetents([.medium])
            }
    }
}

#Preview {
    MapView()
        .environment(LocationManager())
}
