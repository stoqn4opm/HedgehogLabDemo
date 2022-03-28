//
//  PhotoMetadataView.swift
//  HedgehogLabDemoUI
//
//  Created by Stoyan Stoyanov on 28/03/22.
//

import Foundation
import SwiftUI

// MARK: - PhotoMetadataView

struct PhotoMetadataView: View {
    
    @Binding var title: String
    @Binding var description: String?
    @Binding var tags: [String]
    @Binding var viewCount: Int
    
    
    @ViewBuilder
    var body: some View {
        VStack {
            PhotoTitleView(title: $title, viewCount: $viewCount)
            Divider()
            if let description = description {
                Text(description)
                    .padding(.bottom, 15)
            }
            if tags.isEmpty == false {
                HashTagListView(tags: $tags)
            }
        }
        .padding()
        .padding(.bottom, 80)
    }
}

// MARK: - Title Subview

struct PhotoTitleView: View {
    
    @Binding var title: String
    @Binding var viewCount: Int
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .shadow(color: .init(UIColor.systemGroupedBackground), radius: 5)
                    .shadow(color: .init(UIColor.systemGroupedBackground), radius: 5)
                    .shadow(color: .init(UIColor.systemGroupedBackground), radius: 10)
                    .shadow(color: .init(UIColor.systemGroupedBackground), radius: 15)
                    .font(.title)
                Spacer()
            }
            .padding(.bottom, 0.5)
            HStack {
                Label {
                    Text("\(viewCount) views")
                        .font(.caption)
                } icon: {
                    Image(systemName: "camera.fill")
                }
                Spacer()
            }
        }
    }
}

// MARK: - Tags Subview

struct HashTagListView: View {
    
    @Binding var tags: [String]
    
    var body: some View {
        VStack {
            HStack {
                Text("Tagged with:")
                    .font(.body)
                    .bold()
                Spacer()
            }
            ZStack {
                Color(UIColor.secondarySystemFill)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(tags, id: \.self) {
                            HashTagView(tag: $0)
                        }
                    }
                }
                .padding(EdgeInsets(top: 5, leading: 4, bottom: 5, trailing: 4))
            }
            .frame(height: 44)
            .cornerRadius(10)
        }
    }
}

struct HashTagView: View {
    
    let tag: String
    
    var body: some View {
        ZStack {
            Color(UIColor.tintColor)
            Text("#\(tag)")
                .padding(.horizontal, 10)
        }
        .cornerRadius(10)
    }
}

// MARK: - Previews

struct PhotoMetadataView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PhotoMetadataView(title: .constant("Photo Name"),
                              description: .constant("Use an Image instance when you want to add images to your SwiftUI app. You can create images from many sources"),
                              tags: .constant(["test1"]),
                              viewCount: .constant(10))
            PhotoMetadataView(title: .constant("Photo Name"),
                              description: .constant("Use an Image instance when you want to add images to your SwiftUI app. You can create images from many sources"),
                              tags: .constant(["test1"]),
                              viewCount: .constant(10))
            .preferredColorScheme(.dark)
        }
    }
}
