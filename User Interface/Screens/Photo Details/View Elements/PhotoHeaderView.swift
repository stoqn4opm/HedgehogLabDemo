//
//  PhotoHeaderView.swift
//  HedgehogLabDemoUI
//
//  Created by Stoyan Stoyanov on 28/03/22.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - PhotoHeaderView

struct PhotoHeaderView: View {
    
    let frameHeight: CGFloat
    @Binding var image: UIImage?
    
    @State private var ignoreSafeArea = true
    
    @ViewBuilder
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            if let image = image, ignoreSafeArea {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .onTapGesture {
            withAnimation {
                ignoreSafeArea.toggle()
            }
        }
        .shadow(radius: 10)
        .frame(height: frameHeight)
    }
}

// MARK: - Previews

struct PhotoHeaderView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            
            PhotoHeaderView(
                frameHeight: 400,
                image: .constant(UIImage(named: "test.jpeg", in: Bundle(for: MainTabBarController.self), compatibleWith: nil)!))
            PhotoHeaderView(
                frameHeight: 400,
                image: .constant(UIImage(named: "test.jpeg", in: Bundle(for: MainTabBarController.self), compatibleWith: nil)!))
                .preferredColorScheme(.dark)
        }
    }
}
