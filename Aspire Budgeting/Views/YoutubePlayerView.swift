//
//  YoutubePlayerView.swift
//  Aspire Budgeting
//
//  Created by TeraMo Labs on 11/6/19.
//  Copyright © 2019 TeraMo Labs. All rights reserved.
//

import SwiftUI
import WebKit

struct YoutubePlayerView: UIViewRepresentable {
  func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<YoutubePlayerView>) {}

  func makeUIView(context: UIViewRepresentableContext<YoutubePlayerView>) -> WKWebView {
    let webConfiguration = WKWebViewConfiguration()
    webConfiguration.allowsInlineMediaPlayback = false

    let webView = WKWebView(frame: .zero, configuration: webConfiguration)

    let videoURL = URL(string: "https://www.youtube.com/embed/RBf9YBBDgbs")
    let request = URLRequest(url: videoURL!)
    webView.load(request)

    return webView
  }
}
