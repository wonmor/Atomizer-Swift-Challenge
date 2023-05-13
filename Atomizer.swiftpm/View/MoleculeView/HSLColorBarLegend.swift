import SwiftUI

struct HSLColorBarLegend: View {
    let localizationManager = LocalizationManager.shared
    
    var body: some View {
        VStack {
            HStack {
                ColorBar(color: Color(#colorLiteral(red: 0.4980392157, green: 1, blue: 0.831372549, alpha: 1)), label: "0")
                ColorBar(color: Color(#colorLiteral(red: 0.5294117647, green: 0.8078431373, blue: 0.9215686275, alpha: 1)), label: "0.2")
                ColorBar(color: Color(#colorLiteral(red: 0.2196078431, green: 0.5843137255, blue: 0.8274509804, alpha: 1)), label: "0.4")
                ColorBar(color: Color(#colorLiteral(red: 0.7647058824, green: 0.6941176471, blue: 0.8823529412, alpha: 1)), label: "0.6")
                ColorBar(color: Color(hue: 0, saturation: 0.5, brightness: 0.75), label: "0.8")
                ColorBar(color: Color(hue: 60/360, saturation: 0.5, brightness: 0.75), label: "1")
            }
            .shadow(radius: 10)
            
            Text(localizationManager.localizedString(for: "electron-density"))
                .foregroundColor(.black)
                .padding(5)
        }
        .background(Color.white)
    }
}

struct ColorBar: View {
    var color: Color
    var label: String
    
    var body: some View {
        ZStack {
           RoundedRectangle(cornerRadius: 5) // Rounded corners
                .stroke(Color.black, lineWidth: 1)
                .shadow(radius: 10)
               .background(color)
           
           Text(label)
               .foregroundColor(.black)
       }

    }
}
