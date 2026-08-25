import SwiftUI

struct GuideEntry: Identifiable {
    let slug: String
    let title: String
    let lead: String
    let body: [String]
    var id: String { slug }
    var plate: String { "guide-" + slug }
}

struct ToolEntry: Identifiable {
    let slug: String
    let name: String
    let line: String
    var id: String { slug }
    var plate: String { "tool-" + slug }
}

let guideGroup0: [GuideEntry] = [
    GuideEntry(slug: "grain", title: "Grain and Run Off",
               lead: "The single thing that breaks more bows than any other",
               body: ["Wood is a bundle of fibres. A bow works because those fibres run unbroken from one tip to the other. Where a fibre ends part way along the back, the load has nowhere to go and the wood lifts a splinter there.",
                   "On a split stave the fibres follow the tree and you keep them by following the surface the split gave you. On a sawn board they run wherever the saw put them, and half the boards in a stack have grain running off the face within a foot.",
                   "Look along the edge, not the face. Straight parallel lines the whole length is what you want. Lines that drift across the edge and disappear are run off, and the bow will break where they leave."]),
    GuideEntry(slug: "backring", title: "Chasing a Ring",
               lead: "Removing wood until one growth ring is the whole back",
               body: ["In ring porous woods like osage and locust, each year makes a soft porous layer followed by a dense one. The dense late wood carries the load and the porous early wood is nearly worthless in tension.",
                   "So the back of the bow is made one single ring of late wood, uninterrupted from tip to tip. You take the bark and sapwood off, find a ring you like, and remove everything above it with a drawknife and a scraper.",
                   "Cut through that ring anywhere and you have exposed the porous layer beneath. The bow will lift a splinter at that spot, usually at full draw, usually loudly."]),
    GuideEntry(slug: "rings", title: "Reading Ring Density",
               lead: "Fast grown or slow grown, depending entirely on the wood",
               body: ["For ring porous hardwoods, ash, elm, hickory and osage, fast growth is better. A wide ring is mostly dense late wood with one thin porous layer. Narrow rings are mostly porous layer, and the stave is weak.",
                   "For diffuse porous woods and for yew it is the other way round. Tight slow grown yew from a mountainside makes a far better bow than fast grown valley yew.",
                   "Count the rings across an inch on the end of the stave before you commit. It costs nothing and it tells you what you are holding."]),
    GuideEntry(slug: "floor", title: "Floor Tillering",
               lead: "The first bend, before the bow will take a string at all",
               body: ["Stand the bow on the floor with one tip against your foot and push down on the handle. A stave that has only been roughed out will barely move, and that is the point.",
                   "You are looking for the two limbs to start bending at the same time and by the same amount. Remove wood from the stiff one until they agree.",
                   "Only when both limbs bend a good few inches under hand pressure is the bow safe to put on a long string. Rushing this step is how staves get broken before they are bows."]),
    GuideEntry(slug: "longstring", title: "The Long String",
               lead: "A slack string that lets you see the bend without bracing",
               body: ["A long string is simply a string several inches too long. It puts no brace on the bow, so the limbs are at rest, and the first few inches of draw show you the tiller without straining anything.",
                   "Draw it only far enough to see the curve. Twenty inches on a long string is not a small draw; it is most of the strain of a braced bow at full draw.",
                   "When both limbs bend evenly on the long string to a reasonable distance, the bow is ready to be braced properly for the first time."]),
]

let guideGroup1: [GuideEntry] = [
    GuideEntry(slug: "tree", title: "The Tillering Tree",
               lead: "A post, a cradle and a row of notches",
               body: ["The bow sits in a cradle at the top of a post and the string is pulled down and hooked into a notch. Now you can stand back and look at the whole bend at once, which is impossible while you are holding it.",
                   "The notches are usually two inches apart and a scale beside them gives the draw. A hanging scale or a spring balance on the string gives the weight.",
                   "Step back at least eight feet. Tiller faults are shapes, and shapes are invisible at arm's length."]),
    GuideEntry(slug: "curve", title: "Reading the Curve",
               lead: "Three arcs: right, hinged and stiff",
               body: ["An even arc bends a little everywhere and no part of it works harder than any other. That bow will take the least set and last the longest.",
                   "A hinge is a short section bending much more than its neighbours. It is a soft spot, and every draw makes it softer until it takes a permanent bend or breaks.",
                   "A stiff section does no work, which means the rest of the limb is doing its share as well as its own. Stiff spots near the tip are deliberate on some designs and accidental on most."]),
    GuideEntry(slug: "hinge", title: "Hinges",
               lead: "Once you have made one, it does not come out",
               body: ["A hinge appears where too much wood came off in one place. The section is thinner than its neighbours, so it bends more, so it takes more strain, so it takes set, so it bends more still.",
                   "You cannot fix a hinge by adding wood. The only remedy is to reduce everything around it until the whole limb matches the hinge, which costs draw weight, sometimes a great deal of it.",
                   "This is why you scrape a few strokes and look, rather than a lot of strokes and hope. Twenty light passes and five looks beat one heavy pass every time."]),
    GuideEntry(slug: "set", title: "Set and String Follow",
               lead: "The bend the bow keeps when the string comes off",
               body: ["Unstring a new bow and it will not be as straight as the stave was. That permanent bend is set, and measured against a straight edge at the handle it is called string follow.",
                   "An inch or so is normal and harmless. Three inches means the belly has been overstrained, and the bow will be slow because a great deal of the energy is going into bending wood that never comes back.",
                   "Set comes from working the wood too hard, which usually means the bow is too short, too narrow or too thick for its weight. It also comes from tillering a stave that is not properly dry."]),
    GuideEntry(slug: "nocks", title: "Nocks",
               lead: "Where the string meets the wood, and where tips break",
               body: ["A side nock is a groove cut into the sides of the tip, angled back toward the handle so the string cannot climb out. It leaves the back of the bow untouched, which matters a great deal.",
                   "Never cut a nock groove across the back. It severs the very fibres the whole bow depends on and the tip will fail there.",
                   "Horn or antler nock overlays spread the load and stop the string cutting into the wood. On a heavy bow they are not decoration."]),
]

