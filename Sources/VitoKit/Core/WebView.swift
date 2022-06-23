//
//  File.swift
//  
//
//  Created by Andreas Ink on 6/21/22.
//

import Foundation
import WebKit
import UIKit
import SwiftUI

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView

    let webView: WKWebView
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
       
    }
}

class WebViewModel: ObservableObject {
    let webView: WKWebView
    let url: URL
    
    init() {
        webView = WKWebView(frame: .zero)
        
        url = URL(string: "https://www.fitbit.com/oauth2/authorize?response_type=token&client_id=2389P9&redirect_uri=https%3A%2F%2Fandreasink.web.app&scope=heartrate%20sleep%20respiratory_rate%20oxygen_saturation%20activity&expires_in=2592000")!

        loadUrl()
    }
    
    func loadUrl() {
        webView.load(URLRequest(url: url))
    }
    
}
