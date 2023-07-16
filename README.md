# Chatgpt_grammar_checker
DIY grammar checker with ChatGPT, Powershell and Autohotkey

## Read the blog:

https://anyfactor.io/posts/chatgpt_grammar_checker/

## Needed

- AHK and Powershell
- Modifty ahk script with path to PS1 script
- In PS1 script add your ChatGPT token

## How does it work:

- First, select the text and then press F8.
- After that, my AHK script is triggered.
- AHK runs ctrl+c to copy the selected text.
- It stores the selected text in the variable `input_prompt`.
- Then the PowerShell script is triggered via `cmd`.
- The PowerShell script takes the content from the clipboard.
- It then calls the ChatGPT API with the prompt: "Fix the grammar errors and at the end list out the mistakes made: {text}".
- It then receives the results and stores them to the clipboard.
- In AHK, we show the input prompt and the result prompt.
- The clipboard contains the result prompt as well.
- Then just paste the grammar-corrected statement.

