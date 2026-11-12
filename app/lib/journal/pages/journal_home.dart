// SoulDreams Dev's first page (D49 O1; D56): it opens the journal's
// folder on the phone, then shows the journal list. Until the folder is
// open the page is blank; if it cannot be opened it stays blank and logs
// a code, never a night's words (R3).
import 'package:flutter/material.dart';

import '../../core/safe_log.dart';
import '../journal.dart';
import '../journal_files.dart';
import '../journal_store.dart';
import 'journal_page.dart';

class JournalHome extends StatefulWidget {
  const JournalHome({super.key, required this.files});

  final JournalFiles files;

  @override
  State<JournalHome> createState() => _JournalHomeState();
}

class _JournalHomeState extends State<JournalHome> {
  Journal? _journal;

  @override
  void initState() {
    super.initState();
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
