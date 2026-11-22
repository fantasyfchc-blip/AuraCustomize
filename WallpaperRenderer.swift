import UIKit
import SwiftUI
enum WallpaperRenderer {
    static let size=CGSize(width:1125,height:2436)
    static func render(theme:AuraTheme,glow:Double,dockShade:Double)->UIImage {
        let f=UIGraphicsImageRendererFormat(); f.scale=1; f.opaque=true
        return UIGraphicsImageRenderer(size:size,format:f).image { ctx in
            let c=ctx.cgContext, bounds=CGRect(origin:.zero,size:size), accent=UIColor(theme.accent)
            c.setFillColor(UIColor(theme.background).cgColor); c.fill(bounds)
            c.saveGState(); c.setShadow(offset:.zero,blur:115,color:accent.withAlphaComponent(0.42).cgColor)
            c.setFillColor(accent.withAlphaComponent(0.12).cgColor); c.fillEllipse(in:CGRect(x:150,y:480,width:825,height:1050)); c.restoreGState()
            let border=UIBezierPath(roundedRect:bounds.insetBy(dx:22,dy:22),cornerRadius:78)
            c.saveGState(); c.setShadow(offset:.zero,blur:26,color:accent.withAlphaComponent(glow).cgColor); c.setStrokeColor(accent.withAlphaComponent(glow).cgColor); c.setLineWidth(7); c.addPath(border.cgPath); c.strokePath(); c.restoreGState()
            let notch=UIBezierPath(roundedRect:CGRect(x:405,y:0,width:315,height:118),cornerRadius:46); c.setFillColor(UIColor.black.cgColor); c.addPath(notch.cgPath); c.fillPath()
            let dock=UIBezierPath(roundedRect:CGRect(x:80,y:2200,width:965,height:175),cornerRadius:62); c.setFillColor(UIColor.black.withAlphaComponent(dockShade).cgColor); c.addPath(dock.cgPath); c.fillPath()
        }
    }
}
