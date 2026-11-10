# The files the import may copy (docs/workflow.md, "Imports"; D32 Q5).
# One row per file: its path in the documents repository, its path in
# this repository, and its kind (importer.KINDS). Anything not listed
# here is refused. The owner gave the documents paths (D35); Task 2a
# filled them in.
ROWS = (
    ('product/technology-handover.md', 'docs/source/technology-handover.md', 'copy'),
    ('product/main-path.md', 'docs/source/main-path.md', 'copy'),
    ('product/how-the-ai-appears.md', 'docs/source/how-the-ai-appears.md', 'copy'),
    ('product/design-system.md', 'docs/source/design-system.md', 'copy'),
    ('product/experience-map.md', 'docs/source/experience-map.md', 'copy'),
    ('product/product-and-design-principles.md', 'docs/source/product-principles.md', 'copy'),
    ('interpretation/requirements-list.md', 'docs/source/requirements-list.md', 'copy'),
    ('interpretation/tester-disclosure-specification.md',
     'docs/source/tester-disclosure-specification.md', 'copy'),
    ('interpretation/change-record.md', 'docs/source/interpretation-change-record.md', 'copy'),
    ('product/product-change-record.md', 'docs/source/product-change-record.md', 'copy'),
    ('technology/technology-change-record.md', 'docs/source/technology-change-record.md', 'copy'),
    ('technology/technical-answers.md', 'docs/source/technical-answers.md', 'copy'),
    ('product/places-register.csv', 'app/assets/words/places-register.csv', 'words'),
    ('product/founder-lists-for-technology.md',
     'app/assets/words/founder-lists-for-technology.md', 'lists'),
)
