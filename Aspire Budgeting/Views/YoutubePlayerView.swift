//
//  YoutubePlayerView.swift
//  Aspire Budgeting
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
