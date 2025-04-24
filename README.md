# semantic-lang-gen

Generates Haskell bindings from Tree-sitter grammar. Also automatically
generates typed AST.

## Brief description

While [semantic](https://github.com/github/semantic) can create Tree-sitter
Haskell bindings with types,
[as the authors mentioned](https://github.com/github/semantic/blob/main/docs/adding-new-languages.md),
creating bindings for new languages is laborious. **semantic-lang-gen**
generates Haskell bindings when given just the grammar.js file.

For detailed usage instructions, please refer to
[semantic-lang-gen-example](https://github.com/bglgwyng/semantic-lang-gen-example).
