import '../domain/learning_bite.dart';

/// Static prototype bites shown in the Home feed.
const mockLearningBites = <LearningBiteData>[
  LearningBiteData(
    bookTitle: 'The Adventures of Sherlock Holmes',
    author: 'Arthur Conan Doyle',
    topic: 'Observation vs. Assumption',
    body:
        'Good observation starts with separating what you actually notice from what you assume it means.',
    keyIdea: 'Notice first. Interpret second.',
    listenDuration: '0:38',
    visual: BiteVisual.observe,
  ),
  LearningBiteData(
    bookTitle: 'Meditations',
    author: 'Marcus Aurelius',
    topic: 'Control What You Can',
    body:
        'You cannot always choose what happens, but you can always choose how you respond to it.',
    keyIdea: 'Focus your energy on what belongs to your control.',
    listenDuration: '0:31',
    visual: BiteVisual.control,
  ),
  LearningBiteData(
    bookTitle: "Alice's Adventures in Wonderland",
    author: 'Lewis Carroll',
    topic: 'Curiosity Changes the Journey',
    body:
        'Wonder opens doors that certainty keeps shut. The path matters as much as the destination.',
    keyIdea: 'Questions can take you somewhere answers cannot.',
    listenDuration: '0:44',
    visual: BiteVisual.wonder,
  ),
];