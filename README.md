# CourseNotes

Course notes written in Typst, organized by course. Shared formatting is defined in
[`common/style.typ`](common/style.typ).

## Compilation

Requires Typst and Git LFS. Image assets are stored with Git LFS; retrieve them after
cloning:

```sh
git lfs pull
```

From the repository root, compile a note by replacing the input and output paths:

```sh
typst compile --root . path/to/note.typ path/to/note.pdf
```

Generated PDFs are ignored by Git.
