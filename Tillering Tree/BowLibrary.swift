import SwiftUI

enum LimbShape: String, Codable {
    case longbow, flatbow, holmegaard, recurve, composite, yumi, deflex, pyramid
}

enum RingKind: String, Codable { case porous, yew, bamboo, board, composite }

struct BowNote: Identifiable {
    let head: String
    let text: String
    var id: String { head }
}

struct BowEntry: Identifiable {
    let slug: String
    let name: String
    let place: String
    let era: String
    let timber: String
    let shape: LimbShape
    let length: Double
    let limbWidth: Double
    let tipWidth: Double
    let draw: Int
    let weight: Int
    let backed: Bool
    let ring: RingKind
    let tough: Double
    let stiff: Double
    let difficulty: Int
    let line: String
    let notes: [BowNote]
    var id: String { slug }
    var plate: String { "bow-" + slug }
    var inches: Int { Int(length * 78) }
}

let bowGroup0: [BowEntry] = [
    BowEntry(slug: "englishwarbow", name: "English Warbow", place: "England", era: "1400s", timber: "Italian yew",
             shape: .longbow, length: 1.00, limbWidth: 0.36, tipWidth: 0.30,
             draw: 32, weight: 150, backed: false, ring: .yew,
             tough: 0.70, stiff: 0.90, difficulty: 3,
             line: "Six feet of yew, drawn to the ear, and it takes a lifetime to be able to pull one",
             notes: [BowNote(head: "Two woods in one stick", text: "Yew is the only European timber with a natural laminate: pale sapwood on the back that resists tension, dark heartwood on the belly that resists compression."),
                       BowNote(head: "D section, not flat", text: "A warbow is deep and narrow, almost round on the belly. All the strength is in the depth, and depth is what makes it heavy."),
                       BowNote(head: "A whip ended tiller", text: "The outer third bends more than a modern eye expects. Tillered like a flatbow, a warbow of this weight would break."),
                       BowNote(head: "Thirty two inches", text: "Drawn to the ear rather than the chin. The arrow is a yard long and weighs three ounces.")]),
    BowEntry(slug: "osageflatbow", name: "Osage Flatbow", place: "Great Plains", era: "1800s", timber: "Osage orange",
             shape: .flatbow, length: 0.78, limbWidth: 0.66, tipWidth: 0.22,
             draw: 28, weight: 55, backed: false, ring: .porous,
             tough: 0.86, stiff: 0.94, difficulty: 1,
             line: "Wide, flat, short, and the finest bow wood on earth",
             notes: [BowNote(head: "One ring, all the way", text: "The back is a single growth ring chased down with a drawknife across the whole limb. Violate it anywhere and the bow lifts a splinter there."),
                       BowNote(head: "Width does the work", text: "A flatbow spreads the strain across a wide thin limb instead of a deep narrow one. It takes less set and it shoots faster for its weight."),
                       BowNote(head: "Yellow, then orange, then brown", text: "Freshly cut osage is almost fluorescent yellow. It darkens to deep orange in a season and to brown in a decade."),
                       BowNote(head: "It will outlast you", text: "Osage staves cut a century ago are still being made into bows. Nothing else keeps like it.")]),
    BowEntry(slug: "holmegaard", name: "Holmegaard Bow", place: "Denmark", era: "7000 BC", timber: "Elm",
             shape: .holmegaard, length: 0.86, limbWidth: 0.60, tipWidth: 0.12,
             draw: 26, weight: 50, backed: false, ring: .porous,
             tough: 0.94, stiff: 0.58, difficulty: 2,
             line: "Nine thousand years old, and the outer limb is already stiff and narrow",
             notes: [BowNote(head: "Stiff outer limbs", text: "The design puts all the bending in the inner two thirds and leaves the outers as narrow levers. It is the oldest known example of the idea."),
                       BowNote(head: "Mesolithic and modern", text: "The same principle turns up in every fast bow since. Whoever cut the original had worked out what mass at the tips costs you."),
                       BowNote(head: "Elm, not yew", text: "Elm is tougher in tension than yew and takes more set. It wants a wider, flatter limb to compensate."),
                       BowNote(head: "Found in a bog", text: "Peat preserved the wood well enough to measure the section. That is why we know the tiller and not just the outline.")]),
    BowEntry(slug: "meareheath", name: "Meare Heath Bow", place: "Somerset Levels", era: "2600 BC", timber: "Yew",
             shape: .flatbow, length: 0.90, limbWidth: 0.72, tipWidth: 0.20,
             draw: 28, weight: 65, backed: true, ring: .yew,
             tough: 0.86, stiff: 0.90, difficulty: 2,
             line: "A wide flat yew bow bound with leather cross straps, from a bog in Somerset",
             notes: [BowNote(head: "Wider than any warbow", text: "Sixty two millimetres across the limb, and flat. It is a different tradition entirely from the medieval longbow."),
                       BowNote(head: "Bound at intervals", text: "Leather cross bindings at regular spacing, probably to hold a sinew or bark backing that has not survived."),
                       BowNote(head: "Neolithic engineering", text: "The taper and the section are both worked out. This is not somebody bending a stick; it is a designed object."),
                       BowNote(head: "Yew again", text: "Even at this date, yew was chosen. The tree that made the warbow was already the best wood available four thousand years earlier.")]),
    BowEntry(slug: "hickoryselfbow", name: "Hickory Selfbow", place: "Eastern Woodlands", era: "1700s", timber: "Shagbark hickory",
             shape: .pyramid, length: 0.80, limbWidth: 0.70, tipWidth: 0.14,
             draw: 27, weight: 48, backed: false, ring: .porous,
             tough: 0.96, stiff: 0.64, difficulty: 1,
             line: "A pyramid limb: full width at the handle, straight taper to a narrow tip",
             notes: [BowNote(head: "Constant thickness", text: "A pyramid bow tapers only in width. The thickness is the same from handle to tip, and the taper alone makes the tiller."),
                       BowNote(head: "Forgiving to tiller", text: "Because thickness is constant, a scraper mistake is far less punishing than on a bow that tapers in both directions."),
                       BowNote(head: "Hickory hates damp", text: "It is superb dry and sluggish wet. A hickory bow left in a damp shed comes out weak and takes set at once."),
                       BowNote(head: "Ring violation matters less", text: "Unlike osage or yew, hickory will tolerate a back that cuts across rings, which is why it is the beginner's wood.")]),
    BowEntry(slug: "molle", name: "Mollegabet", place: "Denmark", era: "6000 BC", timber: "Elm",
             shape: .holmegaard, length: 0.84, limbWidth: 0.56, tipWidth: 0.10,
             draw: 26, weight: 45, backed: false, ring: .porous,
             tough: 0.94, stiff: 0.58, difficulty: 2,
             line: "Half the limb bends and half of it does not, and the tips are almost sticks",
             notes: [BowNote(head: "Extreme lever tips", text: "The outer half is a narrow stiff lever. All the work happens in a short inner limb, which is a hard thing to tiller."),
                       BowNote(head: "Very low tip mass", text: "Almost no weight at the ends means almost no energy wasted moving the limb itself. It is why the design keeps reappearing."),
                       BowNote(head: "Short working limb", text: "A short bending section takes more strain per inch. The wood has to be good and the tiller has to be right."),
                       BowNote(head: "Also from a bog", text: "Danish peat has given us more early bows than anywhere else, and Mollegabet is the type site for the design.")])
]

