import SwiftUI

struct FormattedTextView: View {
    let text: String
    @State private var contentSegments: [FormattedTextSegment] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(contentSegments) { segment in
                SegmentView(segment: segment)
            }
        }.onAppear {
            parseText()
        }
    }
    
    private func parseText() {
        var parsedSegments: [FormattedTextSegment] = []
        let rawText = text.replacingOccurrences(of: "\\n", with: "\n")
        
        let imageLinkPattern = "!\\[(.*?)\\]\\((.*?)\\)"
        let imageLinkRegex = try! NSRegularExpression(pattern: imageLinkPattern, options: [])
        let matches = imageLinkRegex.matches(in: rawText, options: [], range: NSRange(location: 0, length: rawText.count))
        
        var lastRangeEnd = 0
        
        for match in matches {
            if match.range.location > lastRangeEnd {
                let plainTextRange = NSRange(location: lastRangeEnd, length: match.range.location - lastRangeEnd)
                let plainText = (rawText as NSString).substring(with: plainTextRange)
                parsedSegments.append(FormattedTextSegment(type: .text, content: plainText))
            }
            
            let altText = (rawText as NSString).substring(with: match.range(at: 1))
            let url = (rawText as NSString).substring(with: match.range(at: 2))
            parsedSegments.append(FormattedTextSegment(type: .image, content: url, altText: altText))
            
            lastRangeEnd = match.range.upperBound
        }
        
        if lastRangeEnd < rawText.count {
            let plainTextRange = NSRange(location: lastRangeEnd, length: rawText.count - lastRangeEnd)
            let plainText = (rawText as NSString).substring(with: plainTextRange)
            parsedSegments.append(FormattedTextSegment(type: .text, content: plainText))
        }
        
        contentSegments = parsedSegments
    }
}

struct FormattedTextSegment: Identifiable {
    let id = UUID()
    let type: ContentType
    let content: String
    let altText: String

    enum ContentType {
        case text
        case image
    }
    
    init(type: ContentType, content: String, altText: String = "") {
        self.type = type
        self.content = content
        self.altText = altText
    }
}

struct SegmentView: View {
    let segment: FormattedTextSegment

    var body: some View {
        switch segment.type {
        case .text:
            return AnyView(Text(segment.content)
                .font(.body))
        case .image:
            return AnyView(ImageView(urlString: segment.content, altText: segment.altText))
        }
    }
}

struct ImageView: View {
    let urlString: String
    let altText: String
    
    @State private var image: UIImage? = nil
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .accessibility(label: Text(altText))
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }

            }
        }.resume()
    }
}
