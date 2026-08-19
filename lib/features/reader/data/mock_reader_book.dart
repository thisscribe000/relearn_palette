import '../domain/reader_book.dart';

/// Static prototype book for the Reader: The Adventures of Sherlock Holmes
/// by Arthur Conan Doyle (public domain), consistent with the book already
/// featured across the app.
const mockReaderBook = ReaderBook(
  title: 'The Adventures of Sherlock Holmes',
  author: 'Arthur Conan Doyle',
  chapters: [
    ReaderChapter(
      title: 'A Scandal in Bohemia',
      paragraphs: [
        'To Sherlock Holmes she is always the woman. I have seldom heard him mention her under any other name. In his eyes she eclipses and predominates the whole of her sex. It was not that he felt any emotion akin to love for Irene Adler. All emotions, and that one particularly, were abhorrent to his cold, precise but admirably balanced mind.',
        'He was, I take it, the most perfect reasoning and observing machine that the world has seen, but as a lover he would have placed himself in a false position. He never spoke of the softer passions, save with a gibe and a sneer. They were admirable things for the observer — excellent for drawing the veil from men’s motives and actions. But for the trained reasoner to admit such intrusions into his own delicate and finely adjusted temperament was to introduce a distracting factor.',
        'Grit in a sensitive instrument, or a crack in one of his own high-power lenses, would not be more disturbing than a strong emotion in a nature such as his. And yet there was but one woman to him, and that woman was the late Irene Adler, of dubious and questionable memory.',
        'I had seen little of Holmes lately. My marriage had drifted us away from each other. My own complete happiness, and the home-centred interests which rise up around the man who first finds himself master of his own establishment, were sufficient to absorb all my attention, while Holmes, who loathed every form of society with his whole Bohemian soul, remained in our lodgings in Baker Street, buried among his old books.',
        'I still continued to visit the rooms occasionally, and I noticed that his habits had altered very little. He still divided his time between music and chemistry, and his face still wore that weary, listless look which had been habitual to him in the days when he studied in his chambers.',
        'One night, however, he was in one of his queer, silent moods, with the yellow light of the lamp upon his pale, hawk-like features. He did not even notice my entrance. I sat down, and the minutes passed without a word.',
        'I knew that the seer was at his work — that some weighty problem had taken hold of his mind. Presently he looked up, and, seeing me, he smiled and nodded toward a chair. “You have been at your practice this morning,” said he, “and I have been at mine.”',
        'He waved his hand toward a little pile of soiled cards and letters upon the table. “You are not aware,” said he, “that there is a king in my chambers?” “What, is this a client?” “No, a visitor — the King of Bohemia.”',
      ],
    ),
    ReaderChapter(
      title: 'The Red-Headed League',
      paragraphs: [
        'I had called upon my friend, Mr. Sherlock Holmes, one day in the autumn of last year, and found him in deep conversation with a very stout, florid-faced, elderly gentleman, with fiery red hair. With an apology for my intrusion, I was about to withdraw when Holmes pulled me abruptly into the room and closed the door behind me.',
        '“You could not possibly have come at a better time, my dear Watson,” he said cordially. “I was afraid that you were engaged.” “So I was. Have you the morning paper?”',
        '“I see,” said Holmes, “that you are thinking of this affair from the point of view of the Red-headed League. What does it suggest to you, Watson?”',
        '“It suggests to me,” I said, “that the league has been dissolved, and that the vacancy which its chairman has spoken of no longer exists.”',
        '“That, I think, is the obvious deduction,” said Holmes. “And yet, I want you to look at the matter from a little different point of view.”',
        'He handed me the paper. “Read that, Watson.” I read the advertisement carefully, and, to my surprise, found that the man’s red hair was the very heart of the matter.',
        '“The whole affair is a curious one,” said Holmes. “It is the strangest case on record — a perfect little comedy of crime.”',
        'He leaned back in his chair, his thin fingers tapping on the armrest, and the yellow light of the lamp deepened the shadows under his eyes. “We have to solve a puzzle, Watson — and I believe the answer is written plainly in red.”',
      ],
    ),
    ReaderChapter(
      title: 'A Case of Identity',
      paragraphs: [
        'My dear fellow," said Sherlock Holmes as we sat on either side of the fire in his lodgings at Baker Street, "life is infinitely stranger than anything which the mind of man could invent. We would not dare to conceive the things which are really mere commonplaces of existence.',
        'If we could fly out of that window hand in hand, hover over this great city, gently remove the roofs, and peep in at the queer things which are going on — the strange coincidences, the plannings, the cross-purposes, the wonderful chains of events — the results would be more wonderful than any fiction.',
        'A client had come to us that morning with a story so singular that even Holmes, who kept his emotions on a tight leash, leaned forward with genuine interest. The detail that mattered, as ever, was a small one that everyone else had walked past.',
        '"The world is full of obvious things," he said at last, "which nobody by any chance ever observes. Where a man of trained observation can help is when the obvious is exactly what has been hidden in plain sight."',
      ],
    ),
    ReaderChapter(
      title: 'The Boscombe Valley Mystery',
      paragraphs: [
        'We were seated at breakfast one morning when the maid announced a visitor who had come by the morning train. He was a man of about forty, with a restless eye and a bearing that spoke of the countryside rather than the city.',
        'The case, he said, had fallen upon him without warning. His father had been found dead in a quiet corner of Boscombe Valley, and the evidence pointed in a direction that he could not, and would not, believe.',
        'Holmes listened without interruption, his fingers pressed together and his gaze fixed on the ceiling. When the story was done he sat for a long minute in silence.',
        '"The strongest point against you," he said finally, "is that the facts, taken at face value, are damning. It is precisely when the circumstances are arranged so conveniently that I begin to doubt them."',
      ],
    ),
  ],
  bites: [
    ReaderBite(
      category: 'OBSERVATION',
      topic: 'Notice first, interpret second.',
      keyIdea: 'LOOK SLOWLY, THEN CONCLUDE.',
      duration: '0:38',
      excerpt:
          'Grit in a sensitive instrument would not be more disturbing than a strong emotion in a nature such as his.',
    ),
    ReaderBite(
      category: 'DEDUCTION',
      topic: 'A fact is a ladder, not a stop.',
      keyIdea: 'FOLLOW THE STEP AFTER THE FACT.',
      duration: '0:42',
      excerpt:
          'The value of a fact is rarely the fact itself, but the step that comes after it.',
    ),
    ReaderBite(
      category: 'ATTENTION',
      topic: 'Small details are loud to trained eyes.',
      keyIdea: 'THE OBVIOUS IS OFTEN OVERLOOKED.',
      duration: '0:35',
      excerpt:
          'The man’s red hair was the very heart of the matter — the detail everyone saw and no one read.',
    ),
  ],
);
