//
//  SwiftUIView.swift
//
//
//  Created by John Seong on 2023-07-02.
//

import SwiftUI
import WebKit
import Combine

protocol WebViewHandlerDelegate {
    func receivedJsonValueFromWebView(value: [String: Any?])
}

struct WebView: UIViewRepresentable, WebViewHandlerDelegate {
    let urlString: String
    
    @ObservedObject var viewModel: WebViewModel
    
    func receivedJsonValueFromWebView(value: [String : Any?]) {
        if let message = value["message"] as? String {
            viewModel.setIntention(message: message)
        }
        
        if let metadata = value["metadata"] as? String {
            viewModel.setMetadata(data: metadata)
            print(metadata)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        let userContentController = WKUserContentController()
        userContentController.add(context.coordinator, name: "IOS_BRIDGE")
        userContentController.add(context.coordinator, name: "IOS_BRIDGE_METADATA")
        config.userContentController = userContentController
        
        let webview = WKWebView(frame: .zero, configuration: config)
        
        webview.navigationDelegate = context.coordinator
        webview.allowsBackForwardNavigationGestures = false
        webview.scrollView.isScrollEnabled = true
        webview.allowsLinkPreview = true
        
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let url = URL(string: urlString)
        
        guard let myUrl = url else {
            return
        }
        
        let request = URLRequest(url: myUrl)
        uiView.load(request)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var callbackValueFromNative: AnyCancellable? = nil
        
        var delegate: WebViewHandlerDelegate?
        
        init(_ uiWebView: WebView) {
            self.parent = uiWebView
            self.delegate = parent as? WebViewHandlerDelegate
        }
        
        deinit {
            callbackValueFromNative?.cancel()
        }
    }
}

extension WebView.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "IOS_BRIDGE" || message.name == "IOS_BRIDGE_METADATA" {
            delegate?.receivedJsonValueFromWebView(value: message.body as! [String : Any?])
        }
    }
}
