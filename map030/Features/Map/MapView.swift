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
    @State private var isCreateReportPresented = false
    
    var body: some View {
        @Bindable var viewModel = viewModel
        Map(position: $viewModel.cameraPosition) {
            UserAnnotation()
            
            ForEach(viewModel.reports) { report in
                Annotation(
                    report.category.displayName,
                    coordinate: report.station.coordinate
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
                VStack(spacing: 12) {
                    Button {
                        isCreateReportPresented = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }

                    RecenterButton(
                        action: {
                            withAnimation(.easeInOut) {
                                viewModel.recenter()
                            }
                        },
                        systemName: viewModel.isUserFocused
                            ? "location.fill"
                            : "location"
                    )
                }
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
            .sheet(isPresented: $isCreateReportPresented) {
                CreateReportView(
                    stations: MockTransitData.stations
                ) { report in
                    viewModel.addReport(report)
                }
                .presentationDetents([.medium, .large])
            }
    }
}

#Preview {
    MapView()
        .environment(LocationManager())
}
