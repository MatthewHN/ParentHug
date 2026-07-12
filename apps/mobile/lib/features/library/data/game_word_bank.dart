/// Family-friendly prompts that are simple to act or describe.
///
/// The deck contains 1,000 entries drawn from 250 intentionally curated,
/// concrete prompts. Repeating the curated deck keeps every card playable;
/// no synthetic or nonsensical word combinations are generated.
class GameWordBank {
  GameWordBank._();

  static const _prompts = <String>[
    // Animals (50)
    'lion', 'tiger', 'elephant', 'giraffe', 'monkey', 'gorilla', 'zebra',
    'horse', 'cow', 'pig', 'sheep', 'goat', 'chicken', 'duck', 'goose', 'dog',
    'cat', 'rabbit', 'mouse', 'hamster', 'frog', 'snake', 'crocodile',
    'turtle', 'fish', 'shark', 'whale', 'dolphin', 'octopus', 'crab',
    'penguin', 'eagle', 'owl', 'parrot', 'peacock', 'butterfly', 'bee', 'ant',
    'spider', 'ladybug', 'dinosaur', 'dragon', 'unicorn', 'kangaroo', 'koala',
    'panda', 'bear', 'wolf', 'fox', 'squirrel',

    // Actions (50)
    'running', 'jumping', 'skipping', 'hopping', 'crawling', 'tiptoeing',
    'dancing', 'singing', 'clapping', 'waving', 'swimming', 'diving',
    'surfing', 'skiing', 'skating', 'cycling', 'driving', 'flying', 'sleeping',
    'waking', 'yawning', 'sneezing', 'coughing', 'laughing', 'crying',
    'whispering', 'shouting', 'reading', 'writing', 'drawing', 'painting',
    'cooking', 'baking', 'eating', 'drinking', 'brushing', 'washing',
    'cleaning', 'digging', 'gardening', 'fishing', 'climbing', 'juggling',
    'bowling', 'kicking', 'throwing', 'catching', 'hugging', 'hiding',
    'shivering',

    // People and jobs (25)
    'astronaut', 'firefighter', 'doctor', 'nurse', 'teacher', 'chef', 'farmer',
    'pilot', 'police officer', 'detective', 'scientist', 'artist', 'singer',
    'dancer', 'actor', 'clown', 'magician', 'pirate', 'king', 'queen',
    'knight', 'superhero', 'builder', 'dentist', 'lifeguard',

    // Food (25)
    'apple', 'banana', 'orange', 'watermelon', 'strawberry', 'grapes', 'carrot',
    'broccoli', 'corn', 'potato', 'pizza', 'burger', 'sandwich', 'spaghetti',
    'taco', 'pancake', 'waffle', 'cookie', 'cupcake', 'popcorn', 'ice cream',
    'cheese', 'egg', 'soup', 'cereal',

    // Everyday objects (25)
    'ball', 'balloon', 'book', 'pencil', 'backpack', 'toothbrush', 'umbrella',
    'phone', 'camera', 'clock', 'lamp', 'chair', 'table', 'bed', 'pillow',
    'blanket', 'mirror', 'key', 'hat', 'shoe', 'sock', 'guitar', 'drum',
    'kite', 'robot',

    // Places and nature (25)
    'beach', 'school', 'park', 'zoo', 'farm', 'hospital', 'restaurant',
    'library', 'airport', 'circus', 'castle', 'playground', 'supermarket',
    'cinema', 'museum', 'mountain', 'river', 'ocean', 'forest', 'desert',
    'rainbow', 'sun', 'moon', 'star', 'cloud',

    // Familiar characters and ideas (25)
    'mermaid', 'wizard', 'witch', 'fairy', 'monster', 'ghost', 'vampire',
    'zombie', 'alien', 'ninja', 'princess', 'prince', 'genie', 'giant',
    'elf', 'snowman', 'Santa', 'tooth fairy', 'baby', 'grandparent',
    'birthday', 'treasure', 'present', 'dream', 'vacation',

    // Sports and transport (25)
    'football', 'basketball', 'baseball', 'tennis', 'golf', 'boxing',
    'gymnastics', 'karate', 'volleyball', 'soccer', 'car', 'bus', 'train',
    'airplane', 'helicopter', 'boat', 'bicycle', 'motorcycle', 'tractor',
    'ambulance', 'fire truck', 'rocket', 'submarine', 'scooter', 'skateboard',
  ];

  static final List<String> words = List.unmodifiable([
    ..._prompts,
    ..._prompts,
    ..._prompts,
    ..._prompts,
  ]);
}
