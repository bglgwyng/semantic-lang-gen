module.exports = grammar({
  name: 'your_language22',

  rules: {
    // The root rule - program consists of multiple statements
    program: $ => repeat($.statement),

    // A statement can be an expression or other statement types
    statement: $ => choice(
      $.expression_statement,
      $.assignment_statement
    ),

    expression_statement: $ => seq(
      $.expression,
      ';'
    ),

    // Assignment statement (e.g., x = 42;)
    assignment_statement: $ => seq(
      field('left', $.identifier),
      '=',
      field('right', $.expression),
      ';'
    ),

    // Expression can be an identifier or literal
    expression: $ => choice(
      $.identifier,
      $.number
    ),

    // Identifier rule (variable names)
    identifier: $ => /[a-zA-Z_][a-zA-Z0-9_]*/,

    // Number literal
    number: $ => /\d+/
  }
});
