defmodule SwapWholeTest do
  use ExUnit.Case, async: true
  use Swap.Container

  defmodule NewDep do
    def call, do: "NewDep"
  end

  defmodule NewDep2 do
    def call, do: "NewDep2"
  end

  setup do
    swap Test.Dependency, NewDep

    on_exit(fn() -> revert Test.Dependency end)
  end

  test "swaps a dependency for the whole test" do
    assert Test.TestModule.call() == NewDep.call()
  end

  describe "when swaps in a describe section" do
    setup do
      swap Test.Dependency, NewDep2

      on_exit(fn() -> revert Test.Dependency end)
    end

    test "it swaps" do
      assert Test.TestModule.call() == NewDep2.call()
    end
  end

  test "and then everything is as before" do
    assert Test.TestModule.call() == Test.Dependency.call()
  end
end
