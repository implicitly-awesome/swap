# Swap

The library that allows you to swap modules implementations in your app.
Very handy for testing purposes. No need to define complex mocks, behaviours, configs...

[CHANGELOG](https://github.com/madeinussr/exop/blob/master/CHANGELOG.md)

_Special thanks to [llxff](https://github.com/llxff) for great advices!_

## Installation

```elixir
def deps do
  [{:swap, "~> 1.1.1"}]
end
```

## Usage

### Global swap

You can define a global swap of modules with a specific module (placed, for example in /lib directory):

```elixir
defmodule DepsContainer do
  use Swap

  # when: can be ommited, an expression should return boolean value
  swap SomeDependency, TestImplementation, when: Mix.env() == :test
  swap SomeDependency, DevImplementation, when: Mix.env() == :dev
  swap SomeDependency, ProdImplementation, when: SomeModule.some_func()
end
```

In this example the first argument module will be replaced with the second argument module in certain environment.
You can define multiple implementations per dependency, as well as multiple environments for a swap.

### Revert swap

```elixir
defmodule Dependency do
  def run, do: "dependency"
end

defmodule Implementation do
  def run, do: "implementation"
end

defmodule Test do
  use Swap

  def call do
    swap Dependency, Implementation

    Dependency.run()
  end

  def call2 do
    revert Dependency

    Dependency.run()
  end
end
```

Here `call/0` function returns `"implementation"` and `call2/0` returns `"dependency"` again.

### Swap for a peace of code

You can swap modules for some peace of code. Just wrap that code into `swap do` block:

```elixir
defmodule Dependency do
  def run, do: "dependency"
end

defmodule Implementation do
  def run, do: "implementation"
end

defmodule Test do
  use Swap

  def call do
    swap Dependency, Implementation do
      Dependency.run()
    end
  end

  def call2, do: Dependency.run()
end
```

Here `call/0` function returns `"implementation"` and `call2/0` returns `"dependency"`.

_For more cases see /test directory ;)_

## Please note

There is no circular dependency check at the moment. Be careful.

## LICENSE

    Copyright © 2018 Andrey Chernykh ( andrei.chernykh@gmail.com )

    This work is free. You can redistribute it and/or modify it under the
    terms of the MIT License. See the LICENSE file for more details.