let guideGroup2: [GuideEntry] = [
    GuideEntry(slug: "brace", title: "Brace Height",
               lead: "How far the string sits from the handle when strung",
               body: ["Too low and the string slaps the arm and the bow is noisy. Too high and the bow is quiet, smooth and slower, because the working part of the draw is shorter.",
                   "Six to seven inches suits most flat wooden bows. A longbow often likes a little less; a recurve usually wants more.",
                   "Change it by twisting the string, a few turns at a time, and listen. The bow will tell you where it wants to sit."]),
    GuideEntry(slug: "weight", title: "Weight and Draw Length",
               lead: "A wooden bow gains about two to three pounds an inch",
               body: ["Draw weight is not a property of the bow alone; it is a property of the bow at a stated draw length. Fifty pounds at twenty eight inches is about forty seven at twenty seven.",
                   "The force draw curve of a straight limbed wooden bow is almost a straight line. Recurves and composites bend the curve upward early and flatten it at the end, which stores more energy for the same peak weight.",
                   "Never draw past the length you tillered for, not even once. The wood has no memory of your intentions, only of the strain."]),
    GuideEntry(slug: "spine", title: "Arrow Spine",
               lead: "The arrow has to bend around the bow, and by the right amount",
               body: ["On release the string pushes the back of the arrow while the front is still still. The shaft buckles sideways, flexes around the handle and straightens in flight. This is the archer's paradox.",
                   "A shaft too stiff for the bow will not flex enough and will kick away from the bow. Too weak and it flexes too far and kicks the other way.",
                   "Spine is measured as deflection under a standard weight over a standard span. Match it to the bow weight and the point weight, and a mediocre bow shoots well."]),
    GuideEntry(slug: "loose", title: "The Loose",
               lead: "Everything the bow does happens in twenty milliseconds",
               body: ["A clean loose is the fingers relaxing rather than opening. The string should push them out of the way; you should not move them out of its way.",
                   "Any sideways push at the moment of release goes straight into the arrow, and at twenty yards a small error at the string is a large one at the target.",
                   "The follow through is not ceremony. Holding position until the arrow lands means you were still while it left.",
                   "grain"]),
]

let guideLibrary: [GuideEntry] = guideGroup0 + guideGroup1 + guideGroup2

let toolLibrary: [ToolEntry] = [
    ToolEntry(slug: "drawknife", name: "Drawknife",
              line: "Pulled toward you with both hands. It removes wood faster than anything else in the shop and it is entirely capable of removing too much."),
    ToolEntry(slug: "spokeshave", name: "Spokeshave",
              line: "A tiny plane with handles. Set the iron fine and it takes shavings you can read a newspaper through."),
    ToolEntry(slug: "rasp", name: "Cabinet Rasp",
              line: "Hand stitched teeth in staggered rows so it cuts without leaving tracks. The coarse side hogs, the fine side finishes."),
    ToolEntry(slug: "scraper", name: "Cabinet Scraper",
              line: "A rectangle of steel with a burnished hook on the edge. It is the last tool a bow sees, and it is what tillering is actually done with."),
    ToolEntry(slug: "gizmo", name: "Tiller Gizmo",
              line: "A block with a pencil sticking through it, run along the limb. Where the limb bends more than the block, the pencil marks it. Nothing else finds a hinge as fast."),
    ToolEntry(slug: "square", name: "Bow Square",
              line: "Clips to the string and reads brace height and nocking point together. Small, cheap, and the difference between guessing and knowing."),
    ToolEntry(slug: "tree", name: "Tillering Tree",
              line: "A post, a cradle and a row of notches two inches apart. Its whole purpose is to let you stand eight feet back and look."),
    ToolEntry(slug: "scale", name: "Spring Scale",
              line: "Hung on the string below the tree. Draw weight is a number, and until you hang a scale on it, it is only an opinion."),
    ToolEntry(slug: "stave", name: "Split Stave",
              line: "Half a log, riven rather than sawn, so the split follows the grain and the grain follows the whole length of the bow."),
    ToolEntry(slug: "arrow", name: "Arrow",
              line: "Shaft, point, nock and three feathers set at a slight helical. Its spine has to suit the bow or the best tiller in the world will not group."),
]
