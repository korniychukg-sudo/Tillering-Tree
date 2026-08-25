import Foundation

let args = CommandLine.arguments
let outDir = args.count > 1 ? args[1] : "./out"
let iconDir = args.count > 2 ? args[2] : outDir
try? FileManager.default.createDirectory(atPath: outDir, withIntermediateDirectories: true)
try? FileManager.default.createDirectory(atPath: iconDir, withIntermediateDirectories: true)

var made = 0
for spec in bowBook { makeBowPlate(spec, dir: outDir); made += 1; print("bow \(spec.slug)") }
for g in guideBook { makeGuidePlate(g, dir: outDir); made += 1; print("guide \(g.slug)") }
for t in toolBook { makeToolPlate(t, dir: outDir); made += 1; print("tool \(t.slug)") }
let grounds = ["bench", "wall", "shavings", "linen", "board", "paper"]
for (i, g) in grounds.enumerated() { makeGround(g, i, dir: outDir); made += 1; print("ground \(g)") }
makeIcon(dir: iconDir)
print("plates: \(made)")
