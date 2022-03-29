//
//  PhotoDetailsView.swift
//  HedgehogLabDemoUI
//
//  Created by Stoyan Stoyanov on 27/03/22.
//

import SwiftUI
import ServiceLayer

// MARK: - PhotoDetailsView

struct PhotoDetailsView: View {
    @ObservedObject var viewModel: PhotoDetailsViewModel
    
    var body: some View {
        GeometryReader { geometry in
            PhotoDetailsContentView(viewModel: viewModel, geometry: geometry)
            PhotoDetailsOverlayView(viewModel: viewModel)
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.presentErrorAlert) {
            Button("OK", role: .cancel) {
                viewModel.hideErrorAlert()
            }
        }
        .onAppear {
            viewModel.generateGraphicRepresentation()
        }
    }
}

// MARK: - Previews

struct PhotoDetailsContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PhotoDetailsView(viewModel: .init(title: "Photo Name", description: "Like many things in SwiftUI, there doesn't seem to be a to do it without tinkering with the underlying UIKit components. There's an easy solution for this one though, using the Introspect library:", tags: ["tag1", "tag2"], viewCount: 103, image: UIImage(systemName: "star")!, isFavorite: true))
            PhotoDetailsView(viewModel: .init(title: "Photo Name", description: "Like many things in SwiftUI, there doesn't seem to be a to do it without tinkering with the underlying UIKit components. There's an easy solution for this one though, using the Introspect library:", tags: ["tag1", "tag2"], viewCount: 103, image: UIImage(systemName: "star")!, isFavorite: false))
                .previewDevice("iPod touch (7th generation)")
                .preferredColorScheme(.dark)
        }
    }
}

struct PhotoDetailsContentView: View {
    
    @ObservedObject var viewModel: PhotoDetailsViewModel
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
            ScrollView(.vertical) {
                VStack(spacing: -28) {
                    PhotoHeaderView(frameHeight: geometry.size.height * 2 / 3, image: $viewModel.image)
                        .clipped()
                        .frame(width: geometry.size.width)
                    PhotoMetadataView(title: $viewModel.title,
                                      description: $viewModel.description,
                                      tags: $viewModel.tags,
                                      viewCount: $viewModel.viewCount, isFavorite: $viewModel.isFavorite)
                    Spacer()
                }
                .padding(.bottom, 20)
            }
        }
        .ignoresSafeArea()
    }
}

struct PhotoDetailsOverlayView: View {
    @ObservedObject var viewModel: PhotoDetailsViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    viewModel.dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .foregroundColor(.primary)
                        .shadow(color: .init(UIColor.systemGroupedBackground), radius: 15)
                }
            }
            .padding(.horizontal, 22)
            Spacer()
        }
        .padding(.vertical, 25)
    }
}
