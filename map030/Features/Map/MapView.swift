//
//  MapView.swift
//  map030
//
//  Created by Lukas Karsten on 17.08.26.
//

import SwiftUI
import MapKit
import TransitOverlayKit
import BerlinTransitNetwork

struct MapView: View {
    @Environment(LocationManager.self) private var locationManager

    @State private var viewModel = MapViewModel()

    let transitRepository: any TransitRepository
    var body: some View {
        @Bindable var viewModel = viewModel
        TransitMap(
            position: $viewModel.cameraPosition,
            network: BerlinNetwork()
        ) {
            UserAnnotation()

            ForEach(viewModel.reportClusters) { cluster in
                Annotation(
                    cluster.title,
                    coordinate: cluster.coordinate
                ) {
                    clusterContent(cluster)
                        .scaleEffect(
                            viewModel.zoomLevel.markerScale,
                            anchor: .bottom
                        )
                        .animation(
                            .easeInOut(duration: 0.2),
                            value: viewModel.zoomLevel
                        )
                }
            }
        }
        .transitModes([.suburbanRail, .subway, .tram])
        .transitStations(.automatic)
        .onMapCameraChange(frequency: .continuous) { context in
            viewModel.limitZoomOut(camera: context.camera)
        }
        .onMapCameraChange(frequency: .onEnd) { context in
            viewModel.updateZoomLevel(
                longitudeDelta: context.region.span.longitudeDelta
            )
        }
        .mapStyle(.standard)
        .ignoresSafeArea()
        .overlay(alignment: .bottomTrailing) {
            VStack(spacing: 12) {
                MapActionButton(
                    systemName: "plus",
                    action: { viewModel.presentCreateReport() }
                )

                MapActionButton(
                    systemName: viewModel.isUserFocused ? "location.fill" : "location",
                    action: {
                        withAnimation(.easeInOut) {
                            viewModel.recenter()
                        }
                    }
                )
            }
            .padding()
        }
        .overlay(alignment: .bottomLeading) {
            ReportSummaryOverlay(
                summaries: viewModel.reportSummaries,
                onSelect: viewModel.presentReportSummary
            )
            .safeAreaPadding(.bottom, AppSpacing.md)
            .padding(.leading, AppSpacing.lg)
        }
        .task {
            locationManager.requestLocationIfNeeded()
        }
        .task {
            await viewModel.monitorExpiredReports()
        }
        .sheet(
            item: Binding(
                get: { viewModel.activeSheet },
                set: { newValue in
                    if newValue == nil {
                        viewModel.dismissSheet()
                    }
                }
            )
        ) { sheet in
            switch sheet {
            case .report(let report):
                ReportDetailView(report: report)
                    .presentationDetents([.medium])

            case .cluster(let cluster):
                ReportClusterDetailView(
                    cluster: cluster
                ) { report in
                    viewModel.selectReport(report)
                }
                .presentationDetents([.medium, .large])

            case .reportSummary:
                ReportSummaryDetailView(
                    summaries: viewModel.reportSummaries
                ) { report in
                    viewModel.selectReport(report)
                }
                .presentationDetents([.medium, .large])

            case .createReport:
                CreateReportView(
                    transitRepository: transitRepository,
                    userLocation: locationManager.location
                ) { report in
                    viewModel.addReport(report)
                    viewModel.dismissSheet()
                }
                .presentationDetents([.medium, .large])
            }
        }
    }
    @ViewBuilder
    private func clusterContent(
        _ cluster: StationReportCluster
    ) -> some View {
        switch viewModel.zoomLevel {
        case .detail:
            if let report = cluster.singleReport {
                Button {
                    viewModel.selectReport(report)
                } label: {
                    ReportMarkerView(
                        report: report,
                        isSelected: viewModel.selectedReportID == report.id
                    )
                }
                .buttonStyle(.plain)

            } else if cluster.canSpiderfy {
                ExpandedReportClusterView(
                    cluster: cluster,
                    selectedReportID: viewModel.selectedReportID
                ) { report in
                    viewModel.selectReport(report)
                }

            } else {
                compactClusterContent(cluster)
            }

        case .station,
             .overview:
            compactClusterContent(cluster)
        }
    }
    @ViewBuilder
    private func detailContent(
        _ cluster: StationReportCluster
    ) -> some View {
        if let report = cluster.singleReport {
            Button {
                viewModel.selectReport(report)
            } label: {
                ReportMarkerView(
                    report: report,
                    isSelected: viewModel.selectedReportID == report.id
                )
            }
            .buttonStyle(.plain)
        } else {
            ExpandedReportClusterView(
                cluster: cluster,
                selectedReportID: viewModel.selectedReportID
            ) { report in
                viewModel.selectReport(report)
            }
        }
    }
    @ViewBuilder
    private func compactClusterContent(
        _ cluster: StationReportCluster
    ) -> some View {
        Button {
            viewModel.selectCluster(cluster)
        } label: {
            if let report = cluster.singleReport {
                ReportMarkerView(
                    report: report,
                    isSelected: viewModel.selectedReportID == report.id
                )
            } else if cluster.containsOnlyControls {
                ControlReportMarkerView(
                    count: cluster.count,
                    isSelected: viewModel.selectedClusterID == cluster.id
                )
            } else {
                ReportClusterMarkerView(
                    cluster: cluster,
                    isSelected: viewModel.selectedClusterID == cluster.id
                )
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MapView(transitRepository: LocalTransitRepository())
        .environment(LocationManager())
}
