return {
  TestCode = [[Write some test cases for the following code, only return the test cases.
    Give the code content directly, do not use code blocks or other tags to wrap it.]],
  DocString = [[You are an AI programming assistant. You need to write a really good docstring that follows a best practice for the given language.

Your core tasks include:
- parameter and return types (if applicable).
- any errors that might be raised or returned, depending on the language.

You must:
- Place the generated docstring before the start of the code.
- Follow the format of examples carefully if the examples are provided.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.]],
  WordTranslate = "Translate the following text to Chinese, please only return the translation",
  CodeExplain = "Explain the following code, please only return the explanation, and answer in Chinese",
  CommitMsg = function()
    return string.format(
      [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:
1. Start with an action verb (e.g., feat, fix, refactor, chore, etc.), followed by a colon.
2. Briefly mention the file or module name that was changed.
3. Describe the specific changes made.

Examples:
- feat: update common/util.py, added test cases for util.py
- fix: resolve bug in user/auth.py related to login validation
- refactor: optimize database queries in models/query.py

Based on this format, generate appropriate commit messages. Respond with message only. DO NOT format the message in Markdown code blocks, DO NOT use backticks:

```diff
%s
```
]],
      vim.fn.system("git diff --no-ext-diff --staged")
    )
  end,
}
