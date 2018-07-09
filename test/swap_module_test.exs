defmodule SwapModuleTest do
  @moduledoc """
  In this test we swap modules with specific module (swapper).
  """

  use ExUnit.Case, async: true

  defmodule ModuleA do
    def call(), do: "module A"
  end

  defmodule ModuleB do
    def call(), do: "module B"
  end

  defmodule ModuleC do
    def call(), do: "module C"
  end

  defmodule Cond do
    def swap?(), do: true
  end

  defmodule Swapper do
    use Swap

    swap(ModuleA, ModuleB, when: Cond.swap?())
    swap(ModuleC, ModuleB, when: not Cond.swap?())
  end

  test "swaps ModuleA with ModuleB" do
    assert ModuleA.call() == ModuleB.call()
  end

  test "doesnt swap ModuleC with ModuleB" do
    assert ModuleC.call() != ModuleB.call()
  end
end
