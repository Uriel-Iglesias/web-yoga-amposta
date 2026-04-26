import Foundation
import AVFoundation
import AppKit

let args = CommandLine.arguments
guard args.count >= 4 else { fputs("Uso: swift extract_frames.swift <input> <outdir> <numFrames>\n", stderr); exit(1) }
let input = URL(fileURLWithPath: args[1])
let outdir = args[2]
let n = Int(args[3])!

let asset = AVURLAsset(url: input)
let gen = AVAssetImageGenerator(asset: asset)
gen.appliesPreferredTrackTransform = true
gen.requestedTimeToleranceBefore = .zero
gen.requestedTimeToleranceAfter = .zero
let dur = CMTimeGetSeconds(asset.duration)
print("Duración: \(dur)s, extrayendo \(n) frames")

// Limitamos el ancho a 1600 para reducir peso
gen.maximumSize = CGSize(width: 1500, height: 0)

let fm = FileManager.default
try? fm.createDirectory(atPath: outdir, withIntermediateDirectories: true)

for i in 0..<n {
  let t = CMTime(seconds: Double(i)/Double(n-1) * dur, preferredTimescale: 600)
  do {
    let cg = try gen.copyCGImage(at: t, actualTime: nil)
    let nsImg = NSImage(cgImage: cg, size: .zero)
    guard let tiff = nsImg.tiffRepresentation,
          let rep = NSBitmapImageRep(data: tiff),
          let jpg = rep.representation(using: .jpeg, properties: [.compressionFactor: 0.72]) else {
      fputs("No se pudo codificar frame \(i)\n", stderr); continue
    }
    let path = String(format:"%@/frame-%04d.jpg", outdir, i)
    try jpg.write(to: URL(fileURLWithPath: path))
    if i % 10 == 0 { print("  frame \(i)/\(n-1)") }
  } catch {
    fputs("Error frame \(i): \(error)\n", stderr)
  }
}
print("Listo.")
