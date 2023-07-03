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

struct WebView: UIViewRepresentable {
    let urlString: String
    
    @ObservedObject var viewModel: WebViewModel
    
    func receivedJsonValueFromWebView(value: [String : Any?]) {
        print("JSON from React app")
        print(value)
        viewModel.intention.send("hello world!")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: urlString) else {
            return WKWebView()
        }
        let request = URLRequest(url: url)
        let webView = WKWebView()
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No updates needed
    }
    
    class Coordinator : NSObject, WKNavigationDelegate {
        var parent: WebView
        var callbackValueFromNative: AnyCancellable? = nil
        
        var delegate: WebViewHandlerDelegate?
        
        init(_ uiWebView: WebView) {
            self.parent = uiWebView
            self.delegate = parent as? any WebViewHandlerDelegate
        }
        
        deinit {
            callbackValueFromNative?.cancel()
        }
    }
}

extension WebView.Coordinator: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "IOS_BRIDGE" {
            delegate?.receivedJsonValueFromWebView(value: message.body as! [String : Any?])
        }
    }
}
