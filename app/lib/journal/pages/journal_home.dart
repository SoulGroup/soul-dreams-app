// SoulDreams Dev's first page (D49 O1; D56): it opens the journal's
// folder on the phone, then shows the journal list. Until the folder is
// open the page is blank; if it cannot be opened it stays blank and logs
// a code, never a night's words (R3). A phone check it is handed (D65)
// finishes first, so its probe never shows as a row.
import 'package:flutter/material.dart';

import '../../core/safe_log.dart';
import '../journal.dart';
import '../journal_files.dart';
import '../journal_store.dart';
import 'journal_page.dart';

class JournalHome extends StatefulWidget {
  const JournalHome({super.key, required this.files, this.after});

  final JournalFiles files;

  /// A phone check (D49 c) to wait for before the folder is opened and the
  /// list loaded. Whether it passed or threw, the list follows.
  final Future<Object?>? after;

  @override
  State<JournalHome> createState() => _JournalHomeState();
}

class _JournalHomeState extends State<JournalHome> {
  Journal? _journal;

  @override
  void initState() {
    super.initState();
    _open();
  }

  Future<void> _open() async {
    try {
      await widget.after;
    } on Object {
      // The check logs its own result; the list does not depend on it.
    }
    JournalStore.open(widget.files).then((store) {
      if (mounted) setState(() => _journal = Journal(store));
    }, onError: (Object _) => SafeLog.event(LogEvent.journalOpenFailed));
  }

  @override
  Widget build(BuildContext context) {
    final journal = _journal;
    return journal == null ? const Scaffold() : JournalPage(journal: journal);
  }
}
