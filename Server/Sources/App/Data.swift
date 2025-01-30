import Foundation

var nfts: [NFT] {
    guard let nftJSONData = getNFTs().data(using: .utf8) else {
        print("Unable to read NFTs JSON")
        return []
    }

    do {
        return try JSONDecoder().decode([NFT].self, from: nftJSONData)
    } catch {
        print("Unable to decode NFTs JSON: \(String(describing: error))")
        return []
    }
}

var users: [User] {
    guard let usersJSONData = printUsers().data(using: .utf8) else {
        print("Unable to read Users JSON")
        return []
    }
    
    do {
        return try JSONDecoder().decode([User].self, from: usersJSONData)
    } catch {
        print("Unable to decode Users JSON: \(error.localizedDescription)")
        return []
    }
}

var currencies: [Currency] {
    guard let currenciesJSONData = printCurrencies().data(using: .utf8) else {
        print("Unable to read Currencies JSON")
        return []
    }
    
    do {
        return try JSONDecoder().decode([Currency].self, from: currenciesJSONData)
    } catch {
        print("Unable to decode Currencies JSON: \(error.localizedDescription)")
        return []
    }
}

var profiles: [Profile] = {
    guard let profilesJSONData = getProfiles().data(using: .utf8) else {
        print("Unable to read Profiles JSON")
        return []
    }
    
    do {
        return try JSONDecoder().decode([Profile].self, from: profilesJSONData)
    } catch {
        print("Unable to decode Profiles JSON: \(error.localizedDescription)")
        return []
    }
}()

var readyCollections: [Collection] {
    guard let readyCollectionsJSONData = getCollections().data(using: .utf8) else {
        print("Unable to read ReadyCollections JSON")
        return []
    }
    
    do {
        return try JSONDecoder().decode([Collection].self, from: readyCollectionsJSONData)
    } catch {
        print("Unable to decode ReadyCollections JSON: \(String(describing: error))")
        return []
    }
}

var orders: [Order] = {
    guard let ordersJSONData = getOrders().data(using: .utf8) else {
        print("Unable to read Orders JSON")
        return []
    }
    
    do {
        return try JSONDecoder().decode([Order].self, from: ordersJSONData)
    } catch {
        print("Unable to decode Orders JSON: \(String(describing: error))")
        return []
    }
}()

var payments: [OrderPaymentStatus] {
    guard let paymentsJSONData = getPayments().data(using: .utf8) else {
        print("Unable to read Payments JSON")
        return []
    }
    
    do {
        return try JSONDecoder().decode([OrderPaymentStatus].self, from: paymentsJSONData)
    } catch {
        print("Unable to decode Payments JSON: \(String(describing: error))")
        return []
    }
}