let bowGroup1: [BowEntry] = [
    BowEntry(slug: "sudbury", name: "Sudbury Bow", place: "Massachusetts", era: "1660", timber: "Hickory",
             shape: .flatbow, length: 0.82, limbWidth: 0.52, tipWidth: 0.18,
             draw: 27, weight: 46, backed: false, ring: .porous,
             tough: 0.96, stiff: 0.64, difficulty: 1,
             line: "The oldest surviving bow from New England, with a snake head profile",
             notes: [BowNote(head: "A widening tip", text: "The limb narrows and then flares slightly at the nock. It looks decorative and it also stops the nock groove weakening the tip."),
                       BowNote(head: "Taken in 1660", text: "One of very few Eastern Woodlands bows to survive from the contact period, and the source for hundreds of modern copies."),
                       BowNote(head: "Narrow for a flatbow", text: "At forty millimetres it sits between the wide plains flatbow and the deep English longbow."),
                       BowNote(head: "Handle bends too", text: "There is no rigid riser. The whole bow bends, which is normal for the tradition and unusual to a modern eye.")]),
    BowEntry(slug: "penobscot", name: "Penobscot Bow", place: "Maine", era: "1800s", timber: "Ash and hickory",
             shape: .deflex, length: 0.86, limbWidth: 0.54, tipWidth: 0.16,
             draw: 28, weight: 50, backed: true, ring: .porous,
             tough: 0.99, stiff: 0.64, difficulty: 1,
             line: "A second small bow strapped to the belly of the first, and nobody agrees why",
             notes: [BowNote(head: "Two bows, one string", text: "A short cable bow is lashed to the belly and its string runs to the main tips. The effect is a compound before compounds."),
                       BowNote(head: "Contested", text: "Some think it is a genuine early design; others think it is a late curiosity made for collectors. The debate has run for a century."),
                       BowNote(head: "It does work", text: "Whatever its provenance, the geometry gives a let off at full draw, which is exactly what a modern compound does."),
                       BowNote(head: "Very hard to tiller", text: "Two bending systems that have to agree with each other, and adjusting one changes the other.")]),
    BowEntry(slug: "turkishflight", name: "Turkish Flight Bow", place: "Ottoman", era: "1600s", timber: "Horn, sinew and maple",
             shape: .composite, length: 0.52, limbWidth: 0.26, tipWidth: 0.14,
             draw: 28, weight: 100, backed: true, ring: .composite,
             tough: 0.99, stiff: 0.99, difficulty: 5,
             line: "Forty five inches strung, and the flight records it set stood for three hundred years",
             notes: [BowNote(head: "Three materials", text: "Horn on the belly for compression, sinew on the back for tension, a thin maple core to hold them apart. Wood alone cannot do this."),
                       BowNote(head: "Reflexed to a circle", text: "Unstrung it curls back on itself almost into a ring. Bracing it is a two person job with a stringing frame."),
                       BowNote(head: "A year to build", text: "The sinew is laid in courses and each course dries for weeks. Nothing about the process can be hurried."),
                       BowNote(head: "Records that stood", text: "A Turkish flight shot of over 800 metres in the eighteenth century was not beaten with a hand bow until the twentieth.")]),
    BowEntry(slug: "mongol", name: "Mongol Composite", place: "Central Asia", era: "1200s", timber: "Horn, sinew and birch",
             shape: .composite, length: 0.58, limbWidth: 0.28, tipWidth: 0.16,
             draw: 30, weight: 90, backed: true, ring: .composite,
             tough: 0.99, stiff: 0.99, difficulty: 5,
             line: "Short enough to shoot from a horse and heavy enough to matter when it lands",
             notes: [BowNote(head: "Built for horseback", text: "Length is the enemy on a horse. A composite gets a long draw out of a short bow because horn and sinew store more energy per inch."),
                       BowNote(head: "Rigid siyahs", text: "The stiff angled tips act as levers and give a let off at full draw, which matters when you hold at anchor on a moving horse."),
                       BowNote(head: "Glue is the weak point", text: "Fish or hide glue holds it together, and it fails in damp. A composite in a wet climate is a short lived thing."),
                       BowNote(head: "Thumb draw", text: "Drawn with a ring on the thumb, which puts the arrow on the other side of the bow from a European loose.")]),
    BowEntry(slug: "yumi", name: "Japanese Yumi", place: "Japan", era: "1500s", timber: "Bamboo and haze",
             shape: .yumi, length: 1.00, limbWidth: 0.22, tipWidth: 0.16,
             draw: 34, weight: 45, backed: true, ring: .bamboo,
             tough: 0.99, stiff: 0.66, difficulty: 2,
             line: "Seven feet, and the hand grips it a third of the way up rather than in the middle",
             notes: [BowNote(head: "Asymmetric on purpose", text: "The grip sits at about a third of the length. The lower limb is short and stiff, the upper long and supple."),
                       BowNote(head: "Laminated bamboo", text: "Bamboo front and back with hardwood cores glued between. The construction is a thousand years older than modern laminates."),
                       BowNote(head: "It turns in the hand", text: "On release the bow rotates so the string ends up behind the wrist. The turn is not a fault; it is the design working."),
                       BowNote(head: "Tillered by shaving the core", text: "Adjustment is made by scraping the wooden cores at the ends, not the bamboo faces.")]),
    BowEntry(slug: "gakgung", name: "Korean Gakgung", place: "Korea", era: "1600s", timber: "Horn, sinew, bamboo and oak",
             shape: .composite, length: 0.50, limbWidth: 0.24, tipWidth: 0.14,
             draw: 30, weight: 55, backed: true, ring: .composite,
             tough: 0.99, stiff: 0.99, difficulty: 3,
             line: "The most reflexed bow in the world, and it shoots further for its weight than anything else",
             notes: [BowNote(head: "A full circle unstrung", text: "Off the string it curls into a ring that a hand can hold. There is more stored reflex here than in any other tradition."),
                       BowNote(head: "Water buffalo horn", text: "Long strips of horn on the belly, sometimes a metre in a single piece, which is why buffalo rather than cattle."),
                       BowNote(head: "Birch bark", text: "The whole bow is finished in birch bark, which keeps the damp out of the glue lines and takes the decoration."),
                       BowNote(head: "Shot at 145 metres", text: "Traditional Korean archery targets sit at that distance, which no European wooden bow can reach with accuracy.")])
]

