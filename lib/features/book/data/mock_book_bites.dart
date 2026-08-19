import '../../home/domain/library_book.dart';
import '../domain/book_bite.dart';
import 'mock_book_details.dart';

/// The canonical book whose bites are fully written out. Stays in sync with
/// the Reader prototype and the featured Library book.
const _sherlockTitle = 'The Adventures of Sherlock Holmes';

/// Twelve real learning bites for the featured Sherlock book — three drawn
/// from each of its four chapters, so the full-screen experience has a
/// meaningful arc to swipe through.
const sherlockLearningBites = <BookBite>[
  // Chapter 1 — A Scandal in Bohemia
  BookBite(
    id: '${_sherlockTitle}_0_1',
    bookTitle: _sherlockTitle,
    chapterIndex: 0,
    chapterTitle: 'A Scandal in Bohemia',
    category: 'OBSERVATION',
    title: 'Notice first, interpret second.',
    explanation:
        'Holmes greets Watson by reading the morning on his shoes — the polish '
        'on the toe, the scrape on the leather. There is nothing mystical about '
        'it: what you collect before you conclude decides everything that '
        'follows.',
    keyIdea: 'LOOK SLOWLY, THEN CONCLUDE.',
  ),
  BookBite(
    id: '${_sherlockTitle}_0_2',
    bookTitle: _sherlockTitle,
    chapterIndex: 0,
    chapterTitle: 'A Scandal in Bohemia',
    category: 'TEMPERAMENT',
    title: 'A strong feeling can crack a fine instrument.',
    explanation:
        'To Holmes, emotion is grit in a sensitive lens — it distorts exactly '
        'what he needs to stay clean. Yet the one woman who outwits him keeps '
        'the name "the woman," which is its own confession of how much we prize '
        'a worthy match.',
    keyIdea: 'FEEL THE ROOM, THEN DECIDE IN QUIET.',
  ),
  BookBite(
    id: '${_sherlockTitle}_0_3',
    bookTitle: _sherlockTitle,
    chapterIndex: 0,
    chapterTitle: 'A Scandal in Bohemia',
    category: 'HUMILITY',
    title: 'The best reader can meet their match.',
    explanation:
        'Irene Adler reads the reader: she expects Holmes before he arrives and '
        'turns the trap back on him. Holmes keeps the photograph but keeps the '
        'lesson too — and, rare for a man of method, admits it out loud.',
    keyIdea: 'LOSING ONE HEAT CAN WIN THE LESSON.',
  ),

  // Chapter 2 — The Red-Headed League
  BookBite(
    id: '${_sherlockTitle}_1_1',
    bookTitle: _sherlockTitle,
    chapterIndex: 1,
    chapterTitle: 'The Red-Headed League',
    category: 'ATTENTION',
    title: 'Small details are loud to trained eyes.',
    explanation:
        'Every man in London can see red hair. Only one man notices what the '
        'advertisement is really doing with it. The mischief hides not in the '
        'exotic but in the everyday thing everyone has already stepped past.',
    keyIdea: 'WHAT EVERYONE SAW, NO ONE READ.',
  ),
  BookBite(
    id: '${_sherlockTitle}_1_2',
    bookTitle: _sherlockTitle,
    chapterIndex: 1,
    chapterTitle: 'The Red-Headed League',
    category: 'DEDUCTION',
    title: 'A fact is a ladder, not a stop.',
    explanation:
        'Watson concludes the league is dissolved; Holmes agrees and climbs '
        'past the answer. If the scheme\'s only purpose is keeping a clerk in '
        'his shop, then the real target is the shop — the fact is a floor, not '
        'the roof.',
    keyIdea: 'FOLLOW THE STEP AFTER THE FACT.',
  ),
  BookBite(
    id: '${_sherlockTitle}_1_3',
    bookTitle: _sherlockTitle,
    chapterIndex: 1,
    chapterTitle: 'The Red-Headed League',
    category: 'CURIOSITY',
    title: 'Absurd generosity usually has a quiet rent.',
    explanation:
        'A league pays a man handsomely to copy an encyclopedia — pointless '
        'work, generous pay. A scheme only makes sense when read backwards: '
        'every kindness is a door somebody is glad to have you watch.',
    keyIdea: 'NOTHING IS FREE WITH A PRICE HIDDEN.',
  ),

  // Chapter 3 — A Case of Identity
  BookBite(
    id: '${_sherlockTitle}_2_1',
    bookTitle: _sherlockTitle,
    chapterIndex: 2,
    chapterTitle: 'A Case of Identity',
    category: 'STRANGENESS',
    title: 'Life out-crafts any invention.',
    explanation:
        'If you could lift the roofs and hover over the city, Holmes argues, '
        'the ordinary would outdo any fiction. The cure for a jaded mind is not '
        'a far country; it is curiosity about the street outside the window.',
    keyIdea: 'REALITY IS THE SHARPER NOVELIST.',
  ),
  BookBite(
    id: '${_sherlockTitle}_2_2',
    bookTitle: _sherlockTitle,
    chapterIndex: 2,
    chapterTitle: 'A Case of Identity',
    category: 'DISGUISE',
    title: 'Every mask keeps a receipt.',
    explanation:
        'A man wears a false voice and a forced walk so well that only Holmes '
        'finds the seams. All acting leaves a trace in the details we forget to '
        'manage — which is exactly where a watcher goes looking.',
    keyIdea: 'THE PERFORMANCE ALWAYS SIGNS ITS NAME.',
  ),
  BookBite(
    id: '${_sherlockTitle}_2_3',
    bookTitle: _sherlockTitle,
    chapterIndex: 2,
    chapterTitle: 'A Case of Identity',
    category: 'TRUST',
    title: 'The obvious is the last place we check.',
    explanation:
        'People rarely lie in the big things; they lie inside the story that '
        'seems too normal to question. The truth here sits in the assumption '
        'everyone else was too polite to inspect.',
    keyIdea: 'HIDE IT IN PLAIN SIGHT, AND NO ONE LOOKS.',
  ),

  // Chapter 4 — The Boscombe Valley Mystery
  BookBite(
    id: '${_sherlockTitle}_3_1',
    bookTitle: _sherlockTitle,
    chapterIndex: 3,
    chapterTitle: 'The Boscombe Valley Mystery',
    category: 'EVIDENCE',
    title: 'The ground testifies when no one will.',
    explanation:
        'There is no witness and no weapon, but the valley keeps a story — the '
        'soil, the boot, the tree, the angle of the fall. A patient reader lets '
        'the scene take the stand before asking people to talk.',
    keyIdea: 'LET THE SCENE SPEAK FOR ITSELF.',
  ),
  BookBite(
    id: '${_sherlockTitle}_3_2',
    bookTitle: _sherlockTitle,
    chapterIndex: 3,
    chapterTitle: 'The Boscombe Valley Mystery',
    category: 'DOUBT',
    title: 'Tidy facts deserve a second look.',
    explanation:
        'The case against the accused is damning and, to Holmes\'s eye, '
        'uncomfortably neat. Convenience is a kind of theatre; he listens for '
        'the story the tidy facts prefer not to tell.',
    keyIdea: 'WHEN EVERYTHING LINES UP, INSPECT THE LINES.',
  ),
  BookBite(
    id: '${_sherlockTitle}_3_3',
    bookTitle: _sherlockTitle,
    chapterIndex: 3,
    chapterTitle: 'The Boscombe Valley Mystery',
    category: 'MOTIVE',
    title: 'Ask who stayed quiet while the crowd pointed.',
    explanation:
        'An old wrong resurfaces in the valley, and justice, revenge, and love '
        'arrive wearing the same coat. Readers of people turn to motive last; '
        'detectives get there first.',
    keyIdea: 'MOTIVE IS THE LAST PAGE AND THE FIRST QUESTION.',
  ),
];

/// Learning bites for any library book. The featured title returns the twelve
/// written-out bites above; the others get one prototype placeholder per
/// chapter so the experience works end-to-end for every shelf book.
List<BookBite> bookBitesFor(LibraryBook book) {
  if (book.title == _sherlockTitle) return sherlockLearningBites;

  final chapters = bookDetailFor(book.title).chapters;
  return [
    for (var i = 0; i < chapters.length; i++)
      BookBite(
        id: '${book.title}_$i',
        bookTitle: book.title,
        chapterIndex: i,
        chapterTitle: chapters[i],
        category: 'READING',
        title: 'Short ideas from ${book.title}',
        keyIdea: 'FULL BITES ARE BEING PREPARED',
        explanation:
            'Prototype content. In the full build, learning bites are generated '
            'from the passages of this book.',
      ),
  ];
}
