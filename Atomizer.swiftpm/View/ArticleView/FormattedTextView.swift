import SwiftUI
import MarkdownUI

/**
    A view that displays an article.
 
    ATOMIZER
    Developed and Designed by John Seong.
*/

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
            
            let imageFileName = (rawText as NSString).substring(with: match.range(at: 2))
            if let image = UIImage(named: imageFileName) {
                parsedSegments.append(FormattedTextSegment(type: .image, content: image, altText: imageFileName))
            } else {
                parsedSegments.append(FormattedTextSegment(type: .text, content: "![\(imageFileName)](\(imageFileName))"))
            }

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
    let content: Any
    let altText: String

    enum ContentType {
        case text
        case image
    }

    init(type: ContentType, content: Any, altText: String = "") {
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
            return AnyView(
                Markdown(segment.content as? String ?? "")
                    .markdownBlockStyle(\.blockquote) { configuration in
                      configuration.label
                        .padding()
                        .markdownTextStyle {
                          FontWeight(.semibold)
                          BackgroundColor(nil)
                        }
                        .overlay(alignment: .leading) {
                          Rectangle()
                            .fill(Color.teal)
                            .frame(width: 4)
                        }
                        .background(Color.teal.opacity(0.5))
                    }
            )
        case .image:
            if let uiImage = segment.content as? UIImage {
                return AnyView(
                    HStack(alignment: .top) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 500)
                                .cornerRadius(10)
                                .accessibility(label: Text(segment.altText))
                                .alignmentGuide(HorizontalAlignment.leading) { _ in 0 } // Align to the left
                            Spacer()
                        }
                )
            } else {
                return AnyView(
                    Markdown(segment.content as? String ?? "")
                        .font(Font.system(.body, design: .rounded))
                )
            }

        }
    }
}
