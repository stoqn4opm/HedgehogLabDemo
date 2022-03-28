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
    @State private var presentFailedImageLoadAlert = false
    
    var body: some View {
        GeometryReader { geometry in
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
                                          viewCount: $viewModel.viewCount)
                        Spacer()
                    }
                    .padding(.bottom, 20)
                }
            }
            .ignoresSafeArea()
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
        .alert("Image loading failed", isPresented: $presentFailedImageLoadAlert) {
            Button("OK", role: .cancel) {
                presentFailedImageLoadAlert = false
            }
        }
        .onAppear {
            viewModel.generateGraphicRepresentation { success in
                guard success == false else { return }
                presentFailedImageLoadAlert = true
            }
        }
    }
}

// MARK: - Previews

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PhotoDetailsView(viewModel: .init(title: "Photo Name", description: "Like many things in SwiftUI, there doesn't seem to be a to do it without tinkering with the underlying UIKit components. There's an easy solution for this one though, using the Introspect library:", tags: ["tag1", "tag2"], viewCount: 103, image: UIImage(systemName: "star")!))
            PhotoDetailsView(viewModel: .init(title: "Photo Name", description: "Like many things in SwiftUI, there doesn't seem to be a to do it without tinkering with the underlying UIKit components. There's an easy solution for this one though, using the Introspect library:", tags: ["tag1", "tag2"], viewCount: 103, image: UIImage(systemName: "star")!))
                .previewDevice("iPod touch (7th generation)")
                .preferredColorScheme(.dark)
        }
    }
}
