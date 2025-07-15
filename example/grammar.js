module.exports = grammar({
  name: 'arith',

  extras: $ => [
    /\s/,
  ],

  conflicts: $ => [
    [$._expression, $.binary_expression],
  ],

  rules: {
    source_file: $ => $.expression,

    expression: $ => choice(
      $.binary_expression,
      $.unary_expression,
      $.parenthesized_expression,
      $.identifier,
      $.number
    ),

    binary_expression: $ => {
      const table = [
        [5, choice('*', '/', '%')],  // multiplicative
        [4, choice('+', '-')],       // additive
      ];

      return choice(...table.map(([precedence, operator]) =>
        prec.left(precedence, seq(
          field('left', $._expression),
          field('operator', operator),
          field('right', $._expression),
        )),
      ));
    },

    unary_expression: $ => prec(6, seq(  // unary precedence
      field('operator', choice('+', '-')),
      field('operand', $._expression),
    )),

    parenthesized_expression: $ => seq(
      '(',
      $.expression,
      ')'
    ),

    _expression: $ => choice(
      $.binary_expression,
      $.unary_expression,
      $.parenthesized_expression,
      $.identifier,
      $.number
    ),

    identifier: _ => /[a-zA-Z_][a-zA-Z0-9_]*/,

    number: _ => /\d+(\.\d+)?/,
  },
});