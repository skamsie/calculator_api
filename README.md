# Calculator API

[![CI](https://github.com/skamsie/calculator_api/actions/workflows/ci.yml/badge.svg)](https://github.com/skamsie/calculator_api/actions/workflows/ci.yml)


### MOQO coding challenge (The calculator)

```
Task “The Calculator”

Write a small web-service which offers the following functionality: for a given arithmetic
expression (Integer Numbers and the operators +-*/), the service should respond to the
result of the expression.

The request will be using GET, providing the parameter “expression”, e.g.
  ● curl “http://calculator?expression=3*4”
The response format should be JSON and including two keys:
  ● expression: [echo the given expression]
  ● result: [computed result of the expression]

Any (plausible) way of getting a correct result is fine
Of course our service should be secure (and fast if possible)
If you want to support more than the basic operations, feel free to have them in as well ;)
```

### Run the server

```sh
# the usual way
$ bundle install
$ bundle exec rails server

# or with docker
docker run -it --rm \
  -p 3000:3000 \
  -v "$(pwd)":/rails \
  --entrypoint="" \
  -e RAILS_ENV=development \
  calculator_api:dev \
  bundle exec rails server -b 0.0.0.0

# try to send a request:
$ curl -G --data-urlencode "expression=100/44+11" http://localhost:3000/calculator
{ "expression": "100 / 44 + 11", "result": 13.27 }
```

### Notes on implementation

- **framework:** For this task I could have used a lighter framework like Sinatra or Roda, but since the challenge is for a Ruby on Rails position I decided for a minimal rails 7 api application to basically showcase how I am working as a RoR developer (for example using the service objects design pattern).
- **calculator:** There are many gems that would have easily solved the 'calculator' part, for example [dentaku](https://github.com/rubysolo/dentaku), but I felt I would be avoiding a big bulk of the task by using it, same for using `eval`. For the alghoritm (solving the operator precedence) I took much of the inspiration from the python alghoritm [here](https://github.com/doocs/leetcode/blob/main/solution/0200-0299/0227.Basic%20Calculator%20II/README_EN.md#python3)
- **BigDecimal:** Because `BigDecimal` ensures precise decimal and large‐integer arithmetic without floating‐point rounding errors.
- **specs & linter:** No app would be complete without specs and a linter, so I added those as well :) 
