defmodule SwapTest do
  use ExUnit.Case, async: true
  use Swap

  defmodule ModuleA do
    def call, do: "module A"

    def call2, do: "module A2"
  end

  defmodule ModuleB do
    def call, do: "module B"
  end

  test "swaps ModuleA with ModuleB and reverts it" do
    swap(ModuleA, ModuleB)
    assert ModuleA.call() == ModuleB.call()

    revert(ModuleA)
    assert ModuleA.call() != ModuleB.call()
  end

  test "swaps ModuleA with ModuleB only for a block" do
    assert ModuleA.call() != ModuleB.call()

    block_result = swap(ModuleA, ModuleB) do
      ModuleA.call()
    end

    assert block_result == ModuleB.call()
    assert ModuleA.call() != ModuleB.call()
  end

  test "raises an error if a func wasnt defined in a 'swapper' module" do
    swap(ModuleA, ModuleB)

    assert_raise RuntimeError, "call2/0 is not defined in Elixir.SwapTest.ModuleB", fn ->
      ModuleA.call2()
    end

    revert(ModuleA)
    assert ModuleA.call() != ModuleB.call()
  end
end