let bowGroup2: [BowEntry] = [
    BowEntry(slug: "scythian", name: "Scythian Bow", place: "Pontic Steppe", era: "400 BC", timber: "Horn, sinew and wood",
             shape: .recurve, length: 0.46, limbWidth: 0.26, tipWidth: 0.14,
             draw: 26, weight: 60, backed: true, ring: .composite,
             tough: 0.99, stiff: 0.99, difficulty: 4,
             line: "Tiny, double curved, and it goes in a case with the arrows",
             notes: [BowNote(head: "The gorytos", text: "Bow and arrows share a single case worn at the hip. A bow that short is the only kind that fits."),
                       BowNote(head: "Sigma shaped", text: "Braced it makes a shallow S with the tips curving away. Greek writers describe the shape as unmistakable."),
                       BowNote(head: "Very early composite", text: "Horn and sinew construction is already mature by this date, which means it had been developing for a long time before."),
                       BowNote(head: "Buried with the owner", text: "Almost everything we know comes from kurgan burials, where the metal fittings survived and the organics did not.")]),
    BowEntry(slug: "bhutan", name: "Bhutanese Bamboo Bow", place: "Bhutan", era: "Traditional", timber: "Split bamboo",
             shape: .flatbow, length: 0.82, limbWidth: 0.40, tipWidth: 0.18,
             draw: 27, weight: 45, backed: false, ring: .bamboo,
             tough: 0.90, stiff: 0.66, difficulty: 1,
             line: "One length of split bamboo, and archery is the national sport",
             notes: [BowNote(head: "A single split", text: "Cut from the wall of a large culm so the hard outer skin is the back. Nothing is glued and nothing is laminated."),
                       BowNote(head: "The node matters", text: "A node in the bending part of the limb is a stiff spot and has to be allowed for when tillering."),
                       BowNote(head: "Shot at 145 metres", text: "The traditional Bhutanese range is enormous, and matches involve singing, dancing and a great deal of noise."),
                       BowNote(head: "Fast for its weight", text: "Bamboo has a very high strength to weight ratio, so the limbs can be light and the cast is good.")]),
    BowEntry(slug: "andaman", name: "Andaman Bow", place: "Andaman Islands", era: "Traditional", timber: "Chuoi wood",
             shape: .deflex, length: 0.92, limbWidth: 0.44, tipWidth: 0.20,
             draw: 28, weight: 42, backed: false, ring: .porous,
             tough: 0.66, stiff: 0.62, difficulty: 1,
             line: "An S shaped bow with a broad flat handle, unlike anything else",
             notes: [BowNote(head: "The S profile", text: "One limb deflexed and one reflexed, giving an asymmetric shape that is unique to the islands."),
                       BowNote(head: "Wide flat grip", text: "The handle is a broad paddle rather than a round grip. It is held in a way that no other tradition uses."),
                       BowNote(head: "Shot standing in a canoe", text: "Much of the use was for fish and turtle from a boat, which explains a great deal about the design."),
                       BowNote(head: "Very little study", text: "Few examples reached museums and fewer were measured. Most of what is written about them is inference.")]),
    BowEntry(slug: "yewselfbow", name: "Pacific Yew Selfbow", place: "Pacific Northwest", era: "1800s", timber: "Pacific yew",
             shape: .flatbow, length: 0.76, limbWidth: 0.62, tipWidth: 0.18,
             draw: 26, weight: 45, backed: false, ring: .yew,
             tough: 0.70, stiff: 0.90, difficulty: 1,
             line: "Short, wide and sinew backed in the north, plain in the south",
             notes: [BowNote(head: "Denser than European yew", text: "Slow grown mountain yew with very tight rings, and it takes a shorter, wider bow than a warbow stave would."),
                       BowNote(head: "Sinew where it was wet", text: "Northern makers backed with sinew against the damp; southern makers often did not bother."),
                       BowNote(head: "Short for the country", text: "Timber is close in the forest. A long bow is a liability where you shoot between trees."),
                       BowNote(head: "Still the reference wood", text: "Modern bowyers in North America still rate Pacific yew alongside osage as the two best native bow woods.")]),
    BowEntry(slug: "ashlongbow", name: "Ash Longbow", place: "Northern Europe", era: "Medieval", timber: "European ash",
             shape: .longbow, length: 0.94, limbWidth: 0.42, tipWidth: 0.26,
             draw: 28, weight: 60, backed: false, ring: .porous,
             tough: 0.82, stiff: 0.52, difficulty: 2,
             line: "What a bow was made of when there was no yew and no money",
             notes: [BowNote(head: "The common wood", text: "Ash is everywhere in Europe and it makes a serviceable bow. Yew was expensive and often imported."),
                       BowNote(head: "Takes set readily", text: "Ash is strong in tension and weak in compression, so the belly frets and the bow follows the string."),
                       BowNote(head: "Wants width", text: "A narrow ash longbow will chrysal. Widen the limb and reduce the thickness and it lasts far longer."),
                       BowNote(head: "Rings should be thick", text: "Unlike yew, ring porous woods like ash want fast growth. Thin rings mean too much soft early wood.")]),
    BowEntry(slug: "elmbow", name: "Elm Bow", place: "Northern Europe", era: "Neolithic onward", timber: "Wych elm",
             shape: .flatbow, length: 0.84, limbWidth: 0.58, tipWidth: 0.18,
             draw: 27, weight: 48, backed: false, ring: .porous,
             tough: 0.94, stiff: 0.58, difficulty: 1,
             line: "The wood of the oldest bows in Europe, and it will not splinter",
             notes: [BowNote(head: "Interlocked grain", text: "Elm grain twists, which makes it a nuisance to split and almost impossible to break in tension."),
                       BowNote(head: "It tolerates violation", text: "You can cut across rings on the back of an elm bow and get away with it. Try that on yew and it lifts a splinter."),
                       BowNote(head: "Takes more set", text: "Elm is not stiff. Expect string follow and design the bow to live with it rather than fighting it."),
                       BowNote(head: "Every bog bow", text: "Holmegaard, Mollegabet and most of the Danish finds are elm. It was the default before yew.")])
]