private let collections: [CollectionServer] = [
    CollectionServer(id: 1, name: "Beige", nfts: ["April", "Aurora", "Bimbo", "Biscuit", "Breena", "Buster", "Corbin", "Cupid", "Dingo", "Ellsa", "Finn", "Gus", "Lark", "Lucky", "Melvin", "Nala", "Penny", "Ralph", "Salena", "Simba", "Whisper"], cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Beige.png"),
    CollectionServer(id: 2, name: "Blue", nfts: ["Bonnie", "Clover", "Diana", "Loki", "Ollie"], cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Blue.png"),
    CollectionServer(id: 3, name: "Gray", nfts: ["Arlena", "Bethany", "Big", "Butter", "Chip", "Devin", "Dominique", "Elliot", "Flash", "Grace", "Josie", "Kaydan", "Lanka", "Larson", "Lipton", "Piper", "Rocky", "Tucker", "Zac"], cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Gray.png"),
    CollectionServer(id: 4, name: "Green", nfts: ["Gwen", "Lina", "Melissa"], cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Green.png"),
    CollectionServer(id: 5, name: "Peach", nfts: ["Archie", "Art", "Biscuit", "Daisy", "Nacho", "Oreo", "Pixi", "Ruby", "Susan", "Tater", "Zoe"], cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Peach.png"),
    CollectionServer(id: 6, name: "Pink", nfts: ["Ariana", "Calder", "Cashew", "Charity", "Flower", "Jerry", "Lilo", "Lucy", "Milo", "Moose", "Oscar", "Patton", "Rufus", "Salena"], cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Pink.png"),
    CollectionServer(id: 7, name: "White", nfts: ["Arielle", "Barney", "Iron", "Logan", "Lumpy", "Paddy", "Vulcan"], cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/White.png"),
    CollectionServer(id: 8, name: "Yellow", nfts: ["Florine", "Helga", "Luna", "Mowgli", "Olaf", "Pumpkin", "Willow", "Winnie"], cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Yellow.png"),
    CollectionServer(id: 9, name: "Brown", nfts: ["Bitsy", "Charlie", "Emma", "Iggy", "Rosie", "Stella", "Toast"], cover: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png"),
]

private let nftDescriptions = [
    "A neon-colored cityscape at night.",
    "A 3D model of a mythical creature.",
    "An abstract painting of a fiery sunset.",
    "A surreal landscape featuring floating islands and waterfalls.",
    "A pixelated version of a famous landmark.",
    "A digital portrait of a famous celebrity.",
    "An artistic representation of a meteor shower in outer space.",
    "A minimalist drawing of a bird perched on a tree branch.",
    "An animated gif of a cat playing with a ball of yarn.",
    "A vibrant illustration of a tropical rainforest.",
    "A glitchy video of a dancing robot.",
    "A digital collage of various emojis.",
    "A 3D model of a futuristic car.",
    "An animated gif of a butterfly emerging from its chrysalis.",
    "A surreal portrait of a person with a second face.",
    "A minimalist drawing of a cactus in the desert.",
    "A digital sculpture of a dragon breathing fire.",
    "A pixelated version of the Mona Lisa.",
    "A rainbow-colored unicorn galloping through a field of flowers.",
    "An abstract painting of a city skyline at night.",
    "A digital sculpture of a robot.",
    "A surreal landscape featuring a giant moon and stars.",
    "A minimalist drawing of a tree with changing seasons.",
    "An animated gif of a dog chasing its tail.",
    "A vibrant illustration of a coral reef.",
    "A 3D model of a spaceship.",
    "An artistic representation of a black hole in outer space.",
    "A glitchy video of a glitched-out face.",
    "A digital collage of various memes.",
    "A pixelated version of a famous painting.",
    "A surreal portrait of a person with a third eye.",
    "A minimalist drawing of a mountain range.",
    "A digital sculpture of a lion.",
    "An abstract painting of a stormy sky.",
    "A rainbow-colored butterfly fluttering its wings.",
    "An animated gif of a hamster running in a wheel.",
    "A vibrant illustration of a garden in bloom.",
    "A 3D model of a dragonfly.",
    "An artistic representation of a planet with rings.",
    "A glitchy video of a glitched-out landscape.",
    "A digital collage of various abstract shapes.",
    "A pixelated version of a famous sculpture.",
    "A surreal portrait of a person with a mirrored face.",
    "A minimalist drawing of a beach scene.",
    "A digital sculpture of a tiger.",
    "An abstract painting of a colorful explosion.",
    "A surreal landscape featuring a giant sunflower.",
    "A pixelated version of a famous photograph.",
    "A digital portrait of a historical figure.",
    "An animated gif of a bear fishing.",
    "A vibrant illustration of a jungle.",
    "A 3D model of a phoenix.",
    "An artistic representation of a spiral galaxy.",
    "A glitchy video of a glitched-out animal.",
    "A digital collage of various geometric shapes.",
    "A minimalist drawing of a sunset on the beach.",
    "A surreal portrait of a person with a distorted face.",
    "A pixelated version of a famous artwork.",
    "A rainbow-colored bird flying through the clouds.",
    "An abstract painting of a colorful vortex.",
    "A digital sculpture of a mermaid.",
    "A glitchy video of a glitched-out city.",
    "A minimalist drawing of a starry night sky.",
    "An animated gif of a fish swimming in a bowl.",
    "A digital painting of a dreamy landscape",
    "A 3D model of a futuristic spaceship",
    "An animated gif of a kitten playing with a ball",
    "A pixelated version of a famous monument",
    "A surreal portrait of a person with multiple eyes",
    "A digital collage of various shapes and colors",
    "An abstract painting of a stormy ocean",
    "A minimalist drawing of a bird in flight",
    "A vibrant illustration of a city skyline",
    "A glitchy video of a dancing figure",
    "A digital sculpture of a mythical creature",
    "A surreal landscape featuring floating islands",
    "An animated gif of a flower blooming",
    "A pixelated version of a classic painting",
    "A 3D model of a futuristic building",
    "A minimalist drawing of a tree in the forest",
    "A digital painting of a starry night sky",
    "A vibrant illustration of a tropical jungle",
    "A surreal portrait of a person with a third eye",
    "A digital collage of various patterns and textures",
    "An abstract painting of a fiery sunset",
    "A glitchy video of a person walking on water",
    "A pixelated version of a famous movie scene",
    "A 3D model of a futuristic robot",
    "A minimalist drawing of a butterfly in flight",
    "A digital sculpture of a dragon breathing fire",
    "A surreal landscape featuring floating rocks",
    "An animated gif of a whale diving in the ocean",
    "A vibrant illustration of a mountain range",
    "A digital painting of a colorful flower garden",
    "A minimalist drawing of a cat sleeping",
    "An abstract painting of a vibrant city",
    "A pixelated version of a famous cartoon character",
    "A 3D model of a futuristic car",
    "A surreal portrait of a person with a mask",
    "A digital collage of various objects",
    "A glitchy video of a person jumping over buildings",
    "A vibrant illustration of a desert landscape",
    "A surreal landscape featuring giant mushrooms",
    "An animated gif of a dolphin swimming",
    "A minimalist drawing of a snail",
    "A digital painting of a peaceful countryside",
    "An abstract painting of a chaotic explosion",
    "A pixelated version of a famous video game character",
    "A 3D model of a futuristic motorcycle",
    "A surreal portrait of a person with a halo",
    "A digital sculpture of a griffin",
    "A vibrant illustration of a coral reef",
    "A minimalist drawing of a fish in the water",
    "A glitchy video of a person running in a glitchy world",
    "A surreal landscape featuring giant crystals",
    "An animated gif of a firework display",
    "A pixelated version of a famous album cover",
    "A 3D model of a futuristic aircraft",
    "A digital painting of a beautiful sunset",
    "A minimalist drawing of a mountain goat",
    "An abstract painting of a swirling vortex",
    "A surreal portrait of a person with a snake",
    "A digital collage of various animals",
    "A glitchy video of a person falling through space",
    "A vibrant illustration of a forest in autumn",
    "A surreal landscape featuring a castle in the sky",
    "An animated gif of a bird in flight",
    "A pixelated version of a famous sports moment",
    "A 3D model of a futuristic train",
    "A minimalist drawing of a frog",
    "A stunning digital artwork of a sunset over the ocean",
    "A 3D rendering of a futuristic city skyline",
    "An animated gif of a kitten playing with a ball of yarn",
    "A pixelated depiction of a classic Hollywood movie scene",
    "A surreal portrait of a person with multiple eyes and mouths",
    "A digital collage of various geometric shapes and colors",
    "An abstract painting of a stormy desert landscape",
    "A minimalist drawing of a bird perched on a tree branch",
    "A vibrant illustration of a cityscape at night",
    "A glitchy video of a robot dancing",
    "A digital sculpture of a mythical creature like a unicorn or dragon",
    "A surreal landscape featuring floating islands and waterfalls",
    "An animated gif of a flower blooming and wilting",
    "A pixelated version of a famous artwork like the Mona Lisa",
    "A 3D model of a futuristic car or motorcycle",
    "A minimalist drawing of a tree in a snow-covered forest",
    "A digital painting of a starry night sky over a mountain range",
    "A vibrant illustration of a tropical rainforest with exotic animals",
    "A surreal portrait of a person with a third eye and horns",
    "A digital collage of various textures and patterns like marble and wood",
    "An abstract painting of a fiery explosion",
    "A glitchy video of a person walking on a rainbow-colored bridge",
    "A pixelated version of a famous video game character like Mario or Sonic",
    "A 3D model of a futuristic spaceship or aircraft",
    "A minimalist drawing of a butterfly with intricate patterns",
    "A digital sculpture of a mythical creature like a phoenix or griffin",
    "A surreal landscape featuring floating rocks and crystals",
    "An animated gif of a whale breaching the surface of the ocean",
    "A vibrant illustration of a snow-covered mountain peak",
    "A digital painting of a colorful flower garden in full bloom",
    "A minimalist drawing of a cat sleeping on a windowsill",
    "An abstract painting of a futuristic metropolis",
    "A pixelated version of a famous cartoon character like SpongeBob or Mickey Mouse",
    "A 3D model of a futuristic robot with advanced AI",
    "A surreal portrait of a person with a gas mask and cybernetic implants",
    "A digital collage of various objects like keys and clocks",
    "A glitchy video of a person jumping over skyscrapers",
    "A vibrant illustration of a desert landscape with cacti and sand dunes",
    "A surreal landscape featuring giant mushrooms and plants",
    "An animated gif of a dolphin swimming in the ocean",
    "A minimalist drawing of a snail with intricate details",
    "A digital painting of a peaceful countryside with rolling hills and farmland",
    "An abstract painting of a chaotic explosion of colors",
    "A pixelated version of a famous album cover like The Beatles or Michael Jackson",
    "A 3D model of a futuristic vehicle like a hovercraft or jetpack",
    "A surreal portrait of a person with a halo and wings",
    "A digital sculpture of a creature from mythology like Medusa or the Minotaur",
    "A vibrant illustration of a coral reef with tropical fish",
    "A minimalist drawing of a fish swimming in the water",
    "A glitchy video of a person running in a digital world",
    "A surreal landscape featuring giant crystals and gemstones",
    "An animated gif of a firework display in the night"
]

private let collectionDescriptions = [
    "A collection of rare digital art pieces from up-and-coming artists.",
    "A series of one-of-a-kind NFTs featuring historic moments in sports history.",
    "A collection of virtual trading cards featuring popular characters from movies and TV shows.",
    "A set of limited edition digital stamps featuring famous landmarks from around the world.",
    "A collection of unique 3D sculptures that can be displayed in virtual reality.",
    "A series of NFTs featuring original music compositions from up-and-coming musicians.",
    "A collection of virtual clothing items that can be worn in online games and social networks.",
    "A set of rare NFTs featuring the work of famous street artists from around the world.",
    "A series of digital pet NFTs that can be raised and trained in a virtual world.",
    "A collection of limited edition NFTs featuring the work of world-renowned photographers.",
    "A set of one-of-a-kind digital trading cards featuring rare and exotic animals.",
    "A series of NFTs featuring iconic moments from classic video games.",
    "A collection of virtual real estate NFTs featuring properties in major cities around the world.",
    "A set of limited edition NFTs featuring hand-drawn sketches from famous comic book artists.",
    "A series of NFTs featuring famous quotes from historical figures and pop culture icons.",
    "A collection of rare virtual cars that can be driven in racing games and simulators.",
    "A set of one-of-a-kind NFTs featuring the work of cutting-edge digital artists.",
    "A series of NFTs featuring original short films and animations from talented filmmakers.",
    "A collection of limited edition NFTs featuring the work of famous fashion designers.",
    "A set of virtual sports memorabilia NFTs featuring iconic moments from sports history."
]

private let userDescriptions = [
    "Lover of all things digital art 🎨",
    "NFT collector and enthusiast 🚀",
    "Proud owner of a growing NFT collection 💎",
    "Digital art is the future and I'm here for it 💻",
    "Passionate about supporting emerging artists through NFTs 🔥",
    "Exploring the world of NFTs and loving every minute of it 🌎",
    "Huge fan of the NFT space and its endless possibilities 🙌",
    "NFTs are my new addiction 😍",
    "Always on the hunt for the next great NFT 💪",
    "Fascinated by the intersection of art and blockchain technology 🤔",
    "In awe of the creativity and talent in the NFT community 🤩",
    "Building a diverse NFT collection from all corners of the globe 🌍",
    "The NFT world never ceases to amaze me 🤯",
    "Investing in NFTs for the long haul 💰",
    "NFTs are my way of owning a piece of art history 🎭",
    "Curator of a carefully crafted NFT collection 🎉",
    "Always up for a chat about the latest and greatest in NFTs 🗣️",
    "Supporting artists through NFTs is my passion ❤️",
    "The NFT market is the most exciting thing to happen to art in decades 🎉",
    "Investing in NFTs is not just about the money, it's about supporting artists and their work 🙏",
    "The NFT market is the perfect marriage of art and technology 💻🎨",
    "Passionate about the potential for NFTs to disrupt the art world 💥",
    "Collecting NFTs is like owning a little piece of the future 🚀",
    "Investing in NFTs is not just about the financial gain, it's about being a part of something bigger 🌟",
    "Discovering amazing new artists through NFTs is the best feeling 🤩",
    "Excited to be a part of the NFT revolution 🌟",
    "NFTs are more than just a trend, they are the future 🚀",
    "Building a diverse NFT collection that reflects my personal taste and values 🎨",
    "In love with the endless possibilities of NFTs ❤️",
    "The NFT market is changing the way we think about art and ownership 🎉",
    "Supporting artists through NFTs is a win-win situation 🤝",
    "The NFT market is an exciting and constantly evolving space 🚀",
    "Building a collection of NFTs that tells a story 📚",
    "NFTs are the ultimate form of digital ownership 💻",
    "Investing in NFTs is not just about the art, it's about being a part of a community 🤝",
    "Every NFT in my collection has a special meaning and story behind it 📖",
    "Exploring the NFT world one digital masterpiece at a time 🖼️",
    "Building a collection of NFTs that reflects my personal values and beliefs 🌟",
    "Investing in NFTs is about more than just owning a piece of art, it's about supporting a movement 🚀",
    "Fascinated by the technology behind NFTs and its potential to change the world 🌎",
    "Crypto enthusiast and NFT collector 🚀",
    "Passionate about art and technology 🎨💻",
    "Investor in the future of digital assets 💰",
    "Building a diverse NFT portfolio 🌈",
    "NFTs are the future of ownership and I'm here for it 🙌",
    "Excited to be a part of the NFT revolution 🔥",
    "Artist and collector exploring the world of NFTs 🎨",
    "HODLing my NFTs for the long-term 💪",
    "Exploring the intersection of art and technology 🖥️🎨",
    "NFTs are more than just digital assets, they're a cultural movement 🌎",
    "Collecting NFTs as a form of self-expression and creativity 🌟",
    "Investing in the future of creativity and ownership 💡",
    "Joining the NFT community to support creators and artists 🤝",
    "NFT collector and digital art enthusiast 🖼️",
    "Bridging the gap between art and technology with NFTs 🌉",
    "Proud member of the NFT community 🤘",
    "HODLing my NFTs and watching them grow 📈",
    "Adventurer in the world of NFTs and digital ownership 🌐",
    "Exploring the infinite possibilities of NFTs 🚀",
    "Investing in the future of art and creativity with NFTs 🎨",
    "Collector of rare and unique NFTs 🔍",
    "NFTs are the next frontier in digital ownership and I'm here to explore it 🚀",
    "Building a collection of NFTs that reflect my passions and interests 💖",
    "Excited to see where the NFT market will take us 🌟",
    "NFT collector and lover of all things digital 💻",
    "Investor in the future of creativity and self-expression with NFTs 💡",
    "Building a digital art collection one NFT at a time 🎨",
    "Exploring the potential of NFTs as a new form of art ownership 🤔",
    "NFTs are the future of art and I'm excited to be a part of it 🎨",
    "Digital art collector and NFT enthusiast 💻🖼️",
    "NFTs are revolutionizing the way we think about ownership and creativity 🌟",
    "HODLing my NFTs for a better tomorrow 🚀",
    "Investing in the future of art and technology with NFTs 🌐",
    "Proud member of the NFT community and excited to see where it goes 🤘",
    "Collecting NFTs as a form of self-discovery and exploration 🌟",
    "Exploring the world of NFTs and all they have to offer 🌎",
    "Digital artist and collector of unique NFTs 🎨",
    "Investing in the future of creativity and innovation with NFTs 💡",
    "Building a collection of NFTs that inspire and excite me 🔥",
    "Joining the NFT revolution to support creators and artists 🤝",
    "NFTs are the future of art ownership and I'm here to be a part of it 🎨",
    "Building a diverse NFT portfolio for the long-term 🌈"
]

private let websites = [
    "https://practicum.yandex.ru/backend-developer/",
    "https://practicum.yandex.ru/qa-engineer/",
    "https://practicum.yandex.ru/web/",
    "https://practicum.yandex.ru/cpp/",
    "https://practicum.yandex.ru/qa-automation-engineer-java/",
    "https://practicum.yandex.ru/algorithms/",
    "https://practicum.yandex.ru/middle-frontend/",
    "https://practicum.yandex.ru/middle-python/",
    "https://practicum.yandex.ru/react/",
    "https://practicum.yandex.ru/web-plus/",
    "https://practicum.yandex.ru/python-developer-plus/",
    "https://practicum.yandex.ru/java-developer/",
    "https://practicum.yandex.ru/ycloud/",
    "https://practicum.yandex.ru/go-advanced/",
    "https://practicum.yandex.ru/devops/",
    "https://practicum.yandex.ru/go-advanced/",
    "https://practicum.yandex.ru/qa-automation-web-python/",
    "https://practicum.yandex.ru/android-developer/",
    "https://practicum.yandex.ru/algorithms-interview/",
    "https://practicum.yandex.ru/qa-engineer-plus/",
    "https://practicum.yandex.ru/qa-engineer-bootcamp/",
    "https://practicum.yandex.ru/frontend-bootcamp/",
    "https://practicum.yandex.ru/go-basics/",
    "https://practicum.yandex.ru/start-in-programming/",
    "https://practicum.yandex.ru/async-python/",
    "https://cloud.yandex.ru/training/deploy",
    "https://practicum.yandex.ru/cpp-backend/",
    "https://cloud.yandex.ru/training/devops",
    "https://cloud.yandex.ru/training/devsecops",
    "https://practicum.yandex.ru/python-free/",
    "https://cloud.yandex.ru/training/production",
    "https://practicum.yandex.ru/html-css/",
    "https://practicum.yandex.ru/devops/",
    "https://practicum.yandex.ru/promo/courses/qa-automation-engineer-python",
    "https://practicum.yandex.ru/promo/courses/application-security",
    "https://practicum.yandex.ru/interface-designer/",
    "https://practicum.yandex.ru/graphic-designer/",
    "https://practicum.yandex.ru/visual-presentation/",
    "https://practicum.yandex.ru/commercial-illustrator/",
    "https://practicum.yandex.ru/design-basics-figma/",
    "https://practicum.yandex.ru/product-approach-for-designers/",
    "https://practicum.yandex.ru/promo/courses/profession-designer",
    "https://practicum.yandex.ru/brand-management/",
    "https://practicum.yandex.ru/internet-marketing-start/",
    "https://practicum.yandex.ru/traffic-manager/",
    "https://practicum.yandex.ru/marketplace-manager/",
    "https://practicum.yandex.ru/market-analysis/",
    "https://practicum.yandex.ru/marketing-for-business/",
    "https://practicum.yandex.ru/promo/courses/content-marketer",
    "https://practicum.yandex.ru/promo/courses/email-marketing"
]

func printCreated() -> String {
    "\"createdAt\": \"2023-04-20T02:22:27Z\","
}

func printName(_ name: String) -> String {
    "\"name\": \"" + name + "\","
}

func printImages(collection: String, nft: String) -> String {
    let url1 = url(collection: collection, nft: nft, index: 1)
    let url2 = url(collection: collection, nft: nft, index: 2)
    let url3 = url(collection: collection, nft: nft, index: 3)
    return "\"images\": [" + [url1, url2, url3].joined(separator: ", ") + "],"
}

func url(collection: String, nft: String, index: Int) -> String {
    "\"" + "https://code.s3.yandex.net/Mobile/iOS/NFT/" + collection + "/" + nft + "/" + "\(index).png\""
}

func printRating() -> String {
    "\"rating\": \(Int.random(in: 1...5)),"
}

func printDescription(_ desc: String) -> String {
    "\"description\": \"" + desc + "\","
}

func printPrice() -> String {
    "\"price\": \(String(format: "%.2f", Float.random(in: 0.01...10))),"
}

func printId(_ id: Int) -> String {
    "\"id\": \"\(id)\""
}

func printCover(_ cover: String) -> String {
    "\"cover\": \"" + cover + "\","
}

func printCollectionNft(_ nfts: [String]) -> String {
    "\"nfts\": \(nfts),"
}

func printAuthor(_ collectionId: Int) -> String {
    "\"author\": \"\(collectionId * 3 + 3)\","
}

let userFirstNames = ["Emma", "Olivia", "Ava", "Isabella", "Sophia", "Mia", "Charlotte", "Amelia", "Harper", "Evelyn", "Abigail", "Emily", "Elizabeth", "Mila", "Ella", "Avery", "Sofia", "Camila", "Aria", "Scarlett", "Victoria", "Madison", "Luna", "Grace", "Chloe", "Penelope", "Layla", "Riley", "Nora", "Zoey", "Makayla", "Rosalind", "Beatrice", "Cordelia", "Desdemona", "Juliet", "Lysandra", "Miranda", "Ophelia", "Portia", "Regan", "Rosaline", "Viola", "Liam", "Noah", "Ethan", "William", "James", "Benjamin", "Lucas", "Henry", "Alexander", "Daniel", "Matthew", "Samuel", "Owen", "Elijah", "Jackson", "Michael", "Logan", "Mason", "Sebastian", "Joseph", "David", "Caleb", "John", "Wyatt", "Oliver", "Gabriel", "Ezra", "Nathan", "Isaac", "Nicholas", "Lincoln", "Hunter", "Connor", "Aiden", "Adam", "Cole", "Levi", "Gavin", "Evan", "Jacob", "Anthony", "Luke", "Andrew", "Jasper", "Thomas", "Oscar"
]

let userSurnames = ["Smith", "Johnson", "Brown", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez", "Jones", "Anderson", "Wilson", "Jackson", "Mason", "Hernandez", "Moore", "Taylor", "Anderson", "Thomas", "Jackson", "White", "Harris", "Martin", "Hall", "Adams", "Allen", "Baker", "Bailey", "Butler", "Campbell", "Clark", "Coleman", "Cooper", "Cox", "Cruz", "Edwards", "Flores", "Foster", "Gomez", "Gonzalez", "Gray", "Green", "Griffin", "Hill", "Howard", "Hughes", "James", "Kelly", "Kim"
]

func printUserName() -> String {
    let randomFirstNameIndex = Int.random(in: 0..<userFirstNames.count)
    let randomLastNameIndex = Int.random(in: 0..<userSurnames.count)
    let name = "\(userFirstNames[randomFirstNameIndex]) \(userSurnames[randomLastNameIndex])"
    return "\"name\": \"" + name + "\","
}

func printAvatar() -> String {
    "\"avatar\": \"https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/\(Int.random(in: 1...1000)).jpg\","
}

func printUserWebsite(_ site: String) -> String {
    "\"website\": \"\(site)\","
}

func printUserNFTs(_ userId: Int) -> String {
    if userId == 1 {
        "\"nfts\": [\"1\", \"4\", \"6\", \"8\"],"
    } else if userId == 2 {
        "\"nfts\": [\"2\", \"3\", \"5\", \"7\", \"9\"],"
    } else if userId == 3 {
        "\"nfts\": [\"10\", \"13\", \"25\"],"
    } else if userId == 4 {
        "\"nfts\": [\"11\", \"12\"],"
    } else if userId == 15 {
        "\"nfts\": [\"14\", \"15\", \"16\", \"18\", \"19\", \"20\"],"
    } else if userId == 16 {
        "\"nfts\": [\"21\", \"22\", \"23\"],"
    } else if userId == 17 {
        "\"nfts\": [\"24\", \"26\", \"27\"],"
    } else if userId == 28 {
        "\"nfts\": [\"28\"],"
    } else if userId == 29 {
        "\"nfts\": [\"29\", \"31\", \"35\", \"36\", \"37\", \"38\", \"39\"],"
    } else if userId == 30 {
        "\"nfts\": [\"30\", \"32\"],"
    } else if userId == 31 {
        "\"nfts\": [\"33\", \"34\"],"
    } else if userId == 42 {
        "\"nfts\": [\"40\", \"41\", \"42\", \"44\", \"45\", \"46\", \"47\", \"48\", \"49\"],"
    } else if userId == 43 {
        "\"nfts\": [\"43\", \"50\", \"52\", \"56\", \"57\", \"58\"],"
    } else if userId == 44 {
        "\"nfts\": [\"51\", \"53\", \"54\", \"55\"],"
    } else if userId == 55 {
        "\"nfts\": [\"59\", \"60\", \"61\", \"62\", \"63\", \"64\", \"65\", \"66\", \"67\", \"70\"],"
    } else if userId == 57 {
        "\"nfts\": [\"82\"],"
    } else if userId == 68 {
        "\"nfts\": [\"83\", \"84\", \"85\", \"86\", \"87\"],"
    } else if userId == 69 {
        "\"nfts\": [\"88\", \"89\", \"90\", \"91\", \"92\"],"
    } else {
        "\"nfts\": [],"
    }
}

func printUserRating(_ id: Int) -> String {
    "\"rating\": \"\((177 - id) % 100 + 1)\","
}

func printUsers() -> String {
    let userCount = 100
    var result = String()
    result += "["
    for userId in 1...userCount {
        result += "{"
        result += printUserName()
        result += printAvatar()
        result += printDescription(userDescriptions[userId % userDescriptions.count])
        result += printUserWebsite(websites[userId % websites.count])
        result += printUserNFTs(userId)
        result += printUserRating(userId)
        result += printId(userId)
        if userId == userCount {
            result += "}"
        } else {
            result += "},"
        }
    }
    result += "]"
    return result
}

private func getPayments() -> String {
    """
    [
        {
            "success": true,
            "id": "1",
            "orderId": "1"
        },
        {
            "success": false,
            "id": "2",
            "orderId": "1"
        },
        {
            "success": true,
            "id": "3",
            "orderId": "1"
        },
        {
            "success": true,
            "id": "4",
            "orderId": "1"
        },
        {
            "success": false,
            "id": "5",
            "orderId": "1"
        },
        {
            "success": false,
            "id": "6",
            "orderId": "1"
        },
        {
            "success": false,
            "id": "7",
            "orderId": "1"
        },
        {
            "success": false,
            "id": "8",
            "orderId": "1"
        }
    ]
    """
}

private func printCurrencies() -> String {
    """
    [
        {
            "title": "Bitcoin",
            "name": "BTC",
            "image": "https://code.s3.yandex.net/Mobile/iOS/Currencies/Bitcoin_(BTC).png",
            "id": "1"
        },
        {
            "title": "Dogecoin",
            "name": "DOGE",
            "image": "https://code.s3.yandex.net/Mobile/iOS/Currencies/Dogecoin_(DOGE).png",
            "id": "2"
        },
        {
            "title": "Tether",
            "name": "USDT",
            "image": "https://code.s3.yandex.net/Mobile/iOS/Currencies/Tether_(USDT).png",
            "id": "3"
        },
        {
            "title": "Apecoin",
            "name": "APE",
            "image": "https://code.s3.yandex.net/Mobile/iOS/Currencies/ApeCoin_(APE).png",
            "id": "4"
        },
        {
            "title": "Solana",
            "name": "SOL",
            "image": "https://code.s3.yandex.net/Mobile/iOS/Currencies/Solana_(SOL).png",
            "id": "5"
        },
        {
            "title": "Ethereum",
            "name": "ETH",
            "image": "https://code.s3.yandex.net/Mobile/iOS/Currencies/Ethereum_(ETH).png",
            "id": "6"
        },
        {
            "title": "Cardano",
            "name": "ADA",
            "image": "https://code.s3.yandex.net/Mobile/iOS/Currencies/Cardano_(ADA).png",
            "id": "7"
        },
        {
            "title": "Shiba Inu",
            "name": "SHIB",
            "image": "https://code.s3.yandex.net/Mobile/iOS/Currencies/Shiba_Inu_(SHIB).png",
            "id": "8"
        }
    ]
    """
}

private func getCollections() -> String {
    var nftId = 1
    var result = String()
    result += "["
    for collection in collections {
        result += "{"
        result += printCreated()
        result += printName(collection.name)
        result += printCover(collection.cover)
        result += printCollectionNft(Array(nftId...nftId + collection.nfts.count - 1).map(String.init))
        result += printDescription(collectionDescriptions[collection.id % collectionDescriptions.count])
        result += printAuthor(collection.id)
        result += printId(collection.id)
        if collection.id == collections.last!.id {
            result += "}"
        } else {
            result += "},"
        }
        nftId += collection.nfts.count
    }
    result += "]"
    return result
}

private func getNFTs() -> String {
    var id = 1
    var result = String()
    result += "["
    for collection in collections {
        for nft in collection.nfts {
            result += "{"
            result += printCreated()
            result += printName(nft)
            result += printImages(collection: collection.name, nft: nft)
            result += printRating()
            result += printDescription(nftDescriptions[id % nftDescriptions.count])
            result += printPrice()
            result += printAuthor(collection.id)
            result += printId(id)
            if collection.id == collections.last!.id && collection.nfts.last == nft {
                result += "}"
            } else {
                result += "},"
            }
            id += 1
        }
    }
    result += "]"
    return result
}

private func getProfiles() -> String {
    """
    [
        {
            "name": "Студентус Практикумус",
            "avatar": "https://code.s3.yandex.net/landings-v2-ios-developer/space.PNG",
            "description": "Прошел 5-й спринт, и этот пройду",
            "website": "https://practicum.yandex.ru/ios-developer/",
            "nfts": ["68", "69", "71", "72", "73", "74", "75", "76", "77", "78", "79", "80", "81"],
            "likes": ["5", "13", "19", "26", "27", "33", "35", "39", "41", "47", "56", "66"],
            "id": "1"
        }
    ]
    """
}

private func getOrders() -> String {
    """
    [
        {
            "nfts": ["93", "94", "95"],
            "id": "1"
        }
    ]
    """
}
