# Swap

The library that allows you to swap dependencies in your app.
Also it allows you to inject dependencies with function decorator.

[CHANGELOG](https://github.com/madeinussr/exop/blob/master/CHANGELOG.md)

_Special thanks to [llxff](https://github.com/llxff) for great advices!_

## Installation

```elixir
def deps do
  [{:swap, "~> 1.0.0"}]
end
```

## Usage

### Global swap

You can define a global swap of modules with `Swap.Container` (placed, for example in /lib directory):

```elixir
defmodule Container do
  use Swap.Container

  swap SomeDependency, TestImplementation, env: :test
  swap SomeDependency, DevImplementation, env: :dev

  swap AnotherDependency, AnotherImplementation, env: [:dev, :test]
end
```

In this example the first argument module will be replaced with the second argument module in certain environment.
You can define multiple implementations per dependency, as well as multiple environments for a swap.

### Swap for a function

In the example below I show how to swap modules for a certain function:

```elixir
defmodule Dependency do
  def run, do: "dependency"
end  

defmodule Implementation do
  def run, do: "implementation"
end

defmodule Test do
  use Swap

  @decorate swap({Dependency, Implementation})
  def call, do: Dependency.run()

  def call2, do: Dependency.run()
end
```

Here `call/0` function returns `"implementation"` and `call2/0` returns `"dependency"`.

### Swap for a peace of code

Moreover you can swap modules for some peace of code. Just wrap that code into `swap do` block:

```elixir
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

In this example results of `call/1` and `call2/1` invokation will be the same as in the example above.

## LICENSE

    Copyright © 2017 Andrey Chernykh ( andrei.chernykh@gmail.com )

    This work is free. You can redistribute it and/or modify it under the
    terms of the MIT License. See the LICENSE file for more details.
