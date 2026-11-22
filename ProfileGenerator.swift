import Foundation
import UIKit

enum ProfileGenerator {
    static func createProfile(for app:AppChoice,symbol:String,image:UIImage?) throws -> URL {
        let icon=image?.pngData() ?? renderSymbol(symbol).pngData() ?? Data()
        guard !icon.isEmpty else { throw NSError(domain:"AuraProfile",code:1,userInfo:[NSLocalizedDescriptionKey:"Не удалось создать изображение иконки."]) }
        let payload=UUID().uuidString, profile=UUID().uuidString
        let b64=icon.base64EncodedString()
        let fields=[
          "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
          "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">",
          "<plist version=\"1.0\"><dict><key>PayloadContent</key><array><dict>",
          "<key>FullScreen</key><false/><key>Icon</key><data>\(b64)</data><key>IsRemovable</key><true/>",
          "<key>Label</key><string>\(xml(app.name))</string><key>PayloadDescription</key><string>AuraCustomize Web Clip</string>",
          "<key>PayloadDisplayName</key><string>\(xml(app.name)) Web Clip</string>",
          "<key>PayloadIdentifier</key><string>com.aura.customizer.webclip.\(payload)</string>",
          "<key>PayloadType</key><string>com.apple.webClip.managed</string><key>PayloadUUID</key><string>\(payload)</string><key>PayloadVersion</key><integer>1</integer>",
          "<key>URL</key><string>\(xml(app.scheme))</string></dict></array>",
          "<key>PayloadDescription</key><string>Ярлык приложения от AuraCustomize</string>",
          "<key>PayloadDisplayName</key><string>AuraCustomize — \(xml(app.name))</string>",
          "<key>PayloadIdentifier</key><string>com.aura.customizer.profile.\(profile)</string>",
          "<key>PayloadOrganization</key><string>AuraCustomize</string><key>PayloadRemovalDisallowed</key><false/>",
          "<key>PayloadType</key><string>Configuration</string><key>PayloadUUID</key><string>\(profile)</string><key>PayloadVersion</key><integer>1</integer></dict></plist>"
        ]
        let url=FileManager.default.temporaryDirectory.appendingPathComponent("Aura-\(app.id).mobileconfig")
        try Data(fields.joined(separator:"\n").utf8).write(to:url,options:.atomic)
        return url
    }
    private static func renderSymbol(_ name:String)->UIImage {
        UIGraphicsImageRenderer(size:CGSize(width:180,height:180)).image { c in
            let cg=c.cgContext
            let colors=[UIColor.systemPurple.cgColor,UIColor.systemBlue.cgColor,UIColor.systemCyan.cgColor] as CFArray
            let g=CGGradient(colorsSpace:CGColorSpaceCreateDeviceRGB(),colors:colors,locations:[0,0.55,1])!
            cg.drawLinearGradient(g,start:.zero,end:CGPoint(x:180,y:180),options:[])
            UIImage(systemName:name,withConfiguration:UIImage.SymbolConfiguration(pointSize:76,weight:.semibold))?.withTintColor(.white,renderingMode:.alwaysOriginal).draw(in:CGRect(x:48,y:48,width:84,height:84))
        }
    }
    private static func xml(_ s:String)->String { s.replacingOccurrences(of:"&",with:"&amp;").replacingOccurrences(of:"<",with:"&lt;").replacingOccurrences(of:">",with:"&gt;").replacingOccurrences(of:"\"",with:"&quot;").replacingOccurrences(of:"'",with:"&apos;") }
}
