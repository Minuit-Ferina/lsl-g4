
# antlr4-parse LSL.g4 lscript_program -gui C:\Users\vitol\Desktop\LSL-lexer\src\tests\test.lsl

# antlr4 LSL.g4 -Dlanguage=TypeScript -listener -visitor -long-messages -atn

antlr4 LSLParser.g4 LSLLexer.g4 -Dlanguage=TypeScript -listener -visitor -long-messages -o out -lib lib