let bowGroup3: [BowEntry] = [
    BowEntry(slug: "hazelbow", name: "Hazel Bow", place: "Britain", era: "Traditional", timber: "Hazel",
             shape: .pyramid, length: 0.78, limbWidth: 0.64, tipWidth: 0.16,
             draw: 26, weight: 40, backed: false, ring: .porous,
             tough: 0.72, stiff: 0.48, difficulty: 1,
             line: "Cut from the coppice in the morning and shooting by the evening",
             notes: [BowNote(head: "Whole stave, bark on", text: "A hazel rod of the right diameter needs almost no reduction. The back is simply the outside of the tree."),
                       BowNote(head: "Weak but honest", text: "It will not make a heavy bow and it will take set. It will make a working bow in an afternoon."),
                       BowNote(head: "Coppice is the point", text: "Hazel has been cut on rotation in Britain for millennia, and a coppice throws up straight rods of exactly the right size."),
                       BowNote(head: "Season it fast", text: "Small diameter and thin bark mean it dries in weeks rather than the years a yew stave wants.")]),
    BowEntry(slug: "juniper", name: "Juniper Bow", place: "Great Basin", era: "Traditional", timber: "Western juniper",
             shape: .flatbow, length: 0.72, limbWidth: 0.66, tipWidth: 0.20,
             draw: 24, weight: 40, backed: true, ring: .porous,
             tough: 0.46, stiff: 0.88, difficulty: 1,
             line: "Sinew backed, because on its own it would break at the first draw",
             notes: [BowNote(head: "Weak in tension", text: "Juniper cannot hold the back together by itself. A heavy sinew backing takes the tension and the wood takes the compression."),
                       BowNote(head: "Superb in compression", text: "Which is exactly what a sinew backed bow needs from its belly. The pairing is not an accident."),
                       BowNote(head: "Very short", text: "A metre and a half at most, because sinew allows a shorter bow than wood alone would survive."),
                       BowNote(head: "Months to dry", text: "A sinew backing takes weeks to cure and the bow gains reflex as it does. It is the last thing to be finished.")]),
    BowEntry(slug: "ipe", name: "Ipe Backed Bow", place: "Modern", era: "Contemporary", timber: "Ipe with bamboo backing",
             shape: .flatbow, length: 0.82, limbWidth: 0.50, tipWidth: 0.16,
             draw: 28, weight: 50, backed: true, ring: .bamboo,
             tough: 0.99, stiff: 0.66, difficulty: 1,
             line: "Tropical hardwood belly, bamboo back, and it is the modern beginner's bow",
             notes: [BowNote(head: "Bombproof in compression", text: "Ipe is one of the densest timbers in commerce and it resists the belly fretting that kills wooden bows."),
                       BowNote(head: "Bamboo takes the tension", text: "The pairing splits the job perfectly and the glue line does the rest. It is forgiving of everything except a bad tiller."),
                       BowNote(head: "Cheap and available", text: "Sold as decking. A bow stave costs a fraction of what a yew billet does and performs nearly as well."),
                       BowNote(head: "Heavy limbs", text: "The density that makes it strong also makes it slow. It is a fine bow and it is not a fast one.")]),
    BowEntry(slug: "sinewbacked", name: "Sinew Backed Recurve", place: "Great Plains", era: "1800s", timber: "Ash with sinew",
             shape: .recurve, length: 0.62, limbWidth: 0.48, tipWidth: 0.16,
             draw: 24, weight: 55, backed: true, ring: .composite,
             tough: 0.99, stiff: 0.52, difficulty: 2,
             line: "Short, recurved and backed with sinew, for shooting from a horse",
             notes: [BowNote(head: "Sinew adds reflex", text: "As the sinew dries it shrinks and pulls the limbs back into reflex. That stored curve is free energy."),
                       BowNote(head: "Recurved tips", text: "Steamed and bent forward, so the string lies along the limb at brace and peels off as the bow is drawn."),
                       BowNote(head: "Short because mounted", text: "Everything about the design comes from having to shoot it from a moving horse at close range."),
                       BowNote(head: "Damp ruins it", text: "Hide glue and sinew both soften in wet weather. A rain squall can take twenty pounds off the draw weight.")]),
    BowEntry(slug: "cedar", name: "Cedar Backed Bow", place: "Pacific Northwest", era: "Traditional", timber: "Yew with cedar",
             shape: .flatbow, length: 0.80, limbWidth: 0.56, tipWidth: 0.18,
             draw: 26, weight: 44, backed: true, ring: .yew,
             tough: 0.86, stiff: 0.90, difficulty: 1,
             line: "A yew belly under a light cedar back, from a coast where everything is made of cedar",
             notes: [BowNote(head: "Light back, heavy belly", text: "The back only needs to hold together in tension, so a light wood there costs nothing and saves limb mass."),
                       BowNote(head: "Glued with salmon skin", text: "Traditional glues in the region came from fish. They are strong and they are not waterproof."),
                       BowNote(head: "Painted and bound", text: "Most surviving examples are decorated, bound at the handle and finished with pitch."),
                       BowNote(head: "Wet climate problems", text: "Every organic glue in a rainforest is a compromise, which is why so many coastal bows are also sinew wrapped.")]),
    BowEntry(slug: "boardbow", name: "Red Oak Board Bow", place: "Anywhere", era: "Contemporary", timber: "Red oak board",
             shape: .pyramid, length: 0.80, limbWidth: 0.72, tipWidth: 0.14,
             draw: 26, weight: 40, backed: false, ring: .board,
             tough: 0.62, stiff: 0.60, difficulty: 1,
             line: "A plank from a timber yard, and the first bow almost everybody makes",
             notes: [BowNote(head: "Grain run off is the enemy", text: "A sawn board rarely has grain running the full length. Where it runs off the back, the bow lifts a splinter and breaks."),
                       BowNote(head: "Choose the board carefully", text: "Look down the edge and reject anything where the lines wander. Half the boards in a stack are unusable."),
                       BowNote(head: "Wide and pyramid", text: "Maximum width at the handle and a straight taper to the tip. It spreads the strain and forgives a rough tiller."),
                       BowNote(head: "It will teach you everything", text: "Cheap enough to break without regret, and breaking bows is how the tiller gets learned.")])
]

let bowLibrary: [BowEntry] = bowGroup0 + bowGroup1 + bowGroup2 + bowGroup3

func bowBySlug(_ s: String) -> BowEntry { bowLibrary.first { $0.slug == s } ?? bowLibrary[0] }

func ringWord(_ r: RingKind) -> String {
    switch r {
    case .porous: return "Chase one ring"
    case .yew: return "Sapwood back"
    case .bamboo: return "Bamboo skin"
    case .board: return "Sawn board"
    case .composite: return "Sinew back"
    }
}
