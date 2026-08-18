import '../domain/learning_bite.dart';

/// Static prototype bites shown in the Home feed.
const mockLearningBites = <LearningBiteData>[
  LearningBiteData(
    category: 'OBSERVATION',
    bookTitle: 'The Adventures of Sherlock Holmes',
    author: 'Arthur Conan Doyle',
    topic: 'What do you actually see?',
    body:
        'Good observation starts with separating what you actually notice from what you assume it means.',
    keyIdea: 'NOTICE FIRST. INTERPRET SECOND.',
    listenDuration: '0:38',
    visual: BiteVisual.observe,
    passageLines: [
      'I see no more than you,',
      'but I have trained myself',
      'to notice what I see.',
    ],
    activeLineIndex: 1,
  ),
  LearningBiteData(
    category: 'CONTROL',
    bookTitle: 'Meditations',
    author: 'Marcus Aurelius',
    topic: 'Control what you can.',
    body:
        'A storm does not ask your permission, but it cannot take your judgement. Spend your energy on what is yours, and let the rest pass without a verdict.',
    keyIdea: 'STRAIN WHERE YOUR INFLUENCE LIVES.',
    listenDuration: '0:37',
    visual: BiteVisual.control,
    passageLines: [
      'You have power over your mind',
      'not outside events.',
      'Realize this, and you will find strength.',
    ],
    activeLineIndex: 1,
  ),
  LearningBiteData(
    category: 'CURIOSITY',
    bookTitle: "Alice's Adventures in Wonderland",
    author: 'Lewis Carroll',
    topic: 'Stay curious, not comfortable.',
    body:
        'Alice follows a rabbit down a hole with no map and no guarantee of return. The detours are where the learning actually happens.',
    keyIdea: 'QUESTIONS CAN OUTRUN ANSWERS.',
    listenDuration: '0:45',
    visual: BiteVisual.wonder,
    passageLines: [
      'Alice had begun to think',
      'that very few things indeed',
      'were really impossible.',
    ],
    activeLineIndex: 2,
  ),
  LearningBiteData(
    category: 'COURAGE',
    bookTitle: 'The Alchemist',
    author: 'Paulo Coelho',
    topic: 'Fear is the only obstacle.',
    body:
        'Most dreams end not at obstacles, but at the hesitation before them. Act, and the desert stops being a wall and becomes a road.',
    keyIdea: 'FEAR SHRINKS WHEN YOU WALK TOWARD IT.',
    listenDuration: '0:40',
    visual: BiteVisual.observe,
    passageLines: [
      'The road feels impossible',
      'until you take the first step',
      'and fear loses its shape.',
    ],
    activeLineIndex: 1,
  ),
  LearningBiteData(
    category: 'ATTENTION',
    bookTitle: 'The Little Prince',
    author: 'Antoine de Saint-Exupéry',
    topic: 'What is essential is invisible.',
    body:
        'The fox tells the prince that what makes his rose his is the time spent on it. Meaning and trust do not photograph well.',
    keyIdea: 'CARE IS WHAT MAKES A THING YOURS.',
    listenDuration: '0:36',
    visual: BiteVisual.wonder,
    passageLines: [
      'It is the time',
      'you have wasted for your rose',
      'that makes your rose so important.',
    ],
    activeLineIndex: 1,
  ),
  LearningBiteData(
    category: 'STRATEGY',
    bookTitle: 'The Art of War',
    author: 'Sun Tzu',
    topic: 'Know yourself first.',
    body:
        'A general who knows the enemy but not his own army is half-lost. Advantage is rarely magic; it is better information.',
    keyIdea: 'EVERY REVERSAL BEGINS WITH A BLIND SPOT.',
    listenDuration: '0:38',
    visual: BiteVisual.control,
    passageLines: [
      'If you know the enemy',
      'and know yourself,',
      'you need not fear the result.',
    ],
    activeLineIndex: 1,
  ),
  LearningBiteData(
    category: 'SOCIETY',
    bookTitle: 'Sapiens',
    author: 'Yuval Noah Harari',
    topic: 'Stories build civilizations.',
    body:
        'Ten thousand strangers can cooperate on a scale no family could, because they believe the same fiction: money, nations, companies.',
    keyIdea: 'SHARED BELIEF OUT-RUNS SHARED BLOOD.',
    listenDuration: '0:41',
    visual: BiteVisual.wonder,
    passageLines: [
      'Strangers begin to move together',
      'when they trust the same story',
      'more than they know each other.',
    ],
    activeLineIndex: 1,
  ),
  LearningBiteData(
    category: 'WEALTH',
    bookTitle: 'The Psychology of Money',
    author: 'Morgan Housel',
    topic: 'Wealth is quiet.',
    body:
        'Spending is what people see; saving is what they do not. Wealth grows in silence, compounded by time and restraint.',
    keyIdea: 'WHAT YOU KEEP OUTLASTS WHAT YOU EARN.',
    listenDuration: '0:39',
    visual: BiteVisual.observe,
    passageLines: [
      'What looks rich is often spending.',
      'What becomes wealth',
      'is usually kept out of sight.',
    ],
    activeLineIndex: 2,
  ),
];
